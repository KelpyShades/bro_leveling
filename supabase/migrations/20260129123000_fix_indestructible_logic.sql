-- Fix Indestructible Virgin Logic: Ensure user is at least 3 days old
CREATE OR REPLACE FUNCTION check_grant_indestructible()
RETURNS TRIGGER 
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Only run if last_daily_claim is being updated (signifying a claim)
  IF OLD.last_daily_claim IS DISTINCT FROM NEW.last_daily_claim THEN
    -- Rule 1: User must be at least 3 days old to prevent new account abuse
    IF OLD.created_at < (NOW() - INTERVAL '3 days') THEN
      -- Rule 2: No penalties in the last 3 days
      -- If last_penalty_at is NULL (never had penalty) OR older than 3 days
      IF (OLD.last_penalty_at IS NULL OR OLD.last_penalty_at < (NOW() - INTERVAL '3 days')) THEN
        -- Grant Indestructible Virgin status for 12 hours
        NEW.indestructible_until := NOW() + INTERVAL '12 hours';
      END IF;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
