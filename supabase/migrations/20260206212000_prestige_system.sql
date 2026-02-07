-- =====================================================
-- PRESTIGE / LEGACY SYSTEM MIGRATION
-- Ascend to reset Aura but gain permanent perks
-- Applied: 2026-02-06
-- =====================================================

-- 1. Add prestige columns to users
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS ascension_count INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS ascension_perks TEXT[] DEFAULT '{}',
ADD COLUMN IF NOT EXISTS last_ascension_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS total_aura_earned INT DEFAULT 0;

-- 2. Create enum type for perks (for reference/validation)
-- Perks:
-- 'resilience' - Decay takes 2 days to start instead of 1
-- 'momentum_boost' - Daily claim starts at 1.1x base multiplier
-- 'fortitude' - Proposals targeting you cost proposer 10 Aura extra
-- 'influence' - Your votes count as 1.5 votes
-- 'guardian' - Shield cooldown is 5 days instead of 7
-- 'prosperity' - +5% bonus on all Aura gains

-- 3. Create function to check if user can ascend
CREATE OR REPLACE FUNCTION can_ascend(p_user_id UUID DEFAULT NULL)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_user_id UUID := COALESCE(p_user_id, auth.uid());
  v_user RECORD;
  v_penalties_survived INT := 0;
  v_can_ascend BOOLEAN := false;
  v_reasons TEXT[] := '{}';
BEGIN
  SELECT * INTO v_user FROM users WHERE id = v_user_id;
  
  IF v_user IS NULL THEN
    RETURN jsonb_build_object('can_ascend', false, 'reasons', ARRAY['User not found']);
  END IF;
  
  -- Check Aura requirement (500+)
  IF v_user.aura < 500 THEN
    v_reasons := array_append(v_reasons, 'Need 500+ Aura (current: ' || v_user.aura || ')');
  END IF;
  
  -- Check streak requirement (14+)
  IF v_user.streak < 14 THEN
    v_reasons := array_append(v_reasons, 'Need 14+ day streak (current: ' || v_user.streak || ')');
  END IF;
  
  -- Check survived penalty requirement
  SELECT COUNT(*) INTO v_penalties_survived
  FROM proposals
  WHERE target_user_id = v_user_id
    AND type = 'penalty'
    AND (status = 'rejected' OR shielded = true);
  
  IF v_penalties_survived < 1 THEN
    v_reasons := array_append(v_reasons, 'Need to survive at least 1 penalty proposal');
  END IF;
  
  -- Check max ascension limit (3)
  IF v_user.ascension_count >= 3 THEN
    v_reasons := array_append(v_reasons, 'Maximum ascensions reached (3)');
  END IF;
  
  v_can_ascend := array_length(v_reasons, 1) IS NULL;
  
  RETURN jsonb_build_object(
    'can_ascend', v_can_ascend,
    'reasons', v_reasons,
    'current_aura', v_user.aura,
    'current_streak', v_user.streak,
    'penalties_survived', v_penalties_survived,
    'ascension_count', v_user.ascension_count,
    'available_perks', ARRAY['resilience', 'momentum_boost', 'fortitude', 'influence', 'guardian', 'prosperity'],
    'owned_perks', v_user.ascension_perks
  );
END;
$$;

-- 4. Create ascend function
CREATE OR REPLACE FUNCTION ascend(p_chosen_perk TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_user RECORD;
  v_can_ascend_result JSONB;
  v_valid_perks TEXT[] := ARRAY['resilience', 'momentum_boost', 'fortitude', 'influence', 'guardian', 'prosperity'];
  v_old_aura INT;
BEGIN
  -- Check if can ascend
  v_can_ascend_result := can_ascend(v_user_id);
  
  IF NOT (v_can_ascend_result->>'can_ascend')::boolean THEN
    RAISE EXCEPTION 'Cannot ascend: %', v_can_ascend_result->>'reasons';
  END IF;
  
  -- Validate perk choice
  IF NOT (p_chosen_perk = ANY(v_valid_perks)) THEN
    RAISE EXCEPTION 'Invalid perk: %. Valid perks: %', p_chosen_perk, array_to_string(v_valid_perks, ', ');
  END IF;
  
  -- Get current user
  SELECT * INTO v_user FROM users WHERE id = v_user_id;
  v_old_aura := v_user.aura;
  
  -- Perform ascension
  UPDATE users
  SET 
    aura = 100,
    streak = 0,
    momentum_multiplier = 1.0,
    ascension_count = ascension_count + 1,
    ascension_perks = array_append(ascension_perks, p_chosen_perk),
    last_ascension_at = NOW(),
    total_aura_earned = COALESCE(total_aura_earned, 0) + v_old_aura,
    -- Grant 24h immunity
    indestructible_until = NOW() + INTERVAL '24 hours'
  WHERE id = v_user_id;
  
  -- Log the ascension event
  INSERT INTO aura_events (user_id, amount, source, metadata)
  VALUES (
    v_user_id,
    -v_old_aura + 100,  -- Net change
    'ascension',
    jsonb_build_object(
      'ascension_number', v_user.ascension_count + 1,
      'perk_chosen', p_chosen_perk,
      'aura_sacrificed', v_old_aura
    )
  );
  
  RETURN jsonb_build_object(
    'success', true,
    'new_ascension_count', v_user.ascension_count + 1,
    'perk_gained', p_chosen_perk,
    'aura_sacrificed', v_old_aura,
    'immunity_until', NOW() + INTERVAL '24 hours'
  );
END;
$$;

-- 5. Update claim_daily_aura to apply prosperity perk (+5% gains)
CREATE OR REPLACE FUNCTION public.claim_daily_aura()
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_user_record users%rowtype;
  v_new_streak int;
  v_old_streak int;
  v_milestone_bonus int;
  v_momentum_multiplier decimal(3,2);
  v_base_gain int := 25;
  v_multiplied_gain int;
  v_total_gain int;
  v_momentum_penalty int := 0;
  v_broke_momentum boolean := false;
  v_has_prosperity boolean := false;
  v_has_momentum_boost boolean := false;
  v_prosperity_bonus int := 0;
BEGIN
  SELECT * INTO v_user_record FROM users WHERE id = v_user_id;
  
  IF v_user_record.is_broken THEN
    RAISE EXCEPTION 'Cannot claim while Broken';
  END IF;
  
  IF v_user_record.last_daily_claim = CURRENT_DATE THEN
    RAISE EXCEPTION 'Already claimed today';
  END IF;
  
  -- Check for perks
  v_has_prosperity := 'prosperity' = ANY(v_user_record.ascension_perks);
  v_has_momentum_boost := 'momentum_boost' = ANY(v_user_record.ascension_perks);
  
  v_old_streak := v_user_record.streak;
  
  -- Calculate streak and check for momentum break
  IF v_user_record.last_daily_claim = CURRENT_DATE - 1 THEN
    v_new_streak := v_user_record.streak + 1;
  ELSE
    v_new_streak := 1;
    IF v_old_streak >= 3 THEN
      v_broke_momentum := true;
      v_momentum_penalty := get_momentum_break_penalty(v_old_streak);
    END IF;
  END IF;
  
  -- Get momentum multiplier for NEW streak
  v_momentum_multiplier := get_momentum_multiplier(v_new_streak);
  
  -- Apply momentum_boost perk (adds 0.1 to base multiplier)
  IF v_has_momentum_boost THEN
    v_momentum_multiplier := v_momentum_multiplier + 0.1;
  END IF;
  
  -- Get milestone bonus
  v_milestone_bonus := get_streak_milestone_bonus(v_new_streak);
  
  -- Calculate gains with multiplier
  v_multiplied_gain := FLOOR(v_base_gain * v_momentum_multiplier);
  v_total_gain := v_multiplied_gain + v_milestone_bonus - v_momentum_penalty;
  
  -- Apply prosperity perk (+5% to total gain before penalty)
  IF v_has_prosperity AND v_total_gain > 0 THEN
    v_prosperity_bonus := CEIL(v_total_gain * 0.05);
    v_total_gain := v_total_gain + v_prosperity_bonus;
  END IF;
  
  -- Ensure we don't go negative from penalty
  IF v_total_gain < 0 THEN
    v_total_gain := 0;
  END IF;
  
  -- Update user
  UPDATE users
  SET aura = GREATEST(0, aura + v_total_gain),
      streak = v_new_streak,
      momentum_multiplier = v_momentum_multiplier,
      last_daily_claim = CURRENT_DATE,
      total_aura_earned = COALESCE(total_aura_earned, 0) + GREATEST(0, v_total_gain)
  WHERE id = v_user_id;
  
  -- Log event
  INSERT INTO aura_events (user_id, amount, source, metadata)
  VALUES (
    v_user_id, 
    v_total_gain, 
    'daily_claim', 
    jsonb_build_object(
      'streak', v_new_streak, 
      'milestone_bonus', v_milestone_bonus,
      'momentum_multiplier', v_momentum_multiplier,
      'base_gain', v_base_gain,
      'multiplied_gain', v_multiplied_gain,
      'momentum_penalty', v_momentum_penalty,
      'broke_momentum', v_broke_momentum,
      'old_streak', v_old_streak,
      'prosperity_bonus', v_prosperity_bonus,
      'has_momentum_boost', v_has_momentum_boost
    )
  );
  
  -- Log momentum break penalty separately
  IF v_momentum_penalty > 0 THEN
    INSERT INTO aura_events (user_id, amount, source, metadata)
    VALUES (
      v_user_id,
      -v_momentum_penalty,
      'momentum_break',
      jsonb_build_object('old_streak', v_old_streak, 'penalty', v_momentum_penalty)
    );
  END IF;
  
  RETURN jsonb_build_object(
    'aura_gained', v_total_gain,
    'new_streak', v_new_streak,
    'milestone_bonus', v_milestone_bonus,
    'momentum_multiplier', v_momentum_multiplier,
    'momentum_penalty', v_momentum_penalty,
    'broke_momentum', v_broke_momentum,
    'prosperity_bonus', v_prosperity_bonus
  );
END;
$$;

-- 6. Add comments
COMMENT ON COLUMN users.ascension_count IS 'Number of times user has ascended. Max 3.';
COMMENT ON COLUMN users.ascension_perks IS 'Array of perk names gained from ascension.';
COMMENT ON COLUMN users.last_ascension_at IS 'Timestamp of last ascension (24h immunity starts here).';
COMMENT ON COLUMN users.total_aura_earned IS 'Lifetime Aura earned (for leaderboard stats).';
