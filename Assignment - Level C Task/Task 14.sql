
CREATE TABLE EmployeeData (
    EmployeeID INT,
    SubBand NVARCHAR(50)
);


INSERT INTO EmployeeData (EmployeeID, SubBand) VALUES
(1, 'A1'),
(2, 'A1'),
(3, 'A2'),
(4, 'A2'),
(5, 'A2'),
(6, 'B1'),
(7, 'B1'),
(8, 'B1'),
(9, 'B2'),
(10, 'B2');


DECLARE @TotalHeadcount INT;
SELECT @TotalHeadcount = COUNT(*) FROM EmployeeData;


SELECT
    SubBand,
    COUNT(*) AS Headcount,
    CAST(COUNT(*) AS FLOAT) / @TotalHeadcount * 100 AS Percentage
FROM EmployeeData
GROUP BY SubBand
ORDER BY SubBand;
