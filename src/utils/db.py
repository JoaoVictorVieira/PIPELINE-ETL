import os
from typing import Optional

from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine
from dotenv import load_dotenv


def build_postgres_url(
    host: Optional[str] = None,
    port: Optional[str] = None,
    db: Optional[str] = None,
    user: Optional[str] = None,
    password: Optional[str] = None,
) -> str:
    load_dotenv()
    host = host or os.getenv("POSTGRES_HOST", "localhost")
    port = port or os.getenv("POSTGRES_PORT", "5432")
    db = db or os.getenv("POSTGRES_DB", "etl_censo")
    user = user or os.getenv("POSTGRES_USER", "etl_user")
    password = password or os.getenv("POSTGRES_PASSWORD", "etl_password")
    return f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{db}"


def get_engine(url: Optional[str] = None) -> Engine:
    url = url or build_postgres_url()
    return create_engine(url, pool_pre_ping=True, future=True)


def execute_sql(engine: Engine, sql: str) -> None:
    with engine.begin() as conn:
        conn.execute(text(sql))


def dataframe_to_table(df, engine: Engine, table: str, schema: str, if_exists: str = "append") -> None:
    df.to_sql(table, engine, schema=schema, if_exists=if_exists, index=False, method="multi", chunksize=5000)

