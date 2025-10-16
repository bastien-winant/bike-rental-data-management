# Bike Rental Data Management
## Problem
Citi Bike is a bikeshare program that allows its users to conveniently pick up and drop off rental bikes at
designated stations. The company operates over 25000 bikes and 1500 stations in and around New York City and New Jersey.

Citi Bike has asked you to create a database to help their analysts understand the effects of weather on bike rentals.
However, they have no data warehouse and no way to build (let alone schedule) data models.
The company has provided a year of bike rental data along with weather data sourced from the government.

The aim of this project is to provide datasets ready for analysis by completing the following tasks:
- cleaning and validating both data sets
- designing a relational PostgreSQL database to store the data
- developing views for the database to assist the analytics team

The final datasets should allow for answering business questions with minimal ad-hoc manipulation on the part analysts.

## About the data
### Citi Bike Rentals
The company-provided dataset consists of individual rides taken by users across the network.
Every data point includes details such as end-to-end locations, start and stop timestamps, and basic user information.

Citi Bike publishes this data as downloadable static files via the company's [System Data Portal](https://citibikenyc.com/system-data).
For this project, only files for the year 2016 were used.

### Weather Metrics
Weather data is sourced from the [Global Historical Climatology Network daily](https://www.ncei.noaa.gov/products/land-based-station/global-historical-climatology-network-daily),
a database of daily climate summaries from land surface stations across the globe.
It provides daily measurements related to temperature, precipitations, and wind speed. For this project,
I use the 2016 data recorded from the Newark Airport station.

## Approach
### Data Ingestion
I created a custom Python script for reading the raw files and loading the data into the PostgreSQL database.
The script supports dynamic date-range selection via command-line arguments, and integrates with SQLMesh’s incremental
models used in downstream transformations.

`python load_data.py --start 2016-01-01 --end 2016-06-01`

The structure of the script was adapted from an [SQLMesh example project](https://github.com/TobikoData/sqlmesh-examples/blob/main/001_sushi/2_moderate/addsushidata.py).

### Data Modeling
#### Staging Layer
The staging layer is the first layer managed through SQLMesh framework. It consists of two tables - rides and weather -
consumed from the raw layer. I do not apply any data transformation at this point other than renaming columns.

I use SQLMesh's integrated auditing capabilities to check for duplicates and missing values where applicable.
The purpose of this layer is to ensure basic data cleanliness before transformations are applied in later stages of the pipeline.

#### Core Layer
In the core layer, I normalise and decompose the staging rides and weather tables.
Given that input data, this step mostly consists in separating station info from metric measurements.

![Core Layer Schemas](/img/core_schema.png)

The core layer acts as a single source of truth for the data by providing logically consistent, cleansed, and normalized tables.

#### Marts Layer
The data marts is denormalised and aimed at answering business questions.

### Orchestration
#### Incremental Model
SQLMesh defines different _kinds_ of models, which determine how data is updated. In the staging and core layers of
my pipeline, I make use of the powerful `INCREMENTAL_BY_TIME_RANGE` model.

The `INCREMENTAL_BY_TIME_RANGE` model processes data in time windows, automatically tracking which periods have already
been run so only new or updated time ranges are processed in future runs. In our case, new ride records are appended
to the existing data at every pipeline run. SQLMesh keep tracks of which time window was most recently processed,
and automatically process the next one in the sequence.

This way the entire dataset is not entirely reprocessed each time, which saves compute costs and increases performance of our pipeline.
While this isn’t necessary for the small dataset used in this project, it would be important when processing years worth of bike rental data.

## Next Steps
The logical next step in this project is to orchestrate the data pipeline and periodically refresh the data.
Data engineering projects derive much of their value from delivering fresh and timely data without manual intervention. 

Using a dedicated orchestration tool like Airflow would allow me to manage the dependency of the SQLMesh pipeline on
the custom data upload script.

## Who am I?
I am Computer Science student at University of London (Goldsmiths) with a focus on data science.
I have a particular interest for data engineering and business analytics.

The skills that I currently focus on are:
- data modeling and pipeline design
- data transformation with SQL and Python
- orchestration and scheduling with AWS