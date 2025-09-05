import pandas as pd
from src.utils import get_data_path

def load_rentals():
	weather_data_path = get_data_path("raw", "newark_airport_2016.csv")
	df = pd.read_csv(weather_data_path)
	return df


if __name__ == "__main__":
	rentals = load_rentals()
	print(rentals.head())
