# Subscription Tracker MVP

Stop wasting money on forgotten subscriptions.

Simple, fast, private. Track all your subscriptions in one place and see exactly how much you're spending monthly.

---

## Features

✅ Magic link authentication (email only)
✅ Add/delete subscriptions
✅ Monthly total calculator
✅ Privacy-first (RLS on all data)
✅ No password required
✅ Works offline-first, syncs when online

---

## Tech Stack

- **Frontend:** HTML + Tailwind CSS + Vanilla JS
- **Backend:** Supabase (PostgreSQL + Auth)
- **Deployment:** Vercel (free)
- **Security:** Row Level Security (RLS), Email OTP

---

## Setup

### 1. Clone Repository

```bash
git clone https://github.com/clawk507-glitch/subscription-tracker-mvp.git
cd subscription-tracker-mvp
cp config.js.example config.js
```

### 2. Create Supabase Project

1. Go to https://supabase.com
2. Create new project
3. Copy **Project URL** and **Anon Key**
4. Paste into `config.js`:

```javascript
const CONFIG = {
  SUPABASE_URL: 'https://xxx.supabase.co',
  SUPABASE_ANON_KEY: 'eyJxx...'
};
```

### 3. Setup Database

In Supabase SQL Editor, run:

```sql
-- Create table
CREATE TABLE subscriptions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  price DECIMAL(10,2) NOT NULL CHECK (price > 0),
  created_at TIMESTAMP DEFAULT now()
);

-- Enable RLS
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- Policy: SELECT
CREATE POLICY "Users see own subscription"
  ON subscriptions FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: INSERT
CREATE POLICY "Users insert own subscription"
  ON subscriptions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: DELETE
CREATE POLICY "Users delete own subscription"
  ON subscriptions FOR DELETE
  USING (auth.uid() = user_id);
```

### 4. Configure Auth Redirect

In Supabase Dashboard:
- Go to **Authentication → URL Configuration**
- Set **Site URL:** `http://localhost:5000` (local) or `https://your-vercel-url.vercel.app` (production)
- Add **Redirect URLs:** `http://localhost:5000/dashboard.html`

---

## Run Locally

```bash
# Python 3
python -m http.server 5000

# Or Node.js
npx http-server -p 5000
```

Visit: `http://localhost:5000`

---

## Deploy to Vercel

### Option 1: Command Line

```bash
npm install -g vercel
vercel
```

### Option 2: GitHub

1. Push to GitHub
2. Go to vercel.com
3. Import repository
4. Environment variables: Add `config.js` with your Supabase credentials
5. Deploy

---

## Security

✅ **Anon key only** - No service role keys in frontend
✅ **RLS enforced** - Users can only see their own data
✅ **Email OTP** - No passwords, magic links only
✅ **Input validation** - Price > 0, name required
✅ **XSS protection** - All user input escaped
✅ **HTTPS only** - SSL enforced in production

---

## Files

```
subscription-tracker-mvp/
├── index.html           # Login page
├── dashboard.html       # Main app
├── config.js.example    # Config template
├── .gitignore          # Git ignore
└── README.md           # This file
```

---

## How It Works

1. User enters email → Gets magic link
2. Clicks link → Auto-logged in
3. Adds subscriptions (name + price)
4. Dashboard shows total/month
5. Can delete individual subscriptions
6. Logout anytime

---

## Development

### Add a Feature

1. Edit HTML
2. Test locally
3. Commit
4. Push → Auto-deploys to Vercel

### No build step required. Edit, refresh, done.

---

## Troubleshooting

**"Magic link not working?"**
- Check Supabase URL Configuration
- Check email in Supabase → Authentication → Users
- Check browser console for errors

**"Can't see subscriptions?"**
- Check RLS policies in Supabase
- Check browser console for errors
- Verify user_id matches

**"Price validation failing?"**
- Price must be > 0
- Use format: 12.99 (no currency symbol)

---

## Roadmap

- [ ] Email reminders before renewal
- [ ] CSV export
- [ ] Bank account sync (optional)
- [ ] Multiple users per account
- [ ] Mobile app

---

## License

MIT

---

## Support

Issues? Open a GitHub issue or email: clawk507@gmail.com

---

**Built with ❤️ by Clawk**
