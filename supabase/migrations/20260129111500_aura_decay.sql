-- Add last_decay_at column to users table
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS last_decay_at TIMESTAMP WITH TIME ZONE;

-- Function to process Aura Decay (to be run nightly via cron)
CREATE OR REPLACE FUNCTION process_aura_decay()
RETURNS void 
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  r RECORD;
  days_inactive INT;
  decay_amount INT;
  grace_period INTERVAL := '26 hours'; -- 24h + 2h grace
BEGIN
  -- Loop through users who haven't claimed in over 26 hours
  FOR r IN 
    SELECT id, aura, last_daily_claim, last_decay_at
    FROM users
    WHERE last_daily_claim < (NOW() - grace_period)
    -- And we haven't already decayed them comfortably recently (e.g. today)
    AND (last_decay_at IS NULL OR last_decay_at < (NOW() - INTERVAL '20 hours'))
  LOOP
    
    -- Calculate "days" missed (approx) or just apply the flat rule requested
    -- User rule:
    -- 1. First day miss: 25 Aura
    -- 2. Subsequent days: 50 Aura
    
    -- Determine if this is the "first day" of decay or subsequent
    -- If they were decayed yesterday, it's subsequent.
    IF (r.last_decay_at IS NOT NULL AND r.last_decay_at > (NOW() - INTERVAL '48 hours')) THEN
       decay_amount := 50;
    ELSE
       -- First time decaying in this streak of inactivity
       decay_amount := 25;
    END IF;

    -- Update user aura (ensure >= 0) via apply_aura or direct update if we want to bypass events?
    -- No, we MUST log it. So we update manually and insert event.
    
    -- Log event
    INSERT INTO aura_events (user_id, amount, source, metadata)
    VALUES (r.id, -decay_amount, 'decay', '{"reason": "inactivity"}');

    -- Update User
    UPDATE users
    SET 
      aura = GREATEST(aura - decay_amount, 0),
      last_decay_at = NOW()
    WHERE id = r.id;
    
  END LOOP;
END;
$$ LANGUAGE plpgsql;
