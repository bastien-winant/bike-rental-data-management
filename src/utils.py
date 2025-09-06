from pathlib import Path
import pandas as pd


def get_project_root() -> Path:
	"""Return project root directory (two levels up from this file)."""
	return Path(__file__).resolve().parents[1]


def get_data_path(subdir: str, filename: str) -> Path:
	"""
	Build a path to a file in the data/ directory.
	Example: get_data_path("raw", "bike_rentals.csv")
	:param subdir: name of the folder that holds the data file
	:param filename: name of the data file
	:return: relative path to the data file
	"""
	return get_project_root() / "data" / subdir / filename


def read_raw_file(filename: str) -> pd.DataFrame:
	"""
	Read in a file in the data/raw/ directory as a Pandas Dataframe
	:param filename: name of the data file
	:return: Pandas Dataframe
	"""
	file_path = get_data_path(subdir='raw', filename=filename)
	df = pd.read_csv(file_path)

	return df


def save_processed_file(df: pd.DataFrame, filename: str, append: bool = False):
	"""
	Save a Pandas DataFrame as CSV to the data/processed/ directory
	:param df: Pandas DataFrame
	:param filename: name of the data file
	:param append: whether to write in append mode
	:return:
	"""
	file_path = get_data_path(subdir='processed', filename=filename)
	mode = 'a' if append else 'w'
	df.to_csv(file_path, index=False, mode=mode)