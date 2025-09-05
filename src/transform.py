import pandas as pd
from src.utils import read_raw_file, save_processed_file

def load_weather():
	# read in the raw data
	df = read_raw_file("newark_airport_2016.csv")

	# remove columns with all missing values
	df.dropna(axis=1, inplace=True, how='all')

	# convert date strings to datetime objects
	df.DATE = pd.to_datetime(df.DATE)

	df_station = df[['STATION', 'NAME']].drop_duplicates(ignore_index=True)
	save_processed_file(df_station, 'stations.csv')

	df.drop('NAME', axis=1, inplace=True)
	save_processed_file(df, 'weather.csv')


if __name__ == "__main__":
	load_weather()
