
CREATE TABLE NewTable (
    column1 INT,
    column2 INT
);

--Insert sample data
INSERT INTO NewTable (column1, column2) VALUES (10, 20);
INSERT INTO NewTable (column1, column2) VALUES (30, 40);

--Display original data
SELECT * FROM NewTable;

--Update to swap values without using a third variable
UPDATE NewTable
SET column1 = column1 + column2,
    column2 = column1 - column2,
    column1 = column1 - column2;

--Display updated data (swapped values)
SELECT * FROM NewTable;
