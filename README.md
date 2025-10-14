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

It provides daily measurements related to temperature, precipitations, and wind speed.
For this project, we use the 2016 data recorded from the Newark Airport station.

## Approach
### Data Ingestion


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
## Decision and Roadblocks
## Next Steps
## Who am I?
I am Computer Science student at University of London (Goldsmiths) with a focus on data science.
I have a particular interest for data engineering and business analytics.

The skills that I currently focus on are:
- data modeling and pipeline design
- data transformation with SQL and Python
- orchestration and scheduling with AWS