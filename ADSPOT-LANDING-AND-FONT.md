# AdSpot — Landing Rework, Flow & Platform Font

## The "two landing pages" — resolved
There were genuinely two:
1. **`artifacts/adspot-web/src/pages/Landing.tsx`** — the **canonical** public landing. It is the
   `/` route of the functional app that also owns Register, Login, Leaderboard, ReviewSession and
   the brand/admin portals. This is the one users actually enter through.
2. **`artifacts/adspot-landing/`** — a separate standalone marketing app duplicating the landing.
   It is **redundant**; treat `adspot-web` as the single source of truth and retire `adspot-landing`
   (or keep it only as a static marketing splash). All work below is in the canonical `adspot-web`.

## Landing implemented to spec
- **Top bar:** logo left, **About** link right (Navbar simplified, right-aligned).
- **Hero:** headline text on a dark background ("Watch, review, give feedback, earn.").
- **Scrolling ad carousel** *under* the hero ("Live campaigns") — auto-scrolls, pauses on hover,
  edge fades, randomised public ad feed. Each card shows brand, video thumbnail, title, points and
  a multiplier badge.
- **Gated flow (tight):** clicking any ad calls `openAd()` → a logged-in **reviewer** goes straight
  to `/review/:id`; everyone else is routed to `/register` first, because sign-up is required to
  submit a review and appear on the leaderboard. Brand/Reviewer CTAs present in the hero.
- **Polish:** sleek dark video boxes (aspect-video, hover play button, scale-on-hover), consistent
  point/multiplier styling, reduced-motion respected on the carousel.

## Platform font (the "cursor.com font")
cursor.com uses a **custom proprietary typeface, Waldenburg ("Cursor Gothic")**, made for them by
the Kimera foundry — it is **not publicly licensed**, so it can't be embedded legally. The closest
free, self-hostable equivalent (a clean modern grotesque) is **Inter**, now applied **platform-wide**
via `@fontsource-variable/inter` (self-hosted — no Google Fonts network dependency, which also fixes
an offline build issue where the CSS imported Inter from `fonts.googleapis.com`).
- Set through `--app-font-sans: 'Inter Variable', …` in `adspot-web/src/index.css`.
- To make it uniform across the **brand/admin** app too, apply the same one-line swap there
  (import `@fontsource-variable/inter`, set the font variable). Done in `adspot-web`; brand app
  pending the same swap.

## Verification
- `adspot-web` **vite build passes** (1807 modules) → `dist/public`.
- Rendered build confirmed: top bar + About link, hero text, "Live campaigns" carousel, and
  `Inter Variable` as the computed body font.
