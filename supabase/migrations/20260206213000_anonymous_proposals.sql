-- =====================================================
-- ANONYMOUS PROPOSALS MIGRATION
-- Allow proposers to submit proposals anonymously
-- Applied: 2026-02-06
-- =====================================================

-- 1. Add anonymous column to proposals
ALTER TABLE proposals 
ADD COLUMN IF NOT EXISTS is_anonymous BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS revealed_at TIMESTAMPTZ;

-- 2. Update create_proposal function to support anonymity
CREATE OR REPLACE FUNCTION create_proposal(
  p_target_user_id UUID,
  p_type TEXT,
  p_amount INT,
  p_reason TEXT,
  p_is_anonymous BOOLEAN DEFAULT false
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_proposer_id UUID := auth.uid();
  v_proposer RECORD;
  v_target RECORD;
  v_proposal_cost INT := 0;  -- Base cost is now 0
  v_anonymous_cost INT := 0;
  v_total_cost INT;
  v_has_fortitude BOOLEAN := false;
  v_fortitude_cost INT := 0;
  v_proposal_id UUID;
BEGIN
  -- Validation
  IF p_type NOT IN ('buff', 'penalty') THEN
    RAISE EXCEPTION 'Invalid proposal type';
  END IF;
  
  IF p_amount <= 0 OR p_amount > 50 THEN
    RAISE EXCEPTION 'Amount must be between 1 and 50';
  END IF;
  
  IF v_proposer_id = p_target_user_id THEN
    RAISE EXCEPTION 'Cannot propose against yourself';
  END IF;
  
  -- Get proposer and target
  SELECT * INTO v_proposer FROM users WHERE id = v_proposer_id;
  SELECT * INTO v_target FROM users WHERE id = p_target_user_id;
  
  IF v_proposer IS NULL THEN
    RAISE EXCEPTION 'Proposer not found';
  END IF;
  
  IF v_target IS NULL THEN
    RAISE EXCEPTION 'Target user not found';
  END IF;
  
  -- PENALTY proposals have costs, BOOST proposals are FREE
  IF p_type = 'penalty' THEN
    v_proposal_cost := 10;  -- Base cost for penalties
    
    -- Check for target's fortitude perk (penalties cost +10)
    IF 'fortitude' = ANY(v_target.ascension_perks) THEN
      v_has_fortitude := true;
      v_fortitude_cost := 10;
    END IF;
    
    -- Anonymous cost: +5 for penalty proposals
    IF p_is_anonymous THEN
      v_anonymous_cost := 5;
    END IF;
  END IF;
  
  -- Calculate total cost
  v_total_cost := v_proposal_cost + v_fortitude_cost + v_anonymous_cost;
  
  -- Check if proposer can afford (only matters for penalties)
  IF v_total_cost > 0 AND v_proposer.aura < v_total_cost THEN
    RAISE EXCEPTION 'Insufficient Aura. Need % (base 10 + % fortitude + % anonymous)', 
      v_total_cost, v_fortitude_cost, v_anonymous_cost;
  END IF;
  
  -- Deduct cost from proposer (if any)
  IF v_total_cost > 0 THEN
  -- Deduct cost from proposer
  UPDATE users 
  SET aura = aura - v_total_cost 
  WHERE id = v_proposer_id;
  
  -- Create proposal
  INSERT INTO proposals (
    proposer_id, 
    target_user_id, 
    type, 
    amount, 
    reason,
    is_anonymous,
    status,
    votes_end_at
  ) VALUES (
    v_proposer_id,
    p_target_user_id,
    p_type,
    p_amount,
    p_reason,
    p_is_anonymous,
    'active',
    NOW() + INTERVAL '24 hours'
  ) RETURNING id INTO v_proposal_id;
  
  -- Log the proposal creation
  INSERT INTO aura_events (user_id, amount, source, metadata)
  VALUES (
    v_proposer_id,
    -v_total_cost,
    'proposal_created',
    jsonb_build_object(
      'proposal_id', v_proposal_id,
      'type', p_type,
      'amount', p_amount,
      'target_id', p_target_user_id,
      'is_anonymous', p_is_anonymous,
      'fortitude_cost', v_fortitude_cost,
      'anonymous_cost', v_anonymous_cost
    )
  );
  
  RETURN jsonb_build_object(
    'success', true,
    'proposal_id', v_proposal_id,
    'cost', v_total_cost,
    'is_anonymous', p_is_anonymous
  );
END;
$$;

-- 3. Create function to reveal anonymous proposals (after voting ends)
CREATE OR REPLACE FUNCTION reveal_proposal(p_proposal_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_proposal RECORD;
BEGIN
  SELECT * INTO v_proposal FROM proposals WHERE id = p_proposal_id;
  
  IF v_proposal IS NULL THEN
    RAISE EXCEPTION 'Proposal not found';
  END IF;
  
  -- Can only reveal after voting ends
  IF v_proposal.votes_end_at > NOW() THEN
    RAISE EXCEPTION 'Cannot reveal until voting ends';
  END IF;
  
  -- Update revealed_at
  UPDATE proposals 
  SET revealed_at = NOW() 
  WHERE id = p_proposal_id;
  
  RETURN jsonb_build_object(
    'success', true,
    'proposer_id', v_proposal.proposer_id
  );
END;
$$;

-- 4. Create view for proposals with usernames (security_invoker = true for proper RLS)
DROP VIEW IF EXISTS proposals_with_usernames;
CREATE VIEW proposals_with_usernames 
WITH (security_invoker = true)
AS
SELECT 
  p.id,
  p.proposer_id,
  p.target_user_id,
  p.amount,
  p.type,
  p.reason,
  p.status,
  p.created_at,
  p.closes_at,
  p.support_voter_ids,
  p.reject_voter_ids,
  p.shielded,
  p.is_anonymous,
  p.revealed_at,
  target.username as target_username,
  proposer.username as proposer_username
FROM proposals p
LEFT JOIN users target ON p.target_user_id = target.id
LEFT JOIN users proposer ON p.proposer_id = proposer.id;

-- Grant access
GRANT SELECT ON proposals_with_usernames TO authenticated;

-- 5. Add index for anonymous queries
CREATE INDEX IF NOT EXISTS idx_proposals_anonymous ON proposals(is_anonymous) WHERE is_anonymous = true;

-- 6. Add comments
COMMENT ON COLUMN proposals.is_anonymous IS 'Whether the proposer identity is hidden during voting';
COMMENT ON COLUMN proposals.revealed_at IS 'When the proposer identity was revealed (after voting ends)';
