# AdSpot — AWS staging (builds verified ✓)

pnpm monorepo. **Two defects were fixed to make it build off Replit:**
1. Added the missing `tsconfig.base.json` at the repo root (every tsconfig extended a file that
   did not exist in the export — this broke the brand/web builds).
2. `adspot-web` and `mockup-sandbox` Vite configs hard-threw when `PORT`/`BASE_PATH` were unset;
   they now default (`PORT=5173`, `BASE_PATH=/`) so `vite build` works without env.

Verified: `pnpm install` then per-app build → brand ✓, web ✓, landing ✓, mockup ✓, api-server ✓.
(`adspot-reviewer` is an Expo **mobile** app — built/shipped via EAS, not AWS web hosting.)

## Build
```
corepack enable && corepack prepare pnpm@9 --activate   # if pnpm not installed
pnpm install
pnpm -r --if-present run build
```
Each web app outputs to `artifacts/<app>/dist`; the API outputs `artifacts/api-server/dist/index.mjs`.

## Stage on AWS
- **adspot-brand / adspot-web / adspot-landing** (Vite SPAs): each `dist/` → its own S3 bucket +
  CloudFront (map 403/404 → /index.html). Or one Amplify app per site.
- **api-server** (Express, `dist/index.mjs`, `node start`): AWS **App Runner**, **Elastic Beanstalk
  (Node)**, or **ECS/Fargate**. Set PORT and your env (DB URL, OpenAI key, JWT secret).
- **Database**: Postgres on **RDS**; run the Drizzle schema / `adspot_db.sql`.
## Env per app: PORT, BASE_PATH (web apps); DATABASE_URL, JWT secret, OPENAI/AI keys (api-server).

## Build notes (verified)
- **Web apps (brand + admin):** `pnpm install` then `pnpm -r run build`. Both build clean
  (brand: 2493 modules; admin: 2216 modules) and pass a full route crawl with no dead links
  or runtime errors.
- **Reviewer (Expo/React Native mobile app):** set `EXPO_PUBLIC_DOMAIN=<your-api-host>`
  (e.g. `api.adspot.ng`) before building. The Expo bundler must be able to reach `expo.dev`
  to resolve versioned native modules — run it on a machine with normal internet access
  (standard for any Expo build). The hard-coded Replit domain dependency has been removed;
  it now defaults gracefully if the env var is unset.
- **API server:** Node service; deploy on App Runner/ECS with the Supabase service-role key.
