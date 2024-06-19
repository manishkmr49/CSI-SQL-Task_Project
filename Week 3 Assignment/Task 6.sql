
IF OBJECT_ID('dbo.STATION', 'U') IS NULL
BEGIN
    CREATE TABLE STATION (
        ID INT PRIMARY KEY,
        CITY VARCHAR(21),
        STATE CHAR(2),
        LAT_N FLOAT,
        LONG_W FLOAT
    );
END
-- Insert sample data into STATION table
-- Clear existing data to avoid duplicates
DELETE FROM STATION;

INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES
(1, 'CityA', 'AA', 34.05, -118.25),
(2, 'CityB', 'BB', 40.71, -74.00),
(3, 'CityC', 'CC', 41.87, -87.62),
(4, 'CityD', 'DD', 25.76, -80.19),
(5, 'CityE', 'EE', 36.16, -115.15);


-- Query to find the Manhattan Distance between the points
WITH MinMaxValues AS (
    SELECT 
        MIN(LAT_N) AS min_lat,
        MAX(LAT_N) AS max_lat,
        MIN(LONG_W) AS min_long,
        MAX(LONG_W) AS max_long
    FROM STATION
)
SELECT 
    ROUND(ABS(max_lat - min_lat) + ABS(max_long - min_long), 4) AS Manhattan_Distance
FROM MinMaxValues;
