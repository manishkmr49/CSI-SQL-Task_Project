-- Drop the existing table if it exists
IF OBJECT_ID('SimulationData', 'U') IS NOT NULL
    DROP TABLE SimulationData;

-- Create the new table
CREATE TABLE SimulationData (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    JobFamily NVARCHAR(50),
    Region NVARCHAR(50),
    Cost DECIMAL(18, 2)
);

-- Insert sample data
INSERT INTO SimulationData (JobFamily, Region, Cost) VALUES
('Engineering', 'India', 100000),
('Engineering', 'International', 200000),
('Marketing', 'India', 80000),
('Marketing', 'International', 120000),
('Sales', 'India', 50000),
('Sales', 'International', 150000),
('HR', 'India', 60000),
('HR', 'International', 50000);

-- CTE to calculate total costs for each job family and region
WITH CostByRegion AS (
    SELECT
        JobFamily,
        Region,
        SUM(Cost) AS TotalCost
    FROM SimulationData
    GROUP BY JobFamily, Region
),

-- CTE to calculate total costs for India and International
TotalCosts AS (
    SELECT
        Region,
        SUM(TotalCost) AS GrandTotalCost
    FROM CostByRegion
    GROUP BY Region
),

-- CTE to calculate percentages
CostPercentages AS (
    SELECT
        c.JobFamily,
        c.Region,
        c.TotalCost,
        t.GrandTotalCost,
        (c.TotalCost * 100.0 / t.GrandTotalCost) AS CostPercentage
    FROM CostByRegion c
    INNER JOIN TotalCosts t ON c.Region = t.Region
)

-- Final query to display the results
SELECT
    JobFamily,
    SUM(CASE WHEN Region = 'India' THEN CostPercentage ELSE 0 END) AS Percentage_India,
    SUM(CASE WHEN Region = 'International' THEN CostPercentage ELSE 0 END) AS Percentage_International
FROM CostPercentages
GROUP BY JobFamily
ORDER BY JobFamily;
