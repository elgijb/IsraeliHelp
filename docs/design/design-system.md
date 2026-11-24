# IsraeliHelp — design system (approved)

Approved on 24.11.2026 after mockups of four product scenarios.

## Direction

Minimal editorial product UI (Linear / Airbnb / Vercel influence). No AI-landing clichés: no numbered “01/02” sections, no pill-chip city rows as hero decoration, no fake stats, no identical card grids everywhere.

## Four scenarios

1. **Home** — states the problem (scattered volunteer requests), then a search form, then upcoming list and cities.
2. **Catalog** — search, filters, month-grouped list with clear date column + city.
3. **Event** — large photo, date/time/city facts, description, place, sticky apply panel.
4. **Admin** — practical table + (later) form; status badges, volunteer fill bars.

## Tokens

See `src/main/webapp/css/style.css` (`:root`). Key colors: bg `#FAFAF8`, text `#171717`, accent `#2563EB`, teal `#0D9488` / text `#0F766E`.

## Typography

- Inter (EN + RU Cyrillic), Heebo (HE) — local woff2 in `webapp/fonts/`.
- Scale: 34/32/24/22/20/16/15/14/13/12.

## i18n

- Default language: English.
- Bundles: `i18n/messages.properties`, `messages_he.properties`, `messages_ru.properties`.
- Hebrew UI is AI-translated; a native speaker should review it.
- Event titles/descriptions stay in the language the admin wrote (English in sample data).

## Photos

Pexels (free license). Credits: `docs/design/photo-credits.md`.
