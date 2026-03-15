-- Create subscriptions table
CREATE TABLE subscriptions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  price DECIMAL(10,2) NOT NULL CHECK (price > 0),
  category TEXT NULL,
  created_at TIMESTAMP DEFAULT now()
);

-- Enable RLS
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- Policy: SELECT own data
CREATE POLICY "Users see own subscription"
  ON subscriptions FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: INSERT own data
CREATE POLICY "Users insert own subscription"
  ON subscriptions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: DELETE own data
CREATE POLICY "Users delete own subscription"
  ON subscriptions FOR DELETE
  USING (auth.uid() = user_id);

-- Verify
SELECT tablename FROM pg_tables WHERE tablename = 'subscriptions';
