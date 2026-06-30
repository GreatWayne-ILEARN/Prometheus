# AdSpot — Gamified Nigerian Ad Review Platform

## Overview

AdSpot is a gamified advertising platform where Nigerian reviewers earn rewards for watching and rating video ads, while brands receive structured feedback and analytics. The platform spans three separate web apps and a shared API server in a pnpm monorepo.

## Architecture

pnpm monorepo with TypeScript. Four main artifacts:

| Artifact | Path | Description |
|---|---|---|
| `artifacts/api-server` | `/api/` | Express 5 REST API + PostgreSQL |
| `artifacts/adspot-brand` | `/` | Brand Portal (React + Vite) |
| `artifacts/adspot-web` | `/platform/` | Reviewer Platform (React + Vite) |
| `artifacts/adspot-landing` | `/landing/` | Public Marketing Landing Page |

## URL Routing (Proxy)

- `/` → Brand Portal (adspot-brand) — brand login, dashboard, ad management, admin
- `/platform/` → Reviewer Platform (adspot-web) — reviewer login, ad feed, review sessions
- `/landing/` → Marketing Landing Page (adspot-landing) — public showcase
- `/api/` → API Server — all REST endpoints

**Important:** All inter-app links must use absolute paths (e.g. `<a href="/">` for brand portal, `<a href="/platform/">` for reviewer platform, `<a href="/landing/">` for landing page). Never use `/brand/` — that path does not exist.

## Stack

- **Monorepo**: pnpm workspaces
- **Node.js**: 24
- **API**: Express 5 + TypeScript
- **Database**: PostgreSQL + Drizzle ORM
- **Auth**: JWT (jsonwebtoken) + bcryptjs — cookie in adspot-web, localStorage `adspot_brand_token` in adspot-brand
- **Validation**: Zod + drizzle-zod
- **API codegen**: Orval (OpenAPI → React Query hooks + Zod schemas)
- **Frontend**: React 19, Vite 7, Tailwind CSS v4, shadcn/ui, Wouter router
- **Video**: Vimeo iframe for ad review sessions; YouTube embed (youtube-nocookie.com) for public landing showcase
- **Build**: esbuild

## Database Schema (lib/db/src/schema/)

- `users` — reviewers, brands, admins (role enum)
- `brands` — brand profiles linked to brand users
- `ads` — ad creatives (assetType: youtube|vimeo, assetUrl = video ID), min_watch_seconds, point_reward, status
- `questions` — up to 10 per ad (multiple_choice, rating, open_text, emoji, yes_no)
- `review_sessions` — tracks ad watch sessions per reviewer
- `answers` — individual question answers per review session
- `points_ledger` — immutable points log per user
- `events_log` — immutable audit log
- `leaderboard_snapshots` — historical weekly leaderboard
- `redemptions` — points redemption requests
- `ad_packages` — pricing bundles (Starter, Professional, Enterprise)
- `platform_settings` — admin-configurable key/value parameters

## Demo Accounts (all password: `password123`)

| Role | Email |
|---|---|
| Admin | `admin@adspot.demo` |
| Brand (Dangote Group) | `dangote@adspot.demo` |
| Reviewer | `alice@reviewer.demo` |

Login for brands/admin: Brand Portal at `/`
Login for reviewers: Reviewer Platform at `/platform/login`

## Key Features

### Landing Page (`/landing/`)
- Hero section with live stats from API
- "Currently Trending" video cards — YouTube thumbnails (maxresdefault → hqdefault fallback), click-to-play modal with youtube-nocookie.com embed + autoplay
- Orange brand theme (`--primary: 25 95% 53%`)
- Pricing packages from API
- All CTA buttons: "Start Reviewing" → `/platform/`, "Launch a Campaign" / "Brand Portal" → `/`

### Brand Portal (`/`)
- JWT stored in `localStorage` key `adspot_brand_token`
- `/login` — Login; `/register` — Register brand account
- `/dashboard` — Overview stats, recent campaigns, **Generate AI Summary** button (SSE streaming GPT-5.1 report, Word + PDF export)
- `/ads/new` — 3-step ad creation wizard (Details → Questions → Review)
- `/ads/:id` — Ad detail with 4 tabs:
  - **Question Responses** — Recharts breakdowns per question
  - **Recent Activity** — review session feed
  - **Configuration** — edit ad settings
  - **Preview** — live Vimeo iframe (postMessage play-time tracking), question form, progress bar — exactly as reviewers see it
- Status toggle (active/paused/draft→active all enabled; only archived stays locked)
- `/admin/dashboard` — Admin overview + **Health Monitor** (pulsing dot, 30s poll, slide-out dependency status panel)
- `/admin/events` — Event log + CSV export
- `/admin/ads` — All campaigns with pagination
- `/admin/users` — All users with role filter + pagination

### Reviewer Platform (`/platform/`)
- JWT stored in cookie
- `/platform/` — Public landing with live stats
- `/platform/login` → auth; `/platform/register` → sign up
- `/platform/dashboard` → reviewer hub: ad feed, points balance, leaderboard
- `/platform/review/:id` → review session: video player, question form, points award
- `/platform/admin` → Admin Control Panel (packages CRUD, settings, users, ads, events) + Health Monitor in header

### Admin Dependency Health Monitor
- `GET /api/admin/health` — checks DB, JWT secret strength, object storage, memory, env vars, uptime
- **Frontend**: `HealthIndicator` in AdminPanel header — pulsing green/yellow/red dot, 30s auto-poll, Sheet slide-out

### Brand AI Analytics Summary
- `POST /api/brands/analytics/ai-summary` — SSE streaming via GPT-5.1 (`@workspace/integrations-openai-ai-server`)
- **Frontend**: `AISummaryPanel` — streaming typewriter render, Download as Word (.doc) and Save as PDF

## API Routes (prefix: `/api`)

### Public (no auth)
- `GET /public/videos` — weighted random active ad feed for landing page showcase
- `GET /public/stats` — platform statistics
- `GET /public/packages` — active pricing packages

### Auth
- `POST /auth/register` — register reviewer or brand
- `POST /auth/login` — login
- `GET /auth/me` — current user profile

### Reviewer
- `GET /ads` — paginated active ad feed
- `GET /ads/:adId` — ad detail + questions
- `POST /reviews/start` — start review session
- `POST /reviews/:sessionId/complete` — submit answers, award points
- `GET /points/balance` — points balance
- `GET /points/ledger` — points history
- `GET /leaderboard` — current week top 10
- `GET /leaderboard/history` — past weeks

### Brand Portal
- `POST /brands/analytics/ai-summary` — SSE streaming AI summary (GPT-5.1)
- `GET /brands/ads` — brand's ads + metrics
- `POST /brands/ads` — create ad
- `GET /brands/ads/:adId` — ad detail + questions
- `PATCH /brands/ads/:adId` — update ad
- `GET /brands/ads/:adId/stats` — full analytics
- `POST /brands/ads/:adId/questions` — add question
- `GET /brands/stats/overview` — dashboard summary
- `POST /brands/packages/:packageId/purchase` — purchase package

### Admin
- `GET /admin/health` — dependency health check
- `GET /admin/events` — searchable event log
- `GET /admin/events/export` — CSV export
- `GET /admin/ads` — all ads + stats
- `GET /admin/users` — all users
- `GET /admin/packages` — pricing packages CRUD
- `GET /admin/settings` — platform settings
- `PATCH /admin/settings` — update settings

## Video Player Patterns

### Ad Review Sessions (Vimeo — no watermarks/ads)
```tsx
<iframe
  src={`https://player.vimeo.com/video/${vimeoId}?autoplay=0&title=0&byline=0&portrait=0&badge=0&dnt=1`}
  style={{ width: '100%', height: '100%', border: 'none' }}
  allow="autoplay; fullscreen; picture-in-picture"
  allowFullScreen
/>
```
`vimeoId` comes from `ad.assetUrl` when `ad.assetType === 'vimeo'`.

### Landing Page Showcase (YouTube — privacy enhanced)
```tsx
<iframe
  src={`https://www.youtube-nocookie.com/embed/${videoId}?autoplay=1&rel=0&modestbranding=1`}
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
  allowFullScreen
/>
```
Thumbnail: try `img.youtube.com/vi/{id}/maxresdefault.jpg`, fall back to `hqdefault.jpg` via `onError`.

## Key Commands

- `pnpm run typecheck` — full typecheck across all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API client from OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes
- `pnpm --filter @workspace/db run seed` — reseed demo data
