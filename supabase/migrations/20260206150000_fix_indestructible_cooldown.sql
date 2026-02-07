-- Migration: Fix indestructible cooldown
-- Applied: 2026-02-06

-- Add tracking column for indestructible cooldown
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS last_indestructible_granted_at TIMESTAMP WITH TIME ZONE;

-- Update trigger: require 3 days since EITHER penalty OR last indestructible grant
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
      -- Rule 3: Indestructible not granted in the last 3 days (COOLDOWN)
      IF (OLD.last_penalty_at IS NULL OR OLD.last_penalty_at < (NOW() - INTERVAL '3 days'))
         AND (OLD.last_indestructible_granted_at IS NULL 
              OR OLD.last_indestructible_granted_at < (NOW() - INTERVAL '3 days'))
      THEN
        -- Grant Indestructible Virgin status for 12 hours
        NEW.indestructible_until := NOW() + INTERVAL '12 hours';
        -- Track when we granted it (for cooldown)
        NEW.last_indestructible_granted_at := NOW();
      END IF;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
