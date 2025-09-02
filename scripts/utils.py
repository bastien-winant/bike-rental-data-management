from pathlib import Path
import pandas as pd
import yaml

def load_config(config_path="../config/project_config.yaml"):
	"""Load YAML configuration."""
	with open(config_path, "r") as f:
			return yaml.safe_load(f)

def load_raw_file(file_name, config_path="../config/project_config.yaml"):
	"""
	Load a single raw CSV file based on config.
	file_key: e.g. "customers" or "orders"
	"""
	config = load_config(config_path)
	raw_dir = Path(config["data"]["raw_dir"])
	file_path = raw_dir / file_name

	return pd.read_csv(file_path)