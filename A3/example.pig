
--load the data from HDFS and define the schema
-- This is for the world population
popcsv = LOAD '/data/pop.csv' USING PigStorage(',') AS (country:CHARARRAY, population:INT);
-- vaccination metadata - not required for this script.
-- vmetacsv = LOAD '/data/vaccination-metadata.csv' USING PigStorage(',') AS (iso3:CHARARRAY, vaccine_name:CHARARRAY, product_name:CHARARRAY, company_name:CHARARRAY);
-- vaccination data - not required for this script.
-- vdatacsv = LOAD '/data/vaccination-data.csv' USING PigStorage(',') AS (country:CHARARRAY, iso3:CHARARRAY, who_region:CHARARRAY, persons_fully_vaccinated:INT);

-- find records with population above 100 million.
highpop = FILTER popcsv BY  population > 100000;

-- order them by the names of the country.
highpopord = ORDER highpop BY country;

-- display the results.
DUMP highpopord;
