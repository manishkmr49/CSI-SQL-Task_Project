CREATE TABLE EmployeeCosts (
    EmployeeID INT,
    Month DATE,
    Cost DECIMAL(10, 2),
    BusinessUnit VARCHAR(50)
);
INSERT INTO EmployeeCosts (EmployeeID, Month, Cost, BusinessUnit)
VALUES
    (1, '2024-01-01', 1500.00, 'BU1'),
    (2, '2024-01-01', 2000.00, 'BU1'),
    (3, '2024-01-01', 1800.00, 'BU1'),
    (1, '2024-02-01', 1600.00, 'BU1'),
    (2, '2024-02-01', 2200.00, 'BU1'),
    (3, '2024-02-01', 1900.00, 'BU1');
SELECT 
    Month,
    SUM(Cost * NumberOfEmployees) / SUM(NumberOfEmployees) AS WeightedAverageCost
FROM (
    SELECT 
        Month,
        EmployeeID,
        Cost,
        COUNT(EmployeeID) AS NumberOfEmployees
    FROM EmployeeCosts
    WHERE BusinessUnit = 'BU1' 
    GROUP BY Month, EmployeeID, Cost
) AS MonthlyCosts
GROUP BY Month
ORDER BY Month;
