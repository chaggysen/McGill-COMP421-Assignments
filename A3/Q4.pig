popcsv = LOAD '/data/pop.csv' USING PigStorage(',') AS (country:CHARARRAY, population:INT);

vdatacsv = LOAD '/data/vaccination-data.csv' USING PigStorage(',') AS (country:CHARARRAY, iso3:CHARARRAY, who_region:CHARARRAY, persons_fully_vaccinated:INT);

who_group = group vdatacsv by who_region;

datas = foreach who_group generate ($0),COUNT($1),SUM(vdatacsv.persons_fully_vaccinated);

DUMP datas;

-- DESCRIBE who_group;
