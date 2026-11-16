# Urban Wildlife Rescue Management System (UWRMS)

A lightweight, read-only Streamlit demonstration built from the MySQL database dump included in the original project.

## What is included

- **Overview** — headline counts, incident mix, species counts, and recent sample incidents.
- **Incidents** — searchable and filterable incident register, record detail, and filtered CSV export.
- **Animals** — searchable animal and species register with a filtered CSV export.
- **Facilities** — facility list, historical animal assignments, inventory, and permit register.
- **Rescue operations** — responder assignment roles, treatment log, and release outcomes.
- **Analytics** — sample breakdowns by incident type, species, recorded health condition, and status.

The app deliberately hides reporter, responder, and staff contact information in its public-facing tables. It is a portfolio demo, not a live incident-reporting or dispatch service.

## Run locally

Python 3.12 is recommended to match the current Streamlit Community Cloud default.

```bash
python -m venv .venv

# macOS / Linux
source .venv/bin/activate

# Windows PowerShell
# .venv\Scripts\Activate.ps1

python -m pip install -r requirements.txt
streamlit run streamlit_app.py
```

## Deploy to Streamlit Community Cloud

1. Push this project folder to a GitHub repository that you administer.
2. Sign in at <https://share.streamlit.io/> with GitHub.
3. Select **Create app**.
4. Choose the repository and production branch.
5. Set the app file path to `streamlit_app.py`.
6. Deploy. The app does not need secrets or external credentials in this read-only configuration.

Community Cloud deploys from the GitHub repository and watches for later commits. Keep `requirements.txt` at the repository root and do not commit `.streamlit/secrets.toml` or database credentials.

## Database and data behaviour

- `data/uwrms_demo.sqlite` is a SQLite copy generated from `Data Book/uwrms.sql`.
- Rebuild it after changing the MySQL dump with:

  ```bash
  python scripts/build_demo_db.py
  ```

- The app does not write to the database. This is intentional: Streamlit Community Cloud does not guarantee persistence of files written to the app's local filesystem. A later version that edits records should use a managed external database.
- Original project materials are preserved in `Data Book/`.

## Important source-data limitations to resolve before an industry demo

1. **Small, historical SQL sample:** the MySQL dump contains 15 tables and 85 rows total. It includes 5 incidents, 5 animals, 5 facilities, 5 responders, 5 assignments, 5 treatments, 5 releases, and 15 species. Its operational dates are in January 2025.
2. **Data Book and SQL dump do not fully match:** the PDF's later sample/normalisation pages show 11 animal/incident records and a sixth facility (Facility ID 206 / Riverstone Marine Rescue), while the supplied MySQL dump inserts only 5 incidents, 5 animals, and 5 facilities. Some species/record identifiers shown in those PDF examples are not present in the SQL dump. The app therefore uses the SQL dump as its executable data source, not the larger examples in the PDF.
3. **No coordinates:** `INCIDENT_LOCATION` is a text field; there are no latitude/longitude columns. The first version displays location text and intentionally omits a map. Add and validate coordinates before presenting map pins or hotspot analysis.
4. **No account/role tables:** the schema has responder and staff records but no application-user credentials or permission model. This starter is read-only and has no login.
5. **Permit dates:** the sample stores permit status independently of expiry dates. Check these values together before using them as current compliance status.
6. **Release column typo:** the SQL dump uses `RELEASE_NOTTES`; the Data Book describes the field as `RELEASE_NOTES`. The original column name is preserved in the bundled SQLite database.
7. **Sensitive-looking fields:** the supplied dump and PDF contain human names, phone numbers, and email addresses. The app suppresses these fields in its UI, but the source materials may still be accessible if the repository is public. Confirm that the records are entirely synthetic or anonymise/remove contact details from public GitHub materials before sharing the repository widely.

## Suggested next increments

1. Reconcile the PDF's 11-record example with the 5-record SQL export and decide which dataset is canonical.
2. Add latitude/longitude to incident records only when verified coordinates are available.
3. Introduce a persistent managed database and authentication before adding create/update/delete workflows.
4. Add audit history, role-based permissions, validation, and automated tests before presenting it as operational software.

## Project structure

```text
.
├── streamlit_app.py
├── requirements.txt
├── README.md
├── data/
│   └── uwrms_demo.sqlite
├── scripts/
│   └── build_demo_db.py
├── .streamlit/
│   └── config.toml
└── Data Book/
    ├── Final_Databook.pdf
    ├── Queries.sql
    └── uwrms.sql
```
