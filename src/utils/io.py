import os
from typing import Optional

import pandas as pd
from pyspark.sql import SparkSession, DataFrame as SparkDataFrame
from dotenv import load_dotenv


def get_spark(app_name: str = "censo_etl") -> SparkSession:
    load_dotenv()
    app = os.getenv("SPARK_APP_NAME", app_name)
    driver_mem = os.getenv("SPARK_DRIVER_MEMORY", "2g")
    executor_mem = os.getenv("SPARK_EXECUTOR_MEMORY", "2g")
    return (
        SparkSession.builder.appName(app)
        .config("spark.driver.memory", driver_mem)
        .config("spark.executor.memory", executor_mem)
        .getOrCreate()
    )


def read_csv_spark(spark: SparkSession, path: str, header: bool = True, infer_schema: bool = True, sep: str = ",") -> SparkDataFrame:
    return (
        spark.read.option("header", str(header).lower())
        .option("inferSchema", str(infer_schema).lower())
        .option("sep", sep)
        .csv(path)
    )


def read_parquet_spark(spark: SparkSession, path: str) -> SparkDataFrame:
    return spark.read.parquet(path)


def to_pandas(df: SparkDataFrame) -> pd.DataFrame:
    return df.toPandas()

