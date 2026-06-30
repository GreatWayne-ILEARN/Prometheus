# AdSpot — Production Build Status & Deploy Notes

Date: 26 June 2026

## Verified in this build
- `pnpm install` — succeeds (1190 packages).
- `pnpm run typecheck` (`tsc --build`, all 14 workspace projects) — **exit 0, zero errors.**
- `pnpm -r run build` for all deployable apps — **exit 0.** Built artifacts produced:

| Package | dist | Deploy target |
|---|---|---|
| artifacts/adspot-web | dist/ (static) | S3 + CloudFront / Amplify |
| artifacts/adspot-brand | dist/ (static) | S3 + CloudFront / Amplify |
| artifacts/adspot-landing | dist/ (static) | S3 + CloudFront / Amplify |
| artifacts/mockup-sandbox | dist/ (static) | S3 + CloudFront / Amplify |
| artifacts/api-server | dist/ (Node) | EC2 / ECS / Lambda (run `pnpm install --prod` on target) |
| lib/* | dist/ | internal workspace deps (prebuilt) |

## Not built here — environmental, not code
- **artifacts/adspot-reviewer** (Expo app): its `node scripts/build.js` Expo/Metro step
  reaches an external host that this sandbox's network blocks (the proxy's deny text
  comes back as non-JSON, so Metro throws a JSON parse error). This is NOT a TypeScript
  or code error — the package typechecks clean. It will build where outbound network to
  Expo is available (your machine / AWS CI). Build it there with `pnpm --filter @workspace/adspot-reviewer run build`.

## Fixes applied to make the build clean
1. lib/db/src/schema/questions.ts — `jsonb("options").$type<string[]>()` (root cause of the seed-dangote `{}` error).
2. lib/integrations-openai-ai-server/src/batch/utils.ts — p-retry v7 named `AbortError`.
3. lib/integrations-openai-ai-server/src/image/client.ts — `response.data?.[0]?.b64_json` guard.
4. lib/integrations-openai-ai-server/package.json — declared `@types/node` (required under pnpm isolated modules).
5. lib/api-client-react/src/generated/api.schemas.ts — synced stale generated types to the backend: `proverbAnswer`/`comment` on CompleteReviewRequest, `proverbQuestion`/`proverbBonusPoints` on AdDetailResponse, `averageWatchSeconds` on BrandAdSummary, `super_admin` on AdminUserEntryRole.
6. artifacts/adspot-landing/src/pages/Landing.tsx — aligned local `PublicVideo` to the real `PublicVideoItem` (Vimeo-only; dropped non-existent YouTube fields).
7. artifacts/adspot-web — `VideoPlayer` status union (`"blank"`), undefined guards on `pointsBalance` and `averageRating`.
8. artifacts/api-server — `String(req.params.*)` (matches admin.ts convention) in fraud/gifts/notifications, `brandName`→`companyName` in brands.ts, `node:stream/web` cast for `Readable.fromWeb` in storage.ts.

## Action item (contract hygiene)
`proverb*` fields exist in the DB schema and reviewer UI but are NOT in `lib/api-spec/openapi.yaml`.
They were added to the generated client types directly to unblock the build. To make this
canonical, add them to `openapi.yaml` and run `pnpm codegen` (orval), so a future regeneration
does not drop them.

## To rebuild from source
```bash
pnpm install
pnpm run build        # typecheck + bundle all packages
```
