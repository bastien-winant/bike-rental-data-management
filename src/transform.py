import pandas as pd
from src.utils import read_raw_file, save_processed_file


def transform_rides_data():
	df = read_raw_file("JC-201605-citibike-tripdata.csv")

	df['Start Time'] = pd.to_datetime(df['Start Time'])
	df['Stop Time'] = pd.to_datetime(df['Stop Time'])
	df.drop('Trip Duration', axis=1, inplace=True)

	df_start_stations = df[
		['Start Station ID', 'Start Station Name', 'Start Station Latitude', 'Start Station Longitude']]\
		.drop_duplicates()\
		.rename(
			{
				'Start Station ID': 'ID',
				'Start Station Name': 'Name',
				'Start Station Latitude': 'Latitude',
				'Start Station Longitude': 'Longitude'
		}, axis=1)

	df_end_stations = df[
		['End Station ID', 'End Station Name', 'End Station Latitude', 'End Station Longitude']]\
		.drop_duplicates()\
		.rename(
			{
				'End Station ID': 'ID',
				'End Station Name': 'Name',
				'End Station Latitude': 'Latitude',
				'End Station Longitude': 'Longitude'
		}, axis=1)

	df_stations = pd.concat([df_start_stations, df_end_stations], ignore_index=True)
	save_processed_file(df_stations, 'bike_stations.csv')


def transform_weather_data():
	# read in the raw data
	df = read_raw_file("newark_airport_2016.csv")

	# remove columns with all missing values
	df.dropna(axis=1, inplace=True, how='all')

	# convert date strings to datetime objects
	df.DATE = pd.to_datetime(df.DATE)

	df_station = df[['STATION', 'NAME']].drop_duplicates(ignore_index=True)
	save_processed_file(df_station, 'weather_stations.csv')

	df.drop('NAME', axis=1, inplace=True)
	save_processed_file(df, 'weather.csv')


if __name__ == "__main__":
	transform_weather_data()
