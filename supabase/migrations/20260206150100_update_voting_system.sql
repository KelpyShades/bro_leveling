-- Migration: Update voting system
-- Applied: 2026-02-06
-- Changes:
--   - create_proposal: removed 2/day limit, 6h voting window
--   - vote_on_proposal: block target voting, +5 Aura voter reward

-- Update create_proposal: remove 2/day limit, use 6h voting window
CREATE OR REPLACE FUNCTION public.create_proposal(p_target_user_id uuid, p_amount integer, p_type text, p_reason text)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
declare
  v_proposer_id uuid := auth.uid();
  v_proposer users%rowtype;
  v_target users%rowtype;
  v_new_id uuid;
begin
  select * into v_proposer from users where id = v_proposer_id;
  select * into v_target from users where id = p_target_user_id;
  
  if v_proposer.is_broken then
    raise exception 'Cannot create proposals while Broken';
  end if;
  
  -- Validate target exists
  if v_target.id is null then
    raise exception 'Target user not found';
  end if;
  
  -- Validate amount
  if p_type = 'boost' and (p_amount < 1 or p_amount > 100) then
    raise exception 'Boost amount must be 1-100';
  end if;
  
  if p_type = 'penalty' and (p_amount < 1 or p_amount > 100) then
    raise exception 'Penalty amount must be 1-100';
  end if;
  
  -- Create proposal with 6h voting window
  insert into proposals (proposer_id, target_user_id, target_username, amount, type, reason, status, closes_at)
  values (v_proposer_id, p_target_user_id, v_target.username, p_amount, p_type, p_reason, 'pending', now() + interval '6 hours')
  returning id into v_new_id;
  
  return v_new_id;
end;
$$;

-- Update vote_on_proposal: block target voting, add +5 voter reward
CREATE OR REPLACE FUNCTION public.vote_on_proposal(p_proposal_id uuid, p_voter_id uuid, p_vote_value text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_target_user_id uuid;
  v_voter users%rowtype;
BEGIN
    -- Get proposal target
    SELECT target_user_id INTO v_target_user_id 
    FROM proposals 
    WHERE id = p_proposal_id;
    
    -- Block target from voting on their own proposal
    IF p_voter_id = v_target_user_id THEN
        RAISE EXCEPTION 'Cannot vote on proposals targeting yourself';
    END IF;
    
    -- Get voter to check if broken
    SELECT * INTO v_voter FROM users WHERE id = p_voter_id;
    
    IF v_voter.is_broken THEN
        RAISE EXCEPTION 'Cannot vote while Broken';
    END IF;

    -- Check if user has already voted
    IF EXISTS (
        SELECT 1 FROM proposals 
        WHERE id = p_proposal_id 
        AND (p_voter_id = ANY(support_voter_ids) OR p_voter_id = ANY(reject_voter_ids))
    ) THEN
        RAISE EXCEPTION 'User has already voted on this proposal';
    END IF;

    IF p_vote_value = 'support' THEN
        UPDATE proposals 
        SET support_voter_ids = array_append(support_voter_ids, p_voter_id)
        WHERE id = p_proposal_id;
    ELSIF p_vote_value = 'reject' THEN
        UPDATE proposals 
        SET reject_voter_ids = array_append(reject_voter_ids, p_voter_id)
        WHERE id = p_proposal_id;
    ELSE
        RAISE EXCEPTION 'Invalid vote value. Must be support or reject';
    END IF;
    
    -- Grant +5 Aura reward for voting
    UPDATE users SET aura = aura + 5 WHERE id = p_voter_id;
    
    -- Log the voter reward event
    INSERT INTO aura_events (user_id, amount, source, metadata)
    VALUES (p_voter_id, 5, 'vote_reward', jsonb_build_object('proposal_id', p_proposal_id));
END;
$$;
