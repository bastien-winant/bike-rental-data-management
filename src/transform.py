import pandas as pd
from src.process_utils import read_raw_file, save_processed_file, get_project_root, clear_data_folder
import re
import os


def transform_rides_data(filename):
	df = read_raw_file(filename)

	# convert columns to datetime type
	df['Start Time'] = pd.to_datetime(df['Start Time'])
	df['Stop Time'] = pd.to_datetime(df['Stop Time'])

	# remove calculated field
	df.drop('Trip Duration', axis=1, inplace=True)

	# decompose stations data
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

	df_stations = pd.concat([df_start_stations, df_end_stations]).drop_duplicates(ignore_index=True)
	save_processed_file(df_stations, 'bike_stations.csv', True)

	df.drop(['Start Station Name', 'Start Station Latitude', 'Start Station Longitude',
					 'End Station Name', 'End Station Latitude', 'End Station Longitude'], axis=1, inplace=True)

	# convert to integer
	df['Birth Year'] = df['Birth Year'].fillna(-999).astype(int).replace(-999, None)

	try:
		m = re.search(r"[0-9]{6}", filename)
		file_month = m.group()
		save_processed_file(df, f'{file_month}_rides.csv')
	except AttributeError:
		print("File name should be in the format: JS-<yyyymm>-citibike-tripdata.csv")


def transform_weather_data():
	# read in the raw data
	df = read_raw_file("newark_airport_2016.csv")

	# remove columns with all missing values
	df.dropna(axis=1, inplace=True, how='all')

	# convert date strings to datetime objects
	df.DATE = pd.to_datetime(df.DATE)

	# decompose station data
	df_station = df[['STATION', 'NAME']].drop_duplicates(ignore_index=True)
	save_processed_file(df_station, 'weather_stations.csv')

	df.drop('NAME', axis=1, inplace=True)
	save_processed_file(df, 'weather.csv')


if __name__ == "__main__":
	# clear the processed data folder
	clear_data_folder('processed')

	# transform rides data
	raw_data_path = get_project_root() / 'data' / 'raw'
	for filename in os.listdir(raw_data_path):
		m = re.match(r'^JC-(\d){6}-citibike-tripdata.csv$', filename)
		if m:
			filename = m.group()
			transform_rides_data(filename=filename)

	# transform weather data
	transform_weather_data()
