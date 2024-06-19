CREATE TABLE SourceTable (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Salary DECIMAL(10, 2)
);


INSERT INTO SourceTable (ID, Name, Age, Salary) VALUES
(1, 'Ankush', 30, 50000.00),
(2, 'Jay', 25, 60000.00),
(3, 'Vivek', 35, 70000.00);


CREATE TABLE DestinationTable (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Salary DECIMAL(10, 2)
);

-- Copy Data from Source Table to Destination Table
INSERT INTO DestinationTable (ID, Name, Age, Salary)
SELECT ID, Name, Age, Salary FROM SourceTable;

SELECT * FROM DestinationTable;
