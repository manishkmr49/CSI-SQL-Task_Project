-- Drop the table if it already exists
DROP TABLE IF EXISTS OCCUPATIONS;

-- Create the OCCUPATIONS table
CREATE TABLE OCCUPATIONS (
    Name VARCHAR(100),
    Occupation VARCHAR(50)
);

-- Insert sample data
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES 
('Samantha', 'Doctor'),
('Julia', 'Actor'),
('Maria', 'Actor'),
('Meera', 'Singer'),
('Ashely', 'Professor'),
('Ketty', 'Professor'),
('Christeen', 'Professor'),
('Jane', 'Actor'),
('Jenny', 'Doctor'),
('Priya', 'Singer');
WITH SortedOccupations AS (
    SELECT 
        Name,
        Occupation,
        ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS RowNum
    FROM 
        OCCUPATIONS
),
PivotedOccupations AS (
    SELECT
        MAX(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
        MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
        MAX(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
        MAX(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor,
        RowNum
    FROM 
        SortedOccupations
    GROUP BY 
        RowNum
)
SELECT 
    Doctor, 
    Professor, 
    Singer, 
    Actor
FROM 
    PivotedOccupations
ORDER BY 
    RowNum;