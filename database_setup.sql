-- =====================================================
-- SUGESTO APP - INVITE FRIENDS MODULE
-- Database Tables Creation Script
-- =====================================================
-- Run this entire script in Supabase SQL Editor
-- No Row Level Security (RLS) as requested
-- =====================================================

-- =====================================================
-- TABLE: user_invites
-- Stores unique invite codes and statistics for each user
-- =====================================================
CREATE TABLE IF NOT EXISTS user_invites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    invite_code TEXT NOT NULL UNIQUE,
    total_invites INTEGER DEFAULT 0,
    successful_invites INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    CONSTRAINT fk_user_invites_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =====================================================
-- TABLE: invite_usage
-- Tracks individual invite link usage and referrals
-- =====================================================
CREATE TABLE IF NOT EXISTS invite_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invite_code TEXT NOT NULL,
    inviter_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    invited_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    invited_email TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    used_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    CONSTRAINT fk_invite_usage_inviter FOREIGN KEY (inviter_user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_invite_usage_invited FOREIGN KEY (invited_user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT unique_invite_usage UNIQUE(invite_code, invited_email),
    CONSTRAINT check_status CHECK (status IN ('pending', 'completed', 'expired'))
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_user_invites_user_id ON user_invites(user_id);
CREATE INDEX IF NOT EXISTS idx_user_invites_invite_code ON user_invites(invite_code);
CREATE INDEX IF NOT EXISTS idx_invite_usage_invite_code ON invite_usage(invite_code);
CREATE INDEX IF NOT EXISTS idx_invite_usage_inviter_user_id ON invite_usage(inviter_user_id);
CREATE INDEX IF NOT EXISTS idx_invite_usage_invited_user_id ON invite_usage(invited_user_id);
CREATE INDEX IF NOT EXISTS idx_invite_usage_status ON invite_usage(status);
CREATE INDEX IF NOT EXISTS idx_invite_usage_invited_email ON invite_usage(invited_email);

-- =====================================================
-- FUNCTION: Update updated_at timestamp automatically
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- TRIGGER: Auto-update updated_at on user_invites
-- =====================================================
DROP TRIGGER IF EXISTS update_user_invites_updated_at ON user_invites;
CREATE TRIGGER update_user_invites_updated_at
    BEFORE UPDATE ON user_invites
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- COMMENTS FOR DOCUMENTATION
-- =====================================================
COMMENT ON TABLE user_invites IS 'Stores unique invite codes and referral statistics for each user';
COMMENT ON TABLE invite_usage IS 'Tracks individual invite link usage and referral conversions';

COMMENT ON COLUMN user_invites.invite_code IS 'Unique 8-character alphanumeric invite code';
COMMENT ON COLUMN user_invites.total_invites IS 'Total number of times invite was attempted (not used yet)';
COMMENT ON COLUMN user_invites.successful_invites IS 'Number of successful referrals (completed signups)';

COMMENT ON COLUMN invite_usage.status IS 'Invite status: pending (email used code), completed (user registered), expired (code expired)';
COMMENT ON COLUMN invite_usage.used_at IS 'Timestamp when invite code was first used during signup attempt';
COMMENT ON COLUMN invite_usage.completed_at IS 'Timestamp when user successfully completed registration';

-- =====================================================
-- VERIFICATION QUERIES
-- Run these to verify tables were created successfully
-- =====================================================

-- Check if tables exist
SELECT 
    table_name, 
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('user_invites', 'invite_usage')
ORDER BY table_name;

-- Check columns in user_invites
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'user_invites'
ORDER BY ordinal_position;

-- Check columns in invite_usage
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'invite_usage'
ORDER BY ordinal_position;

-- Check indexes
SELECT 
    indexname, 
    indexdef
FROM pg_indexes
WHERE tablename IN ('user_invites', 'invite_usage')
ORDER BY tablename, indexname;

-- =====================================================
-- SAMPLE QUERIES FOR TESTING
-- =====================================================

-- Get invite statistics for a specific user
-- SELECT * FROM user_invites WHERE user_id = 'YOUR_USER_ID';

-- Get all invites sent by a user
-- SELECT * FROM invite_usage WHERE inviter_user_id = 'YOUR_USER_ID' ORDER BY created_at DESC;

-- Get all pending invites
-- SELECT * FROM invite_usage WHERE status = 'pending' ORDER BY created_at DESC;

-- Get successful invites in the last 30 days
-- SELECT 
--     ui.invite_code,
--     u.name as inviter_name,
--     COUNT(*) as successful_invites
-- FROM invite_usage iu
-- JOIN user_invites ui ON ui.invite_code = iu.invite_code
-- JOIN users u ON u.id = ui.user_id
-- WHERE iu.status = 'completed'
-- AND iu.completed_at >= NOW() - INTERVAL '30 days'
-- GROUP BY ui.invite_code, u.name
-- ORDER BY successful_invites DESC;

-- =====================================================
-- SETUP COMPLETE! ✅
-- =====================================================
-- Tables created successfully!
-- Now update your Flutter app:
-- 1. Update invite_service.dart with your GitHub Pages URL
-- 2. Run the app and test invite functionality
-- 3. Check these tables for data
-- =====================================================
