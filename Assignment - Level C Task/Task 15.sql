CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10, 2)
);

--Insert some sample data

INSERT INTO employees (id, name, salary) VALUES (1, 'John Doe', 50000.00);
INSERT INTO employees (id, name, salary) VALUES (2, 'Jane Smith', 60000.00);
INSERT INTO employees (id, name, salary) VALUES (3, 'Alice Johnson', 70000.00);
INSERT INTO employees (id, name, salary) VALUES (4, 'Chris Lee', 80000.00);
INSERT INTO employees (id, name, salary) VALUES (5, 'Pat Taylor', 90000.00);
INSERT INTO employees (id, name, salary) VALUES (6, 'Sam Brown', 100000.00);
INSERT INTO employees (id, name, salary) VALUES (7, 'Nancy White', 110000.00);

--Retrieve the top 5 employees by salary
WITH RankedSalaries AS (
    SELECT 
        id,
        name,
        salary,
        ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn
    FROM employees
)
SELECT 
    id,
    name,
    salary
FROM RankedSalaries
WHERE rn <= 5;
