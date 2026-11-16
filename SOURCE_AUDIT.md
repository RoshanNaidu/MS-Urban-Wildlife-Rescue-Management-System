# Source audit: uploaded UWRMS project

Reviewed the uploaded ZIP, the 29-page `Final_Databook.pdf`, `Queries.sql`, and `uwrms.sql`.

## Repository contents before this starter

The ZIP contained only:

- `Data Book/Final_Databook.pdf`
- `Data Book/Queries.sql`
- `Data Book/uwrms.sql`
- `LICENSE`
- `README.md`

There was no Python source code, Streamlit app, `requirements.txt`, web frontend, or deployment configuration.

## What the database already models

The MySQL dump defines 15 tables:

`INCIDENT`, `ANIMAL`, `SPECIES`, `HERBIVORE`, `CARNIVORE`, `OMNIVORE`, `RESPONDER`, `ASSIGNMENT`, `TREATMENT`, `FACILITY`, `ANIMAL_FACILITY_ASSIGNMENT`, `RELEASE`, `STAFF`, `PERMIT`, and `INVENTORY`.

The dump contains 85 rows in total: 5 rows in each table except `SPECIES`, which contains 15. Foreign-key relationships were preserved in the SQLite conversion and `PRAGMA foreign_key_check` passed.

The three supplied queries cover:

1. Incident details ordered from newest to oldest.
2. Animal records joined to common species names.
3. Animal/facility assignments with the latest related inventory update.

## Gaps between the documents and the executable dump

- The Data Book's later example tables show animal/incident IDs through `1011` / `5011` and include a sixth facility, ID `206` (Riverstone Marine Rescue). The supplied SQL dump inserts only five animals, five incidents, and five facilities.
- Some species and identifiers in the Data Book's normalization examples are not present in the SQL dump. The Streamlit starter uses the SQL dump as its source of truth so the displayed data matches the database file shipped with the app.
- The Data Book describes `RELEASE_NOTES`, while the SQL dump spells the column `RELEASE_NOTTES`.
- The Data Book relational schema uses `FACILITY_PERMIT_ID`; the SQL dump uses `PERMIT_ID` in the `FACILITY` table.
- The PDF's scope mentions auditability, permissions, follow-up monitoring, and broader rehabilitation workflows, but the supplied executable schema does not define application login/role tables, an audit-event table, or a detailed follow-up schedule table.

## MVP implications

- A working dashboard and read-only reporting pages can be built immediately from the supplied records.
- A map should wait: the incident table has a free-text location field but no latitude/longitude.
- Record editing should wait: no authentication/permission model is present, and Community Cloud does not guarantee persistence for local-file writes.
- Permit status should be reviewed against expiry dates. The SQL sample marks permits `Active`, while the stored expiry dates are earlier than the current date (November 16, 2026).
- Names, phones, and emails appear in the sample data and PDF. The app suppresses these fields in its normal UI, but the repository source files still need a privacy review before public distribution.
