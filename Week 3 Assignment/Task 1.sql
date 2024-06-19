
IF OBJECT_ID('Projects', 'U') IS NOT NULL
    DROP TABLE Projects;


CREATE TABLE Projects (
    Task_ID INT,
    Start_Date DATE,
    End_Date DATE
);


INSERT INTO Projects (Task_ID, Start_Date, End_Date) VALUES
(1, '2015-10-01', '2015-10-02'),
(2, '2015-10-02', '2015-10-03'),
(3, '2015-10-03', '2015-10-04'),
(4, '2015-10-13', '2015-10-14'),
(5, '2015-10-14', '2015-10-15'),
(6, '2015-10-28', '2015-10-29'),
(7, '2015-10-30', '2015-10-31');
WITH NumberedProjects AS (
    SELECT
        Task_ID,
        Start_Date,
        End_Date,
        ROW_NUMBER() OVER (ORDER BY Start_Date) AS rn
    FROM
        Projects
),
GroupedProjects AS (
    SELECT
        Task_ID,
        Start_Date,
        End_Date,
        rn,
        DATEADD(day, -ROW_NUMBER() OVER (ORDER BY Start_Date), Start_Date) AS GroupID
    FROM
        NumberedProjects
),
ProjectBoundaries AS (
    SELECT
        MIN(Start_Date) AS Project_Start_Date,
        MAX(End_Date) AS Project_End_Date,
        COUNT(*) AS Project_Length
    FROM
        GroupedProjects
    GROUP BY
        GroupID
)
SELECT
    Project_Start_Date,
    Project_End_Date,
    Project_Length
FROM
    ProjectBoundaries
ORDER BY
    Project_Length ASC,
    Project_Start_Date ASC;