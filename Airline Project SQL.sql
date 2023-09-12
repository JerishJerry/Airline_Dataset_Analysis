
-- Create a new database called airline_project
CREATE DATABASE IF NOT EXISTS airline_project;

-- Show the value of the local_infile variable
SHOW VARIABLES LIKE 'local_infile';

-- Enable the local_infile option to load local data files
SET GLOBAL local_infile = 1;

-- Verify that the local_infile option is enabled
SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- Creating Views
-- Create a view called Date
CREATE VIEW Date AS
SELECT CONCAT(Year, '-', LPAD(Month, 2, '00'), '-', LPAD(Day, 2, '00')) AS Date
FROM maindata_final;

-- Create a view called Quarter
CREATE VIEW Year AS
SELECT YEAR(Date) AS 'Year'
FROM airline_project.Date;

-- Create a view called MonthNumber
CREATE VIEW MonthNumber AS
SELECT DATE_FORMAT(Date, '%m') AS Month_number
FROM airline_project.Date;

-- Create a view called MonthFullName
CREATE VIEW MonthFullName AS
SELECT DATE_FORMAT(Date, '%M') AS 'MonthFullName'
FROM airline_project.Date;

-- Create a view called Quarter
CREATE VIEW Quarter AS
SELECT QUARTER(Date) AS 'Quarter'
FROM airline_project.Date;

-- Create a view called YearMonth
CREATE VIEW YearMonth AS
SELECT DATE_FORMAT(Date, '%Y-%b') AS 'Year_Month'
FROM airline_project.Date;

-- Create a view called WeekdayNumber
CREATE VIEW WeekdayNumber AS
SELECT WEEKDAY(Date) AS 'WeekdayNumber'
FROM airline_project.Date;

-- Create a view called WeekdayName
CREATE VIEW WeekdayName AS
SELECT DAYNAME(Date) AS 'WeekdayName'
FROM airline_project.Date;

-- KPI 1
-- Load factor based on Year Wise
SELECT
    Year,
    CONCAT(ROUND((SUM(TransportedPassengers) / SUM(AvailableSeats)) * 100, 2), '%') AS LoadFactorPercentage
FROM
    maindata_final
GROUP BY
    Year;

-- Load factor based on Month Wise  
SELECT
    Year,
    Month,
    CONCAT(ROUND((SUM(TransportedPassengers) / SUM(AvailableSeats)) * 100, 2), '%') AS LoadFactorPercentage
FROM
    maindata_final
GROUP BY
    Year, Month
ORDER BY
    Year, Month;

-- Load factor based on Quarter Wise
SELECT
    Year,
    QUARTER(CONCAT(Year, '-', LPAD(Month, 2, '00'), '-', LPAD(Day, 2, '00'))) AS Quarter,
    CONCAT(ROUND((SUM(TransportedPassengers) / SUM(AvailableSeats)) * 100, 2), '%') AS LoadFactorPercentage
FROM
    maindata_final
GROUP BY
    Year, Quarter
ORDER BY
    Year, Quarter;

-- KPI 2
-- Load factor based on Carrier Name Wise
SELECT 
    CarrierName,
    CONCAT(ROUND((SUM(TransportedPassengers) / SUM(AvailableSeats)) * 100, 2), '%') AS LoadFactorPercentage
FROM 
    maindata_final
GROUP BY 
    CarrierName
ORDER BY
    LoadFactorPercentage DESC
LIMIT 10;

-- KPI 3
-- Top 10 Carrier Names based passengers preference
SELECT 
    CarrierName,
    COUNT(ServiceClassID) AS ServiceClassID
FROM 
    maindata_final
GROUP BY 
    CarrierName
ORDER BY 
    ServiceClassID DESC
LIMIT 10;

-- KPI 4
-- Top Routes (from-to City) based on Number of Flights
SELECT 
    AirlineID,
    COUNT(FromToCity) AS 'From-To-City'
FROM 
    maindata_final
GROUP BY 
    AirlineID
ORDER BY 
    'From-To-City' DESC
LIMIT 10;

-- KPI 5
-- Load factor on Weekend vs Weekdays.
SELECT 
    CASE
        WHEN DAYOFWEEK(CONCAT(Year, '-', LPAD(Month, 2, '00'), '-', LPAD(Day, 2, '00'))) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    CONCAT(ROUND((SUM(TransportedPassengers) / SUM(AvailableSeats)) * 100, 2), '%') AS LoadFactorPercentage
FROM 
    maindata_final
GROUP BY 
    DayType;

-- KPI 6
-- Filter to provide a search capability to find the flights, between Source Country, Source State, Source City to Destination Country , Destination State, Destination City 
SELECT
    AirlineID,
    CarrierName,
    OriginCountry,
    OriginState,
    OriginCity,
    DestinationCountry,
    DestinationState,
    DestinationCity
FROM
    maindata_final
WHERE
    AirlineID = 20398
    AND CarrierName = 'American Eagle Airlines Inc.'
    AND OriginCountry = 'United States'
    AND OriginState = 'Kansas'
    AND OriginCity = 'Wichita, KS'
    AND DestinationCountry = 'United States'
    AND DestinationState = 'Illinois'
    AND DestinationCity = 'Springfield, IL';

-- KPI 7
-- Number of flights based on Distance groups
SELECT
    d.DistanceInterval,
    SUM(m.AirlineID)
FROM
    maindata_final m
JOIN
    distancegroups d ON d.DistanceGroupID = m.DistanceGroupID
GROUP BY
    d.DistanceInterval;
