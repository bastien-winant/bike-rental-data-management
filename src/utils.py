from pathlib import Path

def get_project_root() -> Path:
	"""Return project root directory (two levels up from this file)."""
	return Path(__file__).resolve().parents[1]

def get_data_path(subdir: str, filename: str) -> Path:
	"""
	Build a path to a file in the data/ directory.
	Example: get_data_path("raw", "bike_rentals.csv")
	"""
	return get_project_root() / "data" / subdir / filename
