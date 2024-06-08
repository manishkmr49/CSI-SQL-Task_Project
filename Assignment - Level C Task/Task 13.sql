-- Drop the existing table if it exists
IF OBJECT_ID('BUFinanceData', 'U') IS NOT NULL
    DROP TABLE BUFinanceData;

-- Create the new table
CREATE TABLE BUFinanceData (
    BU NVARCHAR(50),
    MonthYear DATE,
    Cost DECIMAL(18, 2),
    Revenue DECIMAL(18, 2)
);

-- Insert sample data
INSERT INTO BUFinanceData (BU, MonthYear, Cost, Revenue) VALUES
('BU1', '2023-01-01', 50000, 100000),
('BU1', '2023-02-01', 60000, 110000),
('BU1', '2023-03-01', 55000, 105000),
('BU2', '2023-01-01', 30000, 80000),
('BU2', '2023-02-01', 35000, 85000),
('BU2', '2023-03-01', 32000, 90000);

SELECT
    BU,
    FORMAT(MonthYear, 'yyyy-MM') AS Month,
    Cost,
    Revenue,
    CASE
        WHEN Revenue = 0 THEN NULL
        ELSE Cost / Revenue
    END AS CostToRevenueRatio
FROM BUFinanceData
ORDER BY BU, MonthYear;