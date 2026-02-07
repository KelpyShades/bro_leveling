-- =====================================================
-- BOUNTY SYSTEM MIGRATION
-- Server-computed bounties from existing aura_events
-- No new tables, no sync issues
-- Applied: 2026-02-06
-- =====================================================

-- 1. Add bounty tracking columns to users (for preventing double claims)
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS last_bounty_check_daily DATE,
ADD COLUMN IF NOT EXISTS last_bounty_check_weekly DATE;

-- 2. Create function to get start of current week (Monday 00:00 UTC)
CREATE OR REPLACE FUNCTION get_week_start()
RETURNS TIMESTAMPTZ
LANGUAGE sql
IMMUTABLE
SET search_path TO 'public'
AS $$
  SELECT date_trunc('week', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::timestamptz;
$$;

-- 3. Main function: Get bounty progress and auto-claim completed bounties
CREATE OR REPLACE FUNCTION get_bounty_progress()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_user RECORD;
  v_today DATE := CURRENT_DATE;
  v_week_start TIMESTAMPTZ := get_week_start();
  v_today_start TIMESTAMPTZ := CURRENT_DATE::timestamptz;
  
  -- Daily counts
  v_votes_today INT := 0;
  v_claimed_today BOOLEAN := false;
  
  -- Weekly counts
  v_votes_week INT := 0;
  v_proposals_created_week INT := 0;
  v_proposals_approved_week INT := 0;
  v_penalties_survived_week INT := 0;
  
  -- Bounty rewards to grant
  v_daily_rewards INT := 0;
  v_weekly_rewards INT := 0;
  v_bounties_completed JSONB := '[]'::jsonb;
  
  -- Previous bounty check dates
  v_last_daily_check DATE;
  v_last_weekly_check DATE;
BEGIN
  -- Get user record
  SELECT * INTO v_user FROM users WHERE id = v_user_id;
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'User not found';
  END IF;
  
  v_last_daily_check := v_user.last_bounty_check_daily;
  v_last_weekly_check := v_user.last_bounty_check_weekly;
  
  -- ============ DAILY BOUNTY CALCULATIONS ============
  
  -- Count votes today
  SELECT COUNT(*) INTO v_votes_today
  FROM aura_events
  WHERE user_id = v_user_id
    AND source = 'vote_reward'
    AND created_at >= v_today_start;
  
  -- Check if claimed daily today
  SELECT EXISTS(
    SELECT 1 FROM aura_events
    WHERE user_id = v_user_id
      AND source = 'daily_claim'
      AND created_at >= v_today_start
  ) INTO v_claimed_today;
  
  -- ============ WEEKLY BOUNTY CALCULATIONS ============
  
  -- Count votes this week
  SELECT COUNT(*) INTO v_votes_week
  FROM aura_events
  WHERE user_id = v_user_id
    AND source = 'vote_reward'
    AND created_at >= v_week_start;
  
  -- Count proposals created this week (by this user as proposer)
  SELECT COUNT(*) INTO v_proposals_created_week
  FROM proposals
  WHERE proposer_id = v_user_id
    AND created_at >= v_week_start;
  
  -- Count proposals approved this week (by this user as proposer)
  SELECT COUNT(*) INTO v_proposals_approved_week
  FROM proposals
  WHERE proposer_id = v_user_id
    AND status = 'approved'
    AND updated_at >= v_week_start;
  
  -- Count penalties survived this week (targeted but rejected/shielded)
  SELECT COUNT(*) INTO v_penalties_survived_week
  FROM proposals
  WHERE target_user_id = v_user_id
    AND type = 'penalty'
    AND (status = 'rejected' OR shielded = true)
    AND updated_at >= v_week_start;
  
  -- ============ AUTO-CLAIM DAILY BOUNTIES ============
  -- Only if we haven't checked today yet
  IF v_last_daily_check IS NULL OR v_last_daily_check < v_today THEN
    -- Bounty: Vote on 2+ proposals (+3)
    IF v_votes_today >= 2 THEN
      v_daily_rewards := v_daily_rewards + 3;
      v_bounties_completed := v_bounties_completed || '["vote_2_daily"]'::jsonb;
    END IF;
    
    -- Bounty: Maintain streak / claimed daily (+2)
    IF v_claimed_today AND v_user.streak >= 2 THEN
      v_daily_rewards := v_daily_rewards + 2;
      v_bounties_completed := v_bounties_completed || '["maintain_streak"]'::jsonb;
    END IF;
    
    -- Apply daily rewards
    IF v_daily_rewards > 0 THEN
      UPDATE users SET aura = aura + v_daily_rewards WHERE id = v_user_id;
      
      INSERT INTO aura_events (user_id, amount, source, metadata)
      VALUES (v_user_id, v_daily_rewards, 'bounty', jsonb_build_object(
        'type', 'daily',
        'bounties', v_bounties_completed
      ));
    END IF;
    
    -- Mark daily bounties as checked
    UPDATE users SET last_bounty_check_daily = v_today WHERE id = v_user_id;
  END IF;
  
  -- ============ AUTO-CLAIM WEEKLY BOUNTIES ============
  -- Only if we haven't checked this week yet
  IF v_last_weekly_check IS NULL OR v_last_weekly_check < v_week_start::date THEN
    -- Reset for weekly tracking
    v_bounties_completed := '[]'::jsonb;
    
    -- Bounty: Vote on 5+ proposals (+15)
    IF v_votes_week >= 5 THEN
      v_weekly_rewards := v_weekly_rewards + 15;
      v_bounties_completed := v_bounties_completed || '["vote_5_weekly"]'::jsonb;
    END IF;
    
    -- Bounty: Create a proposal (+10)
    IF v_proposals_created_week >= 1 THEN
      v_weekly_rewards := v_weekly_rewards + 10;
      v_bounties_completed := v_bounties_completed || '["create_proposal"]'::jsonb;
    END IF;
    
    -- Bounty: Have proposal approved (+25)
    IF v_proposals_approved_week >= 1 THEN
      v_weekly_rewards := v_weekly_rewards + 25;
      v_bounties_completed := v_bounties_completed || '["proposal_approved"]'::jsonb;
    END IF;
    
    -- Bounty: Survive penalty targeting you (+20)
    IF v_penalties_survived_week >= 1 THEN
      v_weekly_rewards := v_weekly_rewards + 20;
      v_bounties_completed := v_bounties_completed || '["survive_penalty"]'::jsonb;
    END IF;
    
    -- Apply weekly rewards
    IF v_weekly_rewards > 0 THEN
      UPDATE users SET aura = aura + v_weekly_rewards WHERE id = v_user_id;
      
      INSERT INTO aura_events (user_id, amount, source, metadata)
      VALUES (v_user_id, v_weekly_rewards, 'bounty', jsonb_build_object(
        'type', 'weekly',
        'bounties', v_bounties_completed
      ));
    END IF;
    
    -- Mark weekly bounties as checked
    UPDATE users SET last_bounty_check_weekly = v_week_start::date WHERE id = v_user_id;
  END IF;
  
  -- ============ RETURN CURRENT PROGRESS ============
  RETURN jsonb_build_object(
    'daily', jsonb_build_object(
      'votes_today', v_votes_today,
      'claimed_today', v_claimed_today,
      'streak', v_user.streak,
      'bounties', jsonb_build_object(
        'vote_2', jsonb_build_object('progress', v_votes_today, 'target', 2, 'reward', 3, 'complete', v_votes_today >= 2),
        'maintain_streak', jsonb_build_object('progress', CASE WHEN v_claimed_today AND v_user.streak >= 2 THEN 1 ELSE 0 END, 'target', 1, 'reward', 2, 'complete', v_claimed_today AND v_user.streak >= 2)
      )
    ),
    'weekly', jsonb_build_object(
      'votes_week', v_votes_week,
      'proposals_created', v_proposals_created_week,
      'proposals_approved', v_proposals_approved_week,
      'penalties_survived', v_penalties_survived_week,
      'bounties', jsonb_build_object(
        'vote_5', jsonb_build_object('progress', v_votes_week, 'target', 5, 'reward', 15, 'complete', v_votes_week >= 5),
        'create_proposal', jsonb_build_object('progress', v_proposals_created_week, 'target', 1, 'reward', 10, 'complete', v_proposals_created_week >= 1),
        'proposal_approved', jsonb_build_object('progress', v_proposals_approved_week, 'target', 1, 'reward', 25, 'complete', v_proposals_approved_week >= 1),
        'survive_penalty', jsonb_build_object('progress', v_penalties_survived_week, 'target', 1, 'reward', 20, 'complete', v_penalties_survived_week >= 1)
      )
    ),
    'rewards_granted', jsonb_build_object(
      'daily', v_daily_rewards,
      'weekly', v_weekly_rewards
    )
  );
END;
$$;

-- 4. Add comments
COMMENT ON FUNCTION get_bounty_progress() IS 'Gets bounty progress and auto-claims completed bounties. Call periodically (on app open, after actions).';
