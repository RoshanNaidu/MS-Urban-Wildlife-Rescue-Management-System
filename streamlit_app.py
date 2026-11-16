from __future__ import annotations

import sqlite3
from pathlib import Path

import pandas as pd
import plotly.express as px
import streamlit as st

ROOT = Path(__file__).resolve().parent
DB_PATH = ROOT / "data" / "uwrms_demo.sqlite"

st.set_page_config(
    page_title="Urban Wildlife Rescue | UWRMS",
    page_icon="🌿",
    layout="wide",
    initial_sidebar_state="expanded",
)

st.markdown(
    """
    <style>
      @import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Manrope:wght@500;600;700;800&display=swap');
      html, body, [class*="css"] { font-family: 'DM Sans', sans-serif; }
      .block-container { padding-top: 1.7rem; padding-bottom: 2.5rem; max-width: 1440px; }
      h1, h2, h3 { font-family: 'Manrope', sans-serif; letter-spacing: -0.025em; }
      .brand-kicker { color: #557768; text-transform: uppercase; letter-spacing: .14em; font-size: .72rem; font-weight: 700; }
      .hero { background: linear-gradient(115deg, #173d32 0%, #285b48 65%, #47775b 100%); padding: 1.55rem 1.7rem; border-radius: 18px; color: #f7f8f3; margin-bottom: 1rem; }
      .hero h1 { color: #fff; margin: .15rem 0 .35rem 0; font-size: clamp(1.8rem, 4vw, 2.55rem); }
      .hero p { color: #e2ece4; margin: 0; max-width: 780px; }
      .hero-tag { display: inline-block; border: 1px solid rgba(255,255,255,.28); border-radius: 999px; padding: .25rem .65rem; color: #e4efe7; font-size: .72rem; margin-bottom: .45rem; }
      .section-note { color: #64756d; font-size: .9rem; }
      [data-testid="stMetric"] { background: #f3f6f1; border: 1px solid #e1e9e0; padding: .9rem 1rem; border-radius: 14px; }
      [data-testid="stSidebar"] { background: #f4f6f0; }
      [data-testid="stSidebar"] [data-testid="stMarkdownContainer"] p { color: #344c40; }
      div[data-testid="stDataFrame"] { border: 1px solid #e5eae4; border-radius: 12px; overflow: hidden; }
      .stButton button, .stDownloadButton button { border-radius: 10px; }
      footer { visibility: hidden; }
    </style>
    """,
    unsafe_allow_html=True,
)


@st.cache_data(show_spinner=False)
def read_query(sql: str) -> pd.DataFrame:
    if not DB_PATH.exists():
        raise FileNotFoundError(f"Demo database not found at {DB_PATH}")
    with sqlite3.connect(DB_PATH) as conn:
        return pd.read_sql_query(sql, conn)


def fmt_date(series: pd.Series) -> pd.Series:
    values = pd.to_datetime(series, errors="coerce")
    return values.dt.strftime("%b %d, %Y").fillna("—")


def show_hero(title: str, subtitle: str, section: str) -> None:
    st.markdown(
        f"""
        <section class="hero">
          <div class="hero-tag">UWRMS · DEMONSTRATION ENVIRONMENT</div>
          <div class="brand-kicker" style="color:#c5d9c9">{section}</div>
          <h1>{title}</h1>
          <p>{subtitle}</p>
        </section>
        """,
        unsafe_allow_html=True,
    )


def show_table(df: pd.DataFrame, height: int = 360) -> None:
    st.dataframe(df, width="stretch", hide_index=True, height=height)


try:
    incidents = read_query(
        """SELECT INCIDENT_ID, INCIDENT_DATE, INCIDENT_TYPE, INCIDENT_LOCATION,
                  INCIDENT_STATUS, INCIDENT_RESOLUTION_DATE
           FROM INCIDENT ORDER BY INCIDENT_DATE DESC"""
    )
    animals = read_query(
        """SELECT A.ANIMAL_ID, A.INCIDENT_ID, S.SPECIES_COMMON_NAME,
                  S.SPECIES_SCIENTIFIC_NAME, A.ANIMAL_AGE_CATEGORY,
                  A.ANIMAL_SEX, A.ANIMAL_HEALTH_STATUS, A.ANIMAL_INTAKE_DATE,
                  A.ANIMAL_IDENTIFICATION_MARK
           FROM ANIMAL A JOIN SPECIES S ON S.SPECIES_ID = A.SPECIES_ID
           ORDER BY A.ANIMAL_ID"""
    )
    facilities = read_query(
        """SELECT F.FACILITY_ID, F.FACILITY_NAME, F.FACILITY_CITY,
                  F.FACILITY_TYPE, F.FACILITY_CAPACITY, F.PERMIT_ID,
                  COUNT(AFA.ANIMAL_ID) AS HISTORICAL_ANIMAL_ASSIGNMENTS
           FROM FACILITY F
           LEFT JOIN ANIMAL_FACILITY_ASSIGNMENT AFA ON AFA.FACILITY_ID = F.FACILITY_ID
           GROUP BY F.FACILITY_ID, F.FACILITY_NAME, F.FACILITY_CITY,
                    F.FACILITY_TYPE, F.FACILITY_CAPACITY, F.PERMIT_ID
           ORDER BY F.FACILITY_NAME"""
    )
except Exception as exc:
    st.error(f"The application could not load its bundled demo database: {exc}")
    st.stop()

with st.sidebar:
    st.markdown("## 🌿 UWRMS")
    st.caption("Urban Wildlife Rescue Management System")
    st.divider()
    page = st.radio(
        "WORKSPACE",
        ["Overview", "Incidents", "Animals", "Facilities", "Rescue operations", "Analytics"],
        label_visibility="visible",
    )
    st.divider()
    st.markdown("**Data snapshot**")
    st.caption("Bundled MySQL project sample converted to SQLite for a read-only public demo.")
    st.caption(f"{len(incidents)} incidents · {len(animals)} animals · {len(facilities)} facilities")
    st.divider()
    st.caption("Portfolio demonstration · Not a live dispatch service")


if page == "Overview":
    show_hero(
        "Wildlife care, clearly coordinated.",
        "A single view of the incident, animal-care, facility, and response records in the UWRMS project database.",
        "Operations overview",
    )
    st.warning(
        "Demo data only. The bundled records are a small historical sample dated January 2025; "
        "they do not represent live rescue activity. Do not use this site to report an emergency."
    )
    st.caption("Incident locations are stored as text in the source schema. A map is intentionally omitted until verified latitude/longitude values are available.")
    resolved = int((incidents["INCIDENT_STATUS"].str.lower() == "resolved").sum())
    col1, col2, col3, col4 = st.columns(4)
    col1.metric("Recorded incidents", f"{len(incidents):,}")
    col2.metric("Animals recorded", f"{len(animals):,}")
    col3.metric("Resolved in sample", f"{resolved:,}")
    col4.metric("Facilities listed", f"{len(facilities):,}")

    left, right = st.columns([1.05, 1.4], gap="large")
    with left:
        st.subheader("Incident mix")
        type_counts = incidents.groupby("INCIDENT_TYPE", as_index=False).size().sort_values("size", ascending=False)
        if not type_counts.empty:
            fig = px.pie(type_counts, names="INCIDENT_TYPE", values="size", hole=0.62)
            fig.update_layout(margin=dict(t=8, b=8, l=8, r=8), legend_title_text="Incident type")
            st.plotly_chart(fig, width="stretch", config={"displayModeBar": False})
    with right:
        st.subheader("Recent incident records")
        recent = incidents.head(5).copy()
        recent["INCIDENT_DATE"] = fmt_date(recent["INCIDENT_DATE"])
        recent = recent.rename(columns={
            "INCIDENT_ID": "Incident ID", "INCIDENT_DATE": "Reported",
            "INCIDENT_TYPE": "Type", "INCIDENT_LOCATION": "Location",
            "INCIDENT_STATUS": "Status",
        })
        show_table(recent[["Incident ID", "Reported", "Type", "Location", "Status"]], height=265)

    st.subheader("Project data at a glance")
    species_counts = animals.groupby("SPECIES_COMMON_NAME", as_index=False).size().sort_values("size", ascending=False)
    if not species_counts.empty:
        fig = px.bar(species_counts, x="SPECIES_COMMON_NAME", y="size", text="size")
        fig.update_layout(xaxis_title="Species", yaxis_title="Animal records", margin=dict(t=12, b=8, l=8, r=8))
        st.plotly_chart(fig, width="stretch", config={"displayModeBar": False})

elif page == "Incidents":
    show_hero("Incident register", "Search and review incident records from the supplied project dataset.", "Case management")
    filtered = incidents.copy()
    a, b, c = st.columns([1, 1, 1.5])
    types = ["All"] + sorted(filtered["INCIDENT_TYPE"].dropna().unique().tolist())
    statuses = ["All"] + sorted(filtered["INCIDENT_STATUS"].dropna().unique().tolist())
    with a:
        chosen_type = st.selectbox("Incident type", types)
    with b:
        chosen_status = st.selectbox("Status", statuses)
    with c:
        search = st.text_input("Search by ID or location", placeholder="e.g. 5001 or Riverside")
    if chosen_type != "All":
        filtered = filtered[filtered["INCIDENT_TYPE"] == chosen_type]
    if chosen_status != "All":
        filtered = filtered[filtered["INCIDENT_STATUS"] == chosen_status]
    if search.strip():
        query = search.strip().lower()
        filtered = filtered[
            filtered["INCIDENT_ID"].astype(str).str.contains(query, case=False)
            | filtered["INCIDENT_LOCATION"].astype(str).str.contains(query, case=False)
        ]
    display = filtered.copy()
    display["INCIDENT_DATE"] = fmt_date(display["INCIDENT_DATE"])
    display["INCIDENT_RESOLUTION_DATE"] = fmt_date(display["INCIDENT_RESOLUTION_DATE"])
    display = display.rename(columns={
        "INCIDENT_ID": "Incident ID", "INCIDENT_DATE": "Reported",
        "INCIDENT_TYPE": "Type", "INCIDENT_LOCATION": "Location",
        "INCIDENT_STATUS": "Status", "INCIDENT_RESOLUTION_DATE": "Resolved on",
    })
    st.caption(f"Showing {len(display)} of {len(incidents)} incident records. Reporter names and contact details are intentionally not shown in this public demo.")
    show_table(display, height=360)
    if not filtered.empty:
        selected_id = st.selectbox("View incident record", filtered["INCIDENT_ID"].tolist())
        chosen = filtered.loc[filtered["INCIDENT_ID"] == selected_id].iloc[0]
        with st.container(border=True):
            st.markdown(f"**Incident #{int(chosen['INCIDENT_ID'])}** · {chosen['INCIDENT_TYPE']}")
            d1, d2, d3 = st.columns(3)
            d1.write(f"**Reported**\n\n{chosen['INCIDENT_DATE']}")
            d2.write(f"**Status**\n\n{chosen['INCIDENT_STATUS']}")
            d3.write(f"**Resolution date**\n\n{chosen['INCIDENT_RESOLUTION_DATE'] or 'Not recorded'}")
            st.write(f"**Recorded location:** {chosen['INCIDENT_LOCATION']}")
    st.download_button(
        "Download filtered incidents (CSV)",
        data=display.to_csv(index=False).encode("utf-8"),
        file_name="uwrms_incidents_demo.csv",
        mime="text/csv",
    )

elif page == "Animals":
    show_hero("Animal records", "Explore species, intake details, and recorded health conditions.", "Animal lifecycle")
    filtered = animals.copy()
    a, b = st.columns([1, 1.6])
    species_options = ["All"] + sorted(filtered["SPECIES_COMMON_NAME"].dropna().unique().tolist())
    with a:
        species = st.selectbox("Species", species_options)
    with b:
        search = st.text_input("Search animal or incident ID", placeholder="e.g. 1001 or 5001")
    if species != "All":
        filtered = filtered[filtered["SPECIES_COMMON_NAME"] == species]
    if search.strip():
        q = search.strip().lower()
        filtered = filtered[
            filtered["ANIMAL_ID"].astype(str).str.contains(q)
            | filtered["INCIDENT_ID"].astype(str).str.contains(q)
        ]
    display = filtered.copy()
    display["ANIMAL_INTAKE_DATE"] = fmt_date(display["ANIMAL_INTAKE_DATE"])
    display = display.rename(columns={
        "ANIMAL_ID": "Animal ID", "INCIDENT_ID": "Incident ID",
        "SPECIES_COMMON_NAME": "Species", "SPECIES_SCIENTIFIC_NAME": "Scientific name",
        "ANIMAL_AGE_CATEGORY": "Age group", "ANIMAL_SEX": "Sex",
        "ANIMAL_HEALTH_STATUS": "Recorded health", "ANIMAL_INTAKE_DATE": "Intake date",
        "ANIMAL_IDENTIFICATION_MARK": "Identification mark",
    })
    show_table(display, height=350)
    st.download_button(
        "Download filtered animal records (CSV)",
        data=display.to_csv(index=False).encode("utf-8"),
        file_name="uwrms_animals_demo.csv",
        mime="text/csv",
    )
    st.info("Health values are copied from the sample database as recorded; this interface does not make veterinary assessments.")

elif page == "Facilities":
    show_hero("Facilities & resources", "Review the facilities and the historical animal assignments linked to each site.", "Care network")
    view = facilities.rename(columns={
        "FACILITY_ID": "Facility ID", "FACILITY_NAME": "Facility",
        "FACILITY_CITY": "City", "FACILITY_TYPE": "Facility type",
        "FACILITY_CAPACITY": "Listed capacity",
        "PERMIT_ID": "Permit ID",
        "HISTORICAL_ANIMAL_ASSIGNMENTS": "Historical assignments",
    })
    show_table(view, height=300)

    st.subheader("Inventory snapshot")
    inventory = read_query(
        """SELECT INVENTORY_ITEM_NAME, INVENTORY_CATEGORY, INVENTORY_QUANTITY,
                  INVENTORY_UNIT, INVENTORY_REORDER_LEVEL, INVENTORY_LAST_UPDATED
           FROM INVENTORY ORDER BY INVENTORY_ITEM_NAME"""
    )
    inventory["INVENTORY_LAST_UPDATED"] = fmt_date(inventory["INVENTORY_LAST_UPDATED"])
    inventory = inventory.rename(columns={
        "INVENTORY_ITEM_NAME": "Item", "INVENTORY_CATEGORY": "Category",
        "INVENTORY_QUANTITY": "Quantity", "INVENTORY_UNIT": "Unit",
        "INVENTORY_REORDER_LEVEL": "Reorder level", "INVENTORY_LAST_UPDATED": "Last updated",
    })
    show_table(inventory, height=260)
    permits = read_query(
        """SELECT PERMIT_ID, PERMIT_TYPE, PERMIT_ISSUED_TO, PERMIT_EXPIRY_DATE, PERMIT_STATUS
           FROM PERMIT ORDER BY PERMIT_EXPIRY_DATE"""
    )
    permit_expiry = pd.to_datetime(permits["PERMIT_EXPIRY_DATE"], errors="coerce")
    expired_but_active = (permit_expiry < pd.Timestamp.today().normalize()) & (permits["PERMIT_STATUS"].str.lower() == "active")
    permits["EXPIRY_CHECK"] = permit_expiry.apply(
        lambda value: "Past expiry date - verify" if pd.notna(value) and value.date() < pd.Timestamp.today().date() else "Not past expiry date"
    )
    permits["PERMIT_EXPIRY_DATE"] = fmt_date(permits["PERMIT_EXPIRY_DATE"])
    permits = permits.rename(columns={
        "PERMIT_ID": "Permit ID", "PERMIT_TYPE": "Permit type",
        "PERMIT_ISSUED_TO": "Issued to", "PERMIT_EXPIRY_DATE": "Expiry date",
        "PERMIT_STATUS": "Stored status", "EXPIRY_CHECK": "Date check",
    })
    if int(expired_but_active.sum()) > 0:
        st.warning(f"Data-quality flag: {int(expired_but_active.sum())} permit record(s) are stored as Active even though the expiry date has passed. Verify before any compliance use.")
    with st.expander("Permit register (stored fields and date check)"):
        show_table(permits, height=250)
        st.caption("The date check is calculated by the app; it does not amend the source permit status.")

elif page == "Rescue operations":
    show_hero("Rescue operations", "Review responder assignments, treatment records, facility placements, and release outcomes.", "Care workflow")
    assignments = read_query(
        """SELECT ASG.ASSIGNMENT_ID, ASG.INCIDENT_ID, ASG.RESPONDER_ID,
                  R.RESPONDER_ROLE, R.RESPONDER_AVAILABILITY,
                  ASG.ASSIGNMENT_DATE, ASG.ASSIGNMENT_STATUS, ASG.ASSIGNMENT_NOTES
           FROM ASSIGNMENT ASG JOIN RESPONDER R ON R.RESPONDER_ID = ASG.RESPONDER_ID
           ORDER BY ASG.ASSIGNMENT_DATE DESC"""
    )
    st.subheader("Responder assignments")
    assignments["ASSIGNMENT_DATE"] = pd.to_datetime(assignments["ASSIGNMENT_DATE"], errors="coerce").dt.strftime("%b %d, %Y %I:%M %p").fillna("—")
    assignments = assignments.rename(columns={
        "ASSIGNMENT_ID": "Assignment ID", "INCIDENT_ID": "Incident ID",
        "RESPONDER_ID": "Responder ID", "RESPONDER_ROLE": "Responder role",
        "RESPONDER_AVAILABILITY": "Availability in sample",
        "ASSIGNMENT_DATE": "Assigned", "ASSIGNMENT_STATUS": "Assignment status",
        "ASSIGNMENT_NOTES": "Operational note",
    })
    show_table(assignments, height=260)

    left, right = st.columns(2, gap="large")
    with left:
        st.subheader("Treatment log")
        treatments = read_query(
            """SELECT TREATMENT_ID, ANIMAL_ID, RESPONDER_ID, TREATMENT_DATE,
                      TREATMENT_PROCEDURE_TYPE, TREATMENT_OUTCOME
               FROM TREATMENT ORDER BY TREATMENT_DATE DESC"""
        )
        treatments["TREATMENT_DATE"] = pd.to_datetime(treatments["TREATMENT_DATE"], errors="coerce").dt.strftime("%b %d, %Y %I:%M %p").fillna("—")
        treatments = treatments.rename(columns={
            "TREATMENT_ID": "Treatment ID", "ANIMAL_ID": "Animal ID",
            "RESPONDER_ID": "Responder ID", "TREATMENT_DATE": "Date",
            "TREATMENT_PROCEDURE_TYPE": "Procedure", "TREATMENT_OUTCOME": "Outcome",
        })
        show_table(treatments, height=250)
    with right:
        st.subheader("Release outcomes")
        releases = read_query(
            """SELECT RELEASE_ID, ANIMAL_ID, RELEASE_DATE, RELEASE_LOCATION,
                      RELEASE_CONDITION, RELEASE_FOLLOWUP_STATUS
               FROM `RELEASE` ORDER BY RELEASE_DATE DESC"""
        )
        releases["RELEASE_DATE"] = fmt_date(releases["RELEASE_DATE"])
        releases = releases.rename(columns={
            "RELEASE_ID": "Release ID", "ANIMAL_ID": "Animal ID",
            "RELEASE_DATE": "Release date", "RELEASE_LOCATION": "Location",
            "RELEASE_CONDITION": "Condition", "RELEASE_FOLLOWUP_STATUS": "Follow-up",
        })
        show_table(releases, height=250)
    st.subheader("Inventory update by facility assignment")
    inventory_updates = read_query(
        """SELECT AFA.ANIMAL_FACILITY_ASSIGNMENT_ID, AFA.ANIMAL_ID,
                  F.FACILITY_NAME, MAX(I.INVENTORY_LAST_UPDATED) AS LAST_INVENTORY_DATE
           FROM ANIMAL_FACILITY_ASSIGNMENT AFA
           JOIN FACILITY F ON F.FACILITY_ID = AFA.FACILITY_ID
           LEFT JOIN INVENTORY I ON I.ANIMAL_FACILITY_ASSIGNMENT_ID = AFA.ANIMAL_FACILITY_ASSIGNMENT_ID
           GROUP BY AFA.ANIMAL_FACILITY_ASSIGNMENT_ID, AFA.ANIMAL_ID, F.FACILITY_NAME
           ORDER BY AFA.ANIMAL_FACILITY_ASSIGNMENT_ID"""
    )
    inventory_updates["LAST_INVENTORY_DATE"] = fmt_date(inventory_updates["LAST_INVENTORY_DATE"])
    inventory_updates = inventory_updates.rename(columns={
        "ANIMAL_FACILITY_ASSIGNMENT_ID": "Facility assignment ID",
        "ANIMAL_ID": "Animal ID", "FACILITY_NAME": "Facility",
        "LAST_INVENTORY_DATE": "Last inventory update",
    })
    show_table(inventory_updates, height=230)
    st.caption("Responder names, phone numbers, and email addresses are intentionally excluded from this public portfolio demo.")

elif page == "Analytics":
    show_hero("Rescue insights", "A compact view of the trends contained in the sample dataset.", "Reporting & analytics")
    c1, c2 = st.columns(2, gap="large")
    with c1:
        st.subheader("Incidents by type")
        by_type = incidents.groupby("INCIDENT_TYPE", as_index=False).size().sort_values("size", ascending=False)
        fig = px.bar(by_type, x="INCIDENT_TYPE", y="size", text="size")
        fig.update_layout(xaxis_title="Incident type", yaxis_title="Records", margin=dict(t=12, b=8, l=8, r=8))
        st.plotly_chart(fig, width="stretch", config={"displayModeBar": False})
    with c2:
        st.subheader("Animals by species")
        by_species = animals.groupby("SPECIES_COMMON_NAME", as_index=False).size().sort_values("size", ascending=False)
        fig = px.bar(by_species, x="SPECIES_COMMON_NAME", y="size", text="size")
        fig.update_layout(xaxis_title="Species", yaxis_title="Animal records", margin=dict(t=12, b=8, l=8, r=8))
        fig.update_xaxes(tickangle=-25)
        st.plotly_chart(fig, width="stretch", config={"displayModeBar": False})

    c3, c4 = st.columns(2, gap="large")
    with c3:
        st.subheader("Recorded health conditions")
        by_health = animals.groupby("ANIMAL_HEALTH_STATUS", as_index=False).size().sort_values("size", ascending=False)
        fig = px.bar(by_health, x="ANIMAL_HEALTH_STATUS", y="size", text="size")
        fig.update_layout(xaxis_title="Recorded condition", yaxis_title="Animal records", margin=dict(t=12, b=8, l=8, r=8))
        fig.update_xaxes(tickangle=-25)
        st.plotly_chart(fig, width="stretch", config={"displayModeBar": False})
    with c4:
        st.subheader("Incident status")
        by_status = incidents.groupby("INCIDENT_STATUS", as_index=False).size()
        fig = px.pie(by_status, names="INCIDENT_STATUS", values="size", hole=0.6)
        fig.update_layout(margin=dict(t=12, b=8, l=8, r=8), legend_title_text="Status")
        st.plotly_chart(fig, width="stretch", config={"displayModeBar": False})

    st.info(
        "These charts describe only the records included in the SQL dump (5 incidents and 5 animal records). "
        "They should not be interpreted as representative city-wide wildlife trends."
    )

st.divider()
st.caption("UWRMS · Streamlit starter · Read-only demonstration built from the supplied database dump")
