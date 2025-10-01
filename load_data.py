import argparse
import typing as t
from datetime import datetime, timedelta
from utils import *
import psycopg
import pandas as pd
from sqlmesh.utils.date import to_datetime, to_ds

DB_NAME = "citibike_rides_analytics"
DB_USER = "bastienwinant"
RAW_SCHEMA = "raw"

def add_raw_data(
		start: str,
    end: str = None,
    reset: bool = False,
		raw_schema: str = RAW_SCHEMA,
		db_name: str = DB_NAME,
		db_user: str = DB_USER
) -> None:
	"""
	Ingest raw data and add it to the Postgres database.
	"""
	start_dt = to_datetime(start).date()
	end_dt = to_datetime(end).date() if end else start_dt

	# Connect to an existing database
	with psycopg.connect(dbname=db_name, user=db_user) as conn:
		# Open a cursor to perform database operations
		with conn.cursor() as cur:
			cur.execute(f"CREATE SCHEMA IF NOT EXISTS {raw_schema}")

			add_weather_data(cur=cur, start=start_dt, end=end_dt)
			add_rides_data(cur=cur, start=start_dt, end=end_dt)
	return

def add_weather_data(cur: psycopg.Cursor, start: datetime.date, end: datetime.date) -> None:
	create_table(cur,'weather_metrics')

	df = read_raw_file("newark_airport_2016.csv")

	df.DATE = pd.to_datetime(df.DATE).dt.date
	df = df.loc[(df.DATE >= start) & (df.DATE <= end)]

	df.TAVG = df.TAVG.fillna(-1).astype(int).replace(-1, None)
	df.TMAX = df.TMAX.fillna(-1).astype(int).replace(-1, None)
	df.TMIN = df.TMIN.fillna(-1).astype(int).replace(-1, None)
	df.TSUN = df.TSUN.fillna(-1).astype(int).replace(-1, None)
	df.WDF2 = df.WDF2.fillna(-1).astype(int).replace(-1, None)
	df.WDF5 = df.WDF5.fillna(-1).astype(int).replace(-1, None)

	insert_table_values(cur, 'weather_metrics', df)


def add_rides_data(cur: psycopg.Cursor, start: datetime.date, end: datetime.date) -> None:
	# create target tables if not exists
	create_table(cur,'citibike_rides')

	# read in monthly files corresponding to supplied range
	range_months = [datetime.strftime(date, '%Y%m') for date in pd.date_range(start=start, end=end, freq='MS')]
	dfs = []
	for month in range_months:
		try:
			df_month = read_raw_file(f"JC-{month}-citibike-tripdata.csv")
			dfs.append(df_month)
		except:
			continue

	# concatenate monthly data
	df = pd.concat(dfs, ignore_index=True)

	# filter date range based on ride start times
	df['Start Time'] = pd.to_datetime(df['Start Time'])
	df = df.loc[
		(df['Start Time'] >= pd.to_datetime(start)) &
		(df['Start Time'] < pd.to_datetime(end + timedelta(days=1))), :]
	df['Start Time'] = df['Start Time'].astype(str)

	df['Birth Year'] = df['Birth Year'].fillna(-1).astype(int).replace(-1, None)

	insert_table_values(cur, 'citibike_rides', df)

def parse_arguments() -> dict[str, str]:
	parser = argparse.ArgumentParser(description="Add data to the Citibike rides database.")

	parser.add_argument("--start", help="First day to add data for")
	parser.add_argument("--end", help="Last day to add data for")
	parser.add_argument("--reset", help="Reset database to initial state", action="store_true")

	return vars(parser.parse_args())


if __name__ == "__main__":
	args: dict[str, t.Any] = parse_arguments()
	add_raw_data(**args)