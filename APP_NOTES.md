# Implementation notes

This first increment focuses on a read-only dashboard over the supplied SQL dump. It does not attempt to invent missing application workflows.

## Why SQLite for the initial demo?

The uploaded database is a MySQL 8 export, but no running MySQL host or credentials were supplied. The `scripts/build_demo_db.py` utility converts the existing schema and rows to SQLite so Streamlit can ship with a self-contained, read-only dataset.

The SQLite file is bundled with the app for reading only. Do not add writes and assume they will survive on Streamlit Community Cloud: local filesystem persistence is not guaranteed there.

## Why there is no rescue map yet

`INCIDENT.INCIDENT_LOCATION` stores a text description, not coordinates. The listed addresses and place names should not be geocoded or shown as precise incident pins without validation. Once valid coordinates are added, a map can be introduced in a later version.

## Privacy

The UI omits reporter names/contacts, responder names/contacts/emails, and staff contact details. This does not remove those values from the source SQL or PDF. Review/anonymise source documents before publishing the repository.
