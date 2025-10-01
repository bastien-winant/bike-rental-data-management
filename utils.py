import pandas as pd
import yaml
from pathlib import Path

BASE_PATH = Path(__file__).parent

with open(BASE_PATH / 'schema.ignore.yml', 'r') as file:
	schemas = yaml.safe_load(file)

def read_raw_file(file_name) -> pd.DataFrame:
	df = pd.read_csv(BASE_PATH / "data" / file_name)
	return df

def create_table(cur, tbl_ref):
	tbl_name = schemas[tbl_ref][0]['name']
	tbl_schema = schemas[tbl_ref][0]['schema']

	cur.execute(f"""
		CREATE TABLE IF NOT EXISTS {tbl_name} (
			{tbl_schema}
		);""")

def insert_table_values(cur, tbl_ref, df):
	insert_query = schemas[tbl_ref][0]['insert']
	records = df.to_records(index=False)
	values = [tuple(r) for r in records]
	cur.executemany(insert_query, values)