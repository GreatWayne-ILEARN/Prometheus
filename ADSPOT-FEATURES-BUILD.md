# AdSpot — Missing Features Build (Option B) + Analytics Rework

This build adds the prompt's missing capabilities **into the existing Vite + Express + Drizzle
codebase** (Option B — no re-platform), treats the completion reward as a **generic random
gift** (discount / cash / airtime / anything — not airtime-specific), and reworks brand
analytics with vibrant modern data-viz.

## What was already present (kept)
Ledger wallet (balance derived from `points_ledger`, never stored) · RBAC (`reviewer`/`brand`/
`admin`/`super_admin`) · multiplier premium (`ads.multiplier_factor` + `multiplier` points
source) · leaderboard · demographics (`reviewer_profiles`) · server-side watch-threshold check ·
atomic reward transaction · event logging · proverb attention-check.

## What was added this build

### New database tables (migration: `lib/db/migrations_adspot_features.sql`)
| Table | Purpose |
|-------|---------|
| `fraud_flags` | immutable fraud detections w/ score, reason, status, audit (`reviewed_by`/`reviewed_at`) |
| `fraud_rules` | admin-configurable weights + thresholds (warn 50 / review 100 / auto-suspend 150) + max daily earnings |
| `device_signals` | per-view IP / user-agent / device fingerprint (server captured) |
| `notifications` | in-app notifications (reward / gift / referral / fraud / …) |
| `gift_catalog` | the random-gift pool — **generic** types (discount/cash/airtime/points/voucher/other) with weighted-random `weight` |
| `gift_grants` | immutable record of gifts awarded on completion |
| `referral_codes` | each user's stable shareable code |
| `referrals` | invite → signed_up → qualified → rewarded (refer & earn, invite outside the orbit) |
| + `users.suspended` | suspension flag set by fraud engine / admin |
| + `review_sessions.{watch_percentage,ip_address,user_agent,device_fingerprint}` | fraud signals per view |

### New backend services (`artifacts/api-server/src/lib/`)
- `fraud.ts` — scoring engine: same-device (+50), same-IP (+20), excessive-daily-earnings (+30);
  cumulative open score → none/warn/review/**auto-suspend**; records device signals.
- `gifts.ts` — `drawGift()` weighted-random draw from the active pool (ad-specific OR global) →
  immutable `gift_grants` row.
- `referrals.ts` — `ensureReferralCode`, `recordReferralSignup`, `qualifyReferral` (atomic
  referrer reward on the invitee's first completed review + notification).
- `notify.ts` — `notify()` helper.

### Wired into the review-completion flow (`routes/reviews.ts`)
Within/after the existing atomic transaction: captures device signals, **draws a random gift**,
sends reward/gift notifications, then (post-commit) runs **fraud evaluation** and **referral
qualification**. Watch %, IP, UA and fingerprint are now persisted on the session.

### New API routes (registered in `routes/index.ts`)
- `/fraud/*` (admin) — list flagged users, per-user history, dismiss flag, suspend/unsuspend, get/update rules.
- `/gifts/*` — my grants (reviewer); catalog list/create/deactivate (admin/brand).
- `/referrals/me` (reviewer) — my code + referral list + total earned.
- `/notifications/*` — list, mark-one-read, mark-all-read.
All use RBAC middleware + Zod validation, consistent error JSON.

### Brand analytics rework (`artifacts/adspot-brand/src/pages/Dashboard.tsx`)
The dashboard already used recharts; it was elevated to **vibrant modern data-viz**:
- New multi-hue palette (indigo / cyan / pink / green / amber / violet) replacing the monochrome orange.
- **Radial completion-rate gauge** with a tri-colour gradient and centered gradient-text value.
- Gradient-filled "Top States" bar; vibrant multi-colour cells on age-band and time-of-day bars.
- Existing area-trend (gradient), donut gender split, and performance table retained.
Audience breakdown (state / gender / age / time-of-day) is aggregated from `reviewer_profiles`
into brand insights via the `/brands/analytics` endpoint.

## Verification
- DB: new schemas typecheck clean (only pre-existing `seed-dangote.ts` errors remain, untouched).
- api-server: **real esbuild build passes** → `dist/index.mjs` (all new routes/services bundled).
- adspot-brand: **vite build passes** (2493 modules) → `dist/public`.

## AWS deployment notes
- **api-server** (Express) → container on ECS/Fargate or App Runner (or EC2 + pm2), `node dist/index.mjs`,
  behind an ALB. Env: `DATABASE_URL` (Supabase), JWT secret, object-storage creds.
- **adspot-brand / landing** (Vite SPA) → static hosting (S3 + CloudFront / Amplify) with SPA fallback.
- **Supabase Postgres** → run `adspot_db.sql` then `lib/db/migrations_adspot_features.sql`.
- **Still to wire (config, not code):** Upstash Redis (rate-limit/cache), Resend (email),
  Sentry (monitoring) — these are env/integration steps from the prompt, deferred per Option B
  scope; the app runs without them and they slot in via env + a small client init.
