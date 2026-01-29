-- Add columns to users table
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS last_penalty_at TIMESTAMP WITH TIME ZONE,
ADD COLUMN IF NOT EXISTS indestructible_until TIMESTAMP WITH TIME ZONE;

-- 1. Trigger to update last_penalty_at when a penalty proposal is approved
CREATE OR REPLACE FUNCTION update_last_penalty_timestamp()
RETURNS TRIGGER 
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Only run if status changed to approved and it is a penalty
  IF NEW.status = 'approved' AND NEW.type = 'penalty' THEN
    UPDATE users
    SET last_penalty_at = NEW.created_at -- Using created_at or NOW()
    WHERE id = NEW.target_user_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_update_last_penalty ON proposals;
CREATE TRIGGER tr_update_last_penalty
AFTER UPDATE OF status ON proposals
FOR EACH ROW
EXECUTE FUNCTION update_last_penalty_timestamp();


-- 2. Trigger to grant Indestructible Virgin mode on Daily Claim
-- We hook into the update of last_daily_claim on the users table
CREATE OR REPLACE FUNCTION check_grant_indestructible()
RETURNS TRIGGER 
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Only run if last_daily_claim is being updated (signifying a claim)
  IF OLD.last_daily_claim IS DISTINCT FROM NEW.last_daily_claim THEN
    -- Check if no penalties in the last 3 days
    -- If last_penalty_at is NULL, they are eligible (never had a penalty, or clean slate)
    -- OR if last_penalty_at is older than 3 days
    IF (OLD.last_penalty_at IS NULL OR OLD.last_penalty_at < (NOW() - INTERVAL '3 days')) THEN
      -- Grant Indestructible Virgin status for 12 hours
      NEW.indestructible_until := NOW() + INTERVAL '12 hours';
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_indestructible_on_claim ON users;
CREATE TRIGGER tr_indestructible_on_claim
BEFORE UPDATE OF last_daily_claim ON users
FOR EACH ROW
EXECUTE FUNCTION check_grant_indestructible();


-- 3. Trigger to BLOCK creating penalties against an Indestructible user
CREATE OR REPLACE FUNCTION block_indestructible_penalty()
RETURNS TRIGGER 
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  target_indestructible_until TIMESTAMP WITH TIME ZONE;
BEGIN
  IF NEW.type = 'penalty' THEN
    SELECT indestructible_until INTO target_indestructible_until
    FROM users
    WHERE id = NEW.target_user_id;

    IF target_indestructible_until IS NOT NULL AND target_indestructible_until > NOW() THEN
      RAISE EXCEPTION 'Cannot propose penalty: User is in Indestructible Virgin mode until %', target_indestructible_until;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_block_indestructible_penalty ON proposals;
CREATE TRIGGER tr_block_indestructible_penalty
BEFORE INSERT ON proposals
FOR EACH ROW
EXECUTE FUNCTION block_indestructible_penalty();
