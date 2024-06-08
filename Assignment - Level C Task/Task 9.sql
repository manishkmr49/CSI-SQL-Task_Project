-- Create the BST table only if it does not exist
IF OBJECT_ID('dbo.BST', 'U') IS NULL
BEGIN
    CREATE TABLE BST (
        N INT PRIMARY KEY,
        P INT NULL
    );
END

-- Insert sample data into BST table
-- Clear existing data to avoid duplicates
DELETE FROM BST;

INSERT INTO BST (N, P) VALUES
(1, 2),
(2, 5),
(3, 2),
(5, NULL),
(6, 8),
(8, 5),
(9, 8);

-- Query to determine the node type
WITH NodeType AS (
    SELECT
        N,
        P,
        CASE
            WHEN P IS NULL THEN 'Root'
            WHEN N IN (SELECT DISTINCT P FROM BST) THEN 'Inner'
            ELSE 'Leaf'
        END AS node_type
    FROM BST
)
SELECT
    N,
    node_type
FROM NodeType
ORDER BY N;
