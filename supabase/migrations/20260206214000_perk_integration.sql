-- =====================================================
-- PERK INTEGRATION MIGRATIONS
-- Implement all prestige perk effects
-- Applied: 2026-02-06
-- =====================================================

-- 1. Add vote_weights column for influence perk tracking
ALTER TABLE proposals
ADD COLUMN IF NOT EXISTS vote_weights JSONB DEFAULT '{}';

-- 2. Updated resolve_proposal with influence perk (1.5x vote weight)
CREATE OR REPLACE FUNCTION resolve_proposal(p_proposal_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_proposal RECORD;
  v_support_weight DECIMAL := 0;
  v_reject_weight DECIMAL := 0;
  v_voter_id UUID;
  v_voter RECORD;
  v_approved BOOLEAN;
  v_target RECORD;
BEGIN
  SELECT * INTO v_proposal FROM proposals WHERE id = p_proposal_id;
  
  IF v_proposal IS NULL THEN
    RAISE EXCEPTION 'Proposal not found';
  END IF;
  
  IF v_proposal.votes_end_at > NOW() THEN
    RAISE EXCEPTION 'Voting period not ended yet';
  END IF;
  
  IF v_proposal.status != 'active' THEN
    RAISE EXCEPTION 'Proposal already resolved';
  END IF;
  
  -- Calculate weighted support votes (influence perk = 1.5x)
  FOREACH v_voter_id IN ARRAY v_proposal.support_voter_ids LOOP
    SELECT * INTO v_voter FROM users WHERE id = v_voter_id;
    IF v_voter IS NOT NULL AND 'influence' = ANY(v_voter.ascension_perks) THEN
      v_support_weight := v_support_weight + 1.5;
    ELSE
      v_support_weight := v_support_weight + 1.0;
    END IF;
  END LOOP;
  
  -- Calculate weighted reject votes
  FOREACH v_voter_id IN ARRAY v_proposal.reject_voter_ids LOOP
    SELECT * INTO v_voter FROM users WHERE id = v_voter_id;
    IF v_voter IS NOT NULL AND 'influence' = ANY(v_voter.ascension_perks) THEN
      v_reject_weight := v_reject_weight + 1.5;
    ELSE
      v_reject_weight := v_reject_weight + 1.0;
    END IF;
  END LOOP;
  
  -- Determine outcome (support must be strictly greater)
  v_approved := v_support_weight > v_reject_weight;
  
  -- Update proposal status
  UPDATE proposals 
  SET status = CASE WHEN v_approved THEN 'approved' ELSE 'rejected' END,
      vote_weights = jsonb_build_object('support', v_support_weight, 'reject', v_reject_weight)
  WHERE id = p_proposal_id;
  
  -- If approved, apply the effect
  IF v_approved AND NOT v_proposal.shielded THEN
    SELECT * INTO v_target FROM users WHERE id = v_proposal.target_user_id;
    
    IF v_proposal.type = 'penalty' THEN
      UPDATE users 
      SET aura = GREATEST(0, aura - v_proposal.amount),
          is_broken = (aura - v_proposal.amount) <= 0,
          last_penalty_at = NOW()
      WHERE id = v_proposal.target_user_id;
      
      INSERT INTO aura_events (user_id, amount, source, metadata)
      VALUES (v_proposal.target_user_id, -v_proposal.amount, 'penalty', 
        jsonb_build_object('proposal_id', p_proposal_id, 'support_weight', v_support_weight, 'reject_weight', v_reject_weight));
    ELSE
      UPDATE users SET aura = aura + v_proposal.amount WHERE id = v_proposal.target_user_id;
      
      INSERT INTO aura_events (user_id, amount, source, metadata)
      VALUES (v_proposal.target_user_id, v_proposal.amount, 'boost',
        jsonb_build_object('proposal_id', p_proposal_id, 'support_weight', v_support_weight, 'reject_weight', v_reject_weight));
    END IF;
  END IF;
  
  -- Auto-reveal anonymous proposals after resolution
  IF v_proposal.is_anonymous AND v_proposal.revealed_at IS NULL THEN
    UPDATE proposals SET revealed_at = NOW() WHERE id = p_proposal_id;
  END IF;
  
  RETURN jsonb_build_object(
    'approved', v_approved,
    'support_weight', v_support_weight,
    'reject_weight', v_reject_weight,
    'shielded', v_proposal.shielded
  );
END;
$$;

-- 3. Updated use_shield with guardian perk (5 days instead of 7)
DROP FUNCTION IF EXISTS use_shield(UUID);
CREATE FUNCTION use_shield(p_proposal_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_user RECORD;
  v_proposal RECORD;
  v_cooldown_days INT := 7;
  v_has_guardian BOOLEAN := false;
BEGIN
  SELECT * INTO v_user FROM users WHERE id = v_user_id;
  SELECT * INTO v_proposal FROM proposals WHERE id = p_proposal_id;
  
  IF v_user IS NULL THEN RAISE EXCEPTION 'User not found'; END IF;
  IF v_proposal IS NULL THEN RAISE EXCEPTION 'Proposal not found'; END IF;
  IF v_proposal.target_user_id != v_user_id THEN RAISE EXCEPTION 'You can only shield proposals targeting you'; END IF;
  IF v_proposal.type != 'penalty' THEN RAISE EXCEPTION 'Can only shield penalty proposals'; END IF;
  IF v_proposal.status != 'approved' THEN RAISE EXCEPTION 'Can only shield approved proposals'; END IF;
  IF v_proposal.shielded THEN RAISE EXCEPTION 'Proposal already shielded'; END IF;
  IF NOW() > v_proposal.votes_end_at + INTERVAL '1 hour' THEN RAISE EXCEPTION 'Shield window expired'; END IF;
  
  -- Guardian perk reduces cooldown
  v_has_guardian := 'guardian' = ANY(v_user.ascension_perks);
  IF v_has_guardian THEN v_cooldown_days := 5; END IF;
  
  -- Check cooldown
  IF v_user.last_shield_used IS NOT NULL 
     AND v_user.last_shield_used > NOW() - (v_cooldown_days || ' days')::interval THEN
    RAISE EXCEPTION 'Shield on cooldown';
  END IF;
  
  -- Apply shield
  UPDATE proposals SET shielded = true WHERE id = p_proposal_id;
  UPDATE users SET last_shield_used = NOW() WHERE id = v_user_id;
  UPDATE users SET aura = aura + v_proposal.amount, is_broken = false WHERE id = v_user_id;
  
  INSERT INTO aura_events (user_id, amount, source, metadata)
  VALUES (v_user_id, v_proposal.amount, 'shield_used', 
    jsonb_build_object('proposal_id', p_proposal_id, 'had_guardian', v_has_guardian));
  
  RETURN jsonb_build_object('success', true, 'aura_restored', v_proposal.amount);
END;
$$;

-- 4. Updated apply_daily_decay with resilience perk (2 days instead of 1)
DROP FUNCTION IF EXISTS apply_daily_decay();
CREATE FUNCTION apply_daily_decay()
RETURNS INT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_users_affected INT := 0;
  v_user RECORD;
  v_decay_amount INT;
  v_days_since_claim INT;
  v_days_required INT;
  v_has_resilience BOOLEAN;
BEGIN
  FOR v_user IN 
    SELECT * FROM users 
    WHERE aura > 0 AND NOT is_broken AND last_daily_claim IS NOT NULL AND last_daily_claim < CURRENT_DATE
  LOOP
    -- Resilience perk delays decay by 1 day
    v_has_resilience := 'resilience' = ANY(v_user.ascension_perks);
    v_days_required := CASE WHEN v_has_resilience THEN 2 ELSE 1 END;
    v_days_since_claim := CURRENT_DATE - v_user.last_daily_claim;
    
    IF v_days_since_claim >= v_days_required AND v_user.last_decay_at != CURRENT_DATE THEN
      v_decay_amount := LEAST(5, v_days_since_claim - v_days_required + 1);
      
      UPDATE users SET aura = GREATEST(0, aura - v_decay_amount), last_decay_at = CURRENT_DATE WHERE id = v_user.id;
      
      INSERT INTO aura_events (user_id, amount, source, metadata)
      VALUES (v_user.id, -v_decay_amount, 'decay', jsonb_build_object('days_since_claim', v_days_since_claim, 'had_resilience', v_has_resilience));
      
      v_users_affected := v_users_affected + 1;
    END IF;
  END LOOP;
  RETURN v_users_affected;
END;
$$;

-- Comments
COMMENT ON FUNCTION resolve_proposal(UUID) IS 'Resolve proposal with weighted votes (influence perk = 1.5x)';
COMMENT ON FUNCTION use_shield(UUID) IS 'Use shield (guardian perk = 5 day cooldown)';
COMMENT ON FUNCTION apply_daily_decay() IS 'Apply decay (resilience perk = 2 day delay)';
