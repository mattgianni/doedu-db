# doedu-db-hack

A hack to collect and organize data on San Francisco schools and student outcomes. The primary goal is to integrate this data with additional sources to support the [Support SF Schools](https://github.com/sfbrigade/support-sfusd) project. These data may be useful for other projects as well, and this effort is organized as a separate project to facilitate reuse.

The major source of student outcome data comes from the [California Assessment of Student Performance and Progress (**CAASPP**)](https://caaspp-elpac.ets.org/caaspp/) website. The data includes information on student performance in English language arts and mathematics. The data is available in a variety of formats, but does not directly support the needs of the [Support SF Schools](https://github.com/sfbrigade/support-sfusd) project.

This project aims to create a [PostgreSQL](https://www.postgresql.org/) database of this dataset to extract the metrics needed for the [Support SF Schools](https://github.com/sfbrigade/support-sfusd) project, as well as future projects.

## Setup

1. Install the requirements:

```bash
pip install -r requirements.txt
```

2. Configure the database connection details in `.env`. A decent password can be generated using the following command:

```bash
openssl rand -base64 32
```

3. Download and preprocess the source data from the California Dept of Education website. The following script will download the data and preprocess it:

```bash
./getraw.sh
```

4. Build the database using Docker:

```bash
docker-compose up -d
```
