-- =====================================================
-- MOMENTUM SYSTEM MIGRATION
-- Replaces simple streak with momentum multiplier
-- Applied: 2026-02-06
-- =====================================================

-- 1. Add momentum_multiplier column (cached for display)
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS momentum_multiplier DECIMAL(3,2) DEFAULT 1.0;

-- 2. Create function to calculate momentum multiplier from streak days
CREATE OR REPLACE FUNCTION get_momentum_multiplier(p_streak INT)
RETURNS DECIMAL(3,2)
LANGUAGE plpgsql
IMMUTABLE
SET search_path TO 'public'
AS $$
BEGIN
  -- Momentum tiers:
  -- Days 1-2:  1.0x
  -- Days 3-4:  1.1x
  -- Days 5-6:  1.2x
  -- Days 7-13: 1.3x
  -- Days 14-29: 1.4x
  -- Days 30+: 1.5x (cap)
  IF p_streak >= 30 THEN RETURN 1.5;
  ELSIF p_streak >= 14 THEN RETURN 1.4;
  ELSIF p_streak >= 7 THEN RETURN 1.3;
  ELSIF p_streak >= 5 THEN RETURN 1.2;
  ELSIF p_streak >= 3 THEN RETURN 1.1;
  ELSE RETURN 1.0;
  END IF;
END;
$$;

-- 3. Create function to get momentum tier name
CREATE OR REPLACE FUNCTION get_momentum_tier_name(p_streak INT)
RETURNS TEXT
LANGUAGE plpgsql
IMMUTABLE
SET search_path TO 'public'
AS $$
BEGIN
  IF p_streak >= 30 THEN RETURN 'UNSTOPPABLE';
  ELSIF p_streak >= 14 THEN RETURN 'ON FIRE';
  ELSIF p_streak >= 7 THEN RETURN 'HOT STREAK';
  ELSIF p_streak >= 5 THEN RETURN 'WARMING UP';
  ELSIF p_streak >= 3 THEN RETURN 'BUILDING';
  ELSE RETURN 'STARTING';
  END IF;
END;
$$;

-- 4. Create function to get penalty for breaking momentum
CREATE OR REPLACE FUNCTION get_momentum_break_penalty(p_streak INT)
RETURNS INT
LANGUAGE plpgsql
IMMUTABLE
SET search_path TO 'public'
AS $$
BEGIN
  -- Penalty tiers:
  -- Days 30+: -30 Aura
  -- Days 14-29: -20 Aura
  -- Days 7-13: -10 Aura
  -- Days 3-6: -5 Aura
  -- Days 1-2: 0 (no penalty for early break)
  IF p_streak >= 30 THEN RETURN 30;
  ELSIF p_streak >= 14 THEN RETURN 20;
  ELSIF p_streak >= 7 THEN RETURN 10;
  ELSIF p_streak >= 3 THEN RETURN 5;
  ELSE RETURN 0;
  END IF;
END;
$$;

-- 5. Update claim_daily_aura to apply momentum multiplier
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
BEGIN
  SELECT * INTO v_user_record FROM users WHERE id = v_user_id;
  
  IF v_user_record.is_broken THEN
    RAISE EXCEPTION 'Cannot claim while Broken';
  END IF;
  
  IF v_user_record.last_daily_claim = CURRENT_DATE THEN
    RAISE EXCEPTION 'Already claimed today';
  END IF;
  
  v_old_streak := v_user_record.streak;
  
  -- Calculate streak and check for momentum break
  IF v_user_record.last_daily_claim = CURRENT_DATE - 1 THEN
    -- Consecutive day - momentum continues
    v_new_streak := v_user_record.streak + 1;
  ELSE
    -- Streak broken - apply penalty if had momentum
    v_new_streak := 1;
    IF v_old_streak >= 3 THEN
      v_broke_momentum := true;
      v_momentum_penalty := get_momentum_break_penalty(v_old_streak);
    END IF;
  END IF;
  
  -- Get momentum multiplier for NEW streak
  v_momentum_multiplier := get_momentum_multiplier(v_new_streak);
  
  -- Get milestone bonus
  v_milestone_bonus := get_streak_milestone_bonus(v_new_streak);
  
  -- Calculate gains with multiplier (apply to base only, not milestone)
  v_multiplied_gain := FLOOR(v_base_gain * v_momentum_multiplier);
  v_total_gain := v_multiplied_gain + v_milestone_bonus - v_momentum_penalty;
  
  -- Ensure we don't go negative from penalty
  IF v_total_gain < 0 THEN
    v_total_gain := 0;
  END IF;
  
  -- Update user
  UPDATE users
  SET aura = GREATEST(0, aura + v_total_gain),
      streak = v_new_streak,
      momentum_multiplier = v_momentum_multiplier,
      last_daily_claim = CURRENT_DATE
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
      'old_streak', v_old_streak
    )
  );
  
  -- If penalty was applied, log separate penalty event
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
    'broke_momentum', v_broke_momentum
  );
END;
$$;

-- 6. Update all existing users to have correct momentum_multiplier based on current streak
UPDATE users 
SET momentum_multiplier = get_momentum_multiplier(streak);

-- 7. Add comment for documentation
COMMENT ON COLUMN users.momentum_multiplier IS 'Cached momentum multiplier based on streak. 1.0x (1-2 days), 1.1x (3-4), 1.2x (5-6), 1.3x (7-13), 1.4x (14-29), 1.5x (30+)';
