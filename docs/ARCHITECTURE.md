# AdSpot — Architecture Reference

_Gamified Nigerian ad-review platform. pnpm monorepo, TypeScript end to end.
Reviewers watch and rate video ads to earn points; brands get structured
feedback and analytics; admins configure and oversee the platform._

## 1. Functionality

| Capability | What it does | Where it lives |
|---|---|---|
| Reviewer auth | Register / login for ad reviewers (JWT in a cookie) | adspot-web · `auth` route |
| Ad feed & dashboard | Reviewer sees available ads, points balance, progress | adspot-web `Dashboard` |
| Review session | Watch a Vimeo ad (min-watch enforced), answer up to 10 questions (multiple-choice, rating, open text, emoji, yes/no), earn points | adspot-web `ReviewSession` · `reviews` route |
| Points & redemptions | Immutable points ledger; reviewers redeem points for rewards | `points`, `rewards`, `redemptions` routes |
| Leaderboard | Weekly ranking with historical snapshots | adspot-web `Leaderboard` · `leaderboard` route |
| Brand auth | Brand register / login (token in localStorage) | adspot-brand · `auth` route |
| Brand dashboard & analytics | Per-ad performance, response breakdowns, comments, AI "survey insights" with a positivity score | adspot-brand `Dashboard` · `brands/analytics` |
| Ad & question management | Brands/admins create and edit ads and their question sets | adspot-brand `ads/`, `admin/` · `ads`, `admin` routes |
| Packages & pricing | Ad bundles (Starter / Professional / Enterprise) | `packages` route · `ad_packages` table |
| Admin console | Manage ads, questions, brands, users & roles, adjust points, approve redemptions, view sessions, export events, platform stats | adspot-brand `admin/`, adspot-web `AdminPanel` · `admin` route |
| Platform settings | Admin-configurable key/value params (point values, thresholds, etc.) | `settings` route · `platform_settings` table |
| AI feedback insights | Sentiment/positivity analysis of open-text answers for brand reports | `integrations-openai-ai-server` (used in `brands` route) |
| Audit log | Immutable event history | `events_log` table · `admin/events` |
| Marketing landing | Public showcase with YouTube-embedded demo | adspot-landing |
| Mobile reviewer | Native reviewer app (file-based routing) | adspot-reviewer (Expo) |
| Object storage | Asset/file uploads | `storage` route · `object-storage-web` |

## 2. Technical stack — what's doing what

| Layer | Technology | Job |
|---|---|---|
| Monorepo | pnpm workspaces | Manages all apps + shared libs in one repo |
| Runtime | Node.js 24 | Server runtime |
| Language | TypeScript 5.9 | Everything, end to end |
| API | Express 5 | REST API server |
| Database | PostgreSQL | Primary data store |
| ORM | Drizzle ORM | Typed schema + queries (`lib/db`) |
| Validation | Zod + drizzle-zod | Request/response & schema validation (`api-zod`) |
| API codegen | Orval (OpenAPI → hooks) | Generates React Query hooks + Zod from the API spec (`api-client-react`) |
| Auth | JWT + bcryptjs | Cookie session (reviewer), localStorage token (brand) |
| Data fetching | TanStack React Query | Client server-state & caching |
| UI framework | React 19 | All three web apps |
| Build/dev | Vite 7 (esbuild) | Frontend dev server + bundling |
| Styling | Tailwind CSS v4 + shadcn/ui | Design system & components |
| Routing | Wouter | Lightweight client routing |
| Motion / icons | framer-motion · lucide-react | Animation & iconography |
| Video | Vimeo iframe · YouTube (nocookie) | Ad review player · landing showcase |
| AI | OpenAI | Open-text sentiment / survey insight scoring |
| Mobile | Expo / React Native | Native reviewer app |
| Storage | Replit object storage | Uploaded assets |

## 3. Apps & libraries

| Package | Type | Role | Served at |
|---|---|---|---|
| `artifacts/api-server` | App | Express REST API + Postgres (14 route groups) | `/api/` |
| `artifacts/adspot-brand` | App | Brand portal — login, dashboard, ad management, admin | `/` |
| `artifacts/adspot-web` | App | Reviewer platform — feed, review sessions, leaderboard | `/platform/` |
| `artifacts/adspot-landing` | App | Public marketing landing | `/landing/` |
| `artifacts/adspot-reviewer` | App | Native mobile reviewer (Expo) | mobile |
| `artifacts/mockup-sandbox` | App | Design sandbox (non-production) | — |
| `lib/db` | Library | Drizzle schema (16 tables) + seed scripts | — |
| `lib/api-zod` | Library | Generated Zod schemas / API contract | — |
| `lib/api-spec` | Library | OpenAPI specification | — |
| `lib/api-client-react` | Library | Orval-generated React Query client/hooks | — |
| `lib/integrations-openai-ai-server` | Library | Server-side OpenAI calls | — |
| `lib/integrations-openai-ai-react` | Library | Client-side AI hooks/UI | — |
| `lib/openai_ai_integrations` | Library | Earlier/duplicate OpenAI integration — consolidate | — |
| `lib/object-storage-web` | Library | Object-storage client | — |

## Cleanup opportunities noted on review
- Overlapping OpenAI integration packages (`integrations-openai-ai-*` vs `openai_ai_integrations`) — consolidate to one.
- The reviewer platform (`adspot-web`) carries its own `AdminPanel` and `BrandPortal` pages alongside the dedicated brand-portal app — duplicated admin surface worth de-duplicating.

## Database tables (lib/db/src/schema)
users · brands · ads · questions · reviews · answers (review_sessions) · points · rewards · redemptions · packages · leaderboard · settings · events · profiles · conversations · messages
