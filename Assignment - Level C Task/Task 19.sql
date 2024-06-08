CREATE TABLE Employees (
    EmployeeID INT,
    Salary DECIMAL(10, 2)  -- Assuming salary is in decimal format
);
INSERT INTO Employees (EmployeeID, Salary) VALUES
(1, 5000.00),
(2, 6200.00),
(3, 7000.00),
(4, 4800.00),
(5, 5400.00),
(6, 6300.00),
(7, 5200.00),
(8, 0.00),  -- Sample salary with a zero
(9, 6500.00),
(10, 6100.00);


SELECT 
    CEILING(AVG(Salary)) - CEILING(AVG(CASE WHEN Salary <> 0 THEN Salary ELSE NULL END)) AS ErrorAmount
FROM 
    Employees;
