-- Indexes for Users Table
-- Optimizes Leaderboard sorting
CREATE INDEX IF NOT EXISTS idx_users_aura_desc ON users (aura DESC);

-- Optimizes Aura Decay job (finding inactive users)
CREATE INDEX IF NOT EXISTS idx_users_last_daily_claim ON users (last_daily_claim);

-- Indexes for Proposals Table
-- Optimizes "Indestructible Virgin" checks (finding active penalties against a user)
CREATE INDEX IF NOT EXISTS idx_proposals_target_user_id ON proposals (target_user_id);

-- Optimizes filtering of expired/active proposals
CREATE INDEX IF NOT EXISTS idx_proposals_closes_at ON proposals (closes_at);

-- Indexes for Aura Events Table
-- Optimizes Global History feed
CREATE INDEX IF NOT EXISTS idx_aura_events_created_at_desc ON aura_events (created_at DESC);

-- Optimizes User History loading (fetching events for a specific user, sorted by time)
CREATE INDEX IF NOT EXISTS idx_aura_events_user_id_created_at_desc ON aura_events (user_id, created_at DESC);
