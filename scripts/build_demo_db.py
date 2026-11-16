"""Build a read-only SQLite copy of the supplied MySQL demo database.

This script preserves the source rows and column names. It converts the MySQL
schema into a lightweight SQLite database for local/Streamlit demonstration.
"""
from __future__ import annotations

import re
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE_SQL = ROOT / "Data Book" / "uwrms.sql"
TARGET_DB = ROOT / "data" / "uwrms_demo.sqlite"


def split_column_lines(table_body: str) -> list[str]:
    columns = []
    for line in table_body.splitlines():
        line = line.strip().rstrip(",")
        if line.startswith("`"):
            columns.append(line)
    return columns


def sqlite_type(mysql_type: str) -> str:
    base = mysql_type.lower()
    if base in {"int", "integer", "tinyint", "smallint", "mediumint", "bigint"}:
        return "INTEGER"
    if base in {"decimal", "numeric", "float", "double", "real"}:
        return "REAL"
    return "TEXT"


def parse_tables(sql: str):
    tables = {}
    pattern = re.compile(
        r"CREATE TABLE `(?P<table>[^`]+)`\s*\((?P<body>.*?)\) ENGINE=",
        re.IGNORECASE | re.DOTALL,
    )
    for match in pattern.finditer(sql):
        table = match.group("table")
        columns = []
        for line in split_column_lines(match.group("body")):
            col_match = re.match(r"`([^`]+)`\s+([A-Za-z]+)(?:\([^)]*\))?(.*)$", line)
            if not col_match:
                continue
            name, mysql_type, rest = col_match.groups()
            nullable = " NOT NULL" if "NOT NULL" in rest.upper() else ""
            columns.append((name, sqlite_type(mysql_type), nullable))
        tables[table] = columns
    return tables


def parse_primary_keys(sql: str):
    keys = {}
    pattern = re.compile(
        r"ALTER TABLE `([^`]+)`\s+ADD PRIMARY KEY \(([^)]+)\)",
        re.IGNORECASE,
    )
    for table, cols in pattern.findall(sql):
        keys[table] = [c.strip().strip("`") for c in cols.split(",")]
    return keys


def parse_foreign_keys(sql: str):
    keys = {}
    pattern = re.compile(
        r"ALTER TABLE `([^`]+)`\s+ADD CONSTRAINT `([^`]+)`\s+"
        r"FOREIGN KEY \(`([^`]+)`\) REFERENCES `([^`]+)` \(`([^`]+)`\)([^;]*);",
        re.IGNORECASE,
    )
    for table, name, local_col, ref_table, ref_col, tail in pattern.findall(sql):
        action = ""
        for kind in ("DELETE", "UPDATE"):
            found = re.search(rf"ON {kind} (CASCADE|RESTRICT|SET NULL|NO ACTION)", tail, re.I)
            if found:
                action += f" ON {kind} {found.group(1).upper()}"
        keys.setdefault(table, []).append((local_col, ref_table, ref_col, action))
    return keys


def parse_unique_keys(sql: str):
    keys = []
    pattern = re.compile(
        r"ALTER TABLE `([^`]+)`\s+ADD UNIQUE KEY `([^`]+)` \(([^)]+)\)",
        re.IGNORECASE,
    )
    for table, name, cols in pattern.findall(sql):
        cols = [c.strip().strip("`") for c in cols.split(",")]
        keys.append((table, name, cols))
    return keys


def main() -> None:
    if not SOURCE_SQL.exists():
        raise FileNotFoundError(f"Could not find source SQL dump: {SOURCE_SQL}")

    sql = SOURCE_SQL.read_text(encoding="utf-8")
    tables = parse_tables(sql)
    primary_keys = parse_primary_keys(sql)
    foreign_keys = parse_foreign_keys(sql)
    unique_keys = parse_unique_keys(sql)

    if not tables:
        raise RuntimeError("No CREATE TABLE statements were found in the source dump.")

    TARGET_DB.parent.mkdir(parents=True, exist_ok=True)
    if TARGET_DB.exists():
        TARGET_DB.unlink()

    conn = sqlite3.connect(TARGET_DB)
    try:
        conn.execute("PRAGMA foreign_keys = ON")
        for table, columns in tables.items():
            definitions = []
            for name, col_type, nullable in columns:
                definitions.append(f'`{name}` {col_type}{nullable}')
            if table in primary_keys:
                cols = ", ".join(f'`{c}`' for c in primary_keys[table])
                definitions.append(f"PRIMARY KEY ({cols})")
            for local_col, ref_table, ref_col, action in foreign_keys.get(table, []):
                definitions.append(
                    f"FOREIGN KEY (`{local_col}`) REFERENCES `{ref_table}` (`{ref_col}`){action}"
                )
            conn.execute(f"CREATE TABLE `{table}` ({', '.join(definitions)})")

        # Preserve declared unique constraints. Ordinary non-unique indexes are
        # intentionally omitted because this small dataset is for demonstration.
        for table, name, cols in unique_keys:
            col_sql = ", ".join(f'`{c}`' for c in cols)
            conn.execute(f"CREATE UNIQUE INDEX `{name}` ON `{table}` ({col_sql})")

        # Defer FK checks until all inserts have loaded; MySQL dump order is not
        # guaranteed to be parent-before-child.
        conn.execute("BEGIN")
        conn.execute("PRAGMA defer_foreign_keys = ON")

        # The INSERT statements in the source dump are SQL-standard enough for
        # SQLite (quoted identifiers, NULLs, strings and numeric values).
        insert_pattern = re.compile(
            r"INSERT INTO `[^`]+`\s*\([^;]*?\)\s*VALUES\s*.*?;",
            re.IGNORECASE | re.DOTALL,
        )
        inserts = insert_pattern.findall(sql)
        for statement in inserts:
            conn.execute(statement)

        conn.commit()
        violations = conn.execute("PRAGMA foreign_key_check").fetchall()
        if violations:
            raise RuntimeError(f"Foreign-key validation failed: {violations[:10]}")

        print(f"Created {TARGET_DB}")
        for table in tables:
            count = conn.execute(f"SELECT COUNT(*) FROM `{table}`").fetchone()[0]
            print(f"{table}: {count} rows")
        print(f"Foreign-key check: passed; tables: {len(tables)}")
    finally:
        conn.close()


if __name__ == "__main__":
    main()
