import pandas as pd
from src.process_utils import read_raw_file, read_processed_file
from sqlalchemy import create_engine

engine = create_engine("postgresql+psycopg2://root:root@localhost:5432/bike_rentals")

conn = engine.connect()

df = read_raw_file('newark_airport_2016.csv')
df.to_sql(
	name='weather',
	con=conn,
	schema='raw',
	if_exists='replace',
	index=False
)

df = read_processed_file('weather.csv')
df.to_sql(
	name='weather_metrics',
	con=conn,
	schema='staging',
	if_exists='replace',
	index=False
)

df = read_processed_file('weather_stations.csv')
df.to_sql(
	name='weather_stations',
	con=conn,
	schema='staging',
	if_exists='replace',
	index=False
)

conn.close()