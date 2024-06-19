-- Create tables
CREATE TABLE Hackers (
    hacker_id INTEGER PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE Submissions (
    submission_date DATE,
    submission_id INTEGER PRIMARY KEY,
    hacker_id INTEGER,
    score INTEGER,
    FOREIGN KEY (hacker_id) REFERENCES Hackers(hacker_id)
);

-- Insert sample data
INSERT INTO Hackers (hacker_id, name) VALUES
(15758, 'Rose'),
(20703, 'Angela'),
(36396, 'Frank'),
(38289, 'Patrick'),
(44065, 'Lisa'),
(53473, 'Kimberly'),
(62529, 'Bonnie'),
(79722, 'Michael');

INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES
('2016-03-01', 8494, 20703, 0),
('2016-03-01', 22403, 53473, 15),
('2016-03-01', 23965, 79722, 60),
('2016-03-01', 30173, 36396, 70),
('2016-03-02', 34928, 20703, 0),
('2016-03-02', 38740, 15758, 60),
('2016-03-02', 42769, 79722, 25),
('2016-03-02', 44364, 79722, 60),
('2016-03-03', 45440, 20703, 0),
('2016-03-03', 49050, 36396, 70),
('2016-03-03', 50273, 79722, 5),
('2016-03-04', 50344, 20703, 0),
('2016-03-04', 51360, 44065, 90),
('2016-03-04', 54404, 53473, 65),
('2016-03-04', 61533, 79722, 45),
('2016-03-05', 72852, 20703, 0),
('2016-03-05', 74546, 38289, 0),
('2016-03-05', 76487, 62529, 0),
('2016-03-05', 82439, 36396, 10),
('2016-03-05', 90006, 36396, 40),
('2016-03-06', 90404, 20703, 0);
-- Query to generate the required report
WITH daily_submissions AS (
    SELECT
        submission_date,
        hacker_id,
        COUNT(submission_id) AS submissions_count
    FROM
        Submissions
    WHERE
        submission_date BETWEEN '2016-03-01' AND '2016-03-15'
    GROUP BY
        submission_date, hacker_id
),
unique_hackers AS (
    SELECT
        submission_date,
        COUNT(DISTINCT hacker_id) AS unique_hackers_count
    FROM
        daily_submissions
    GROUP BY
        submission_date
),
max_submissions AS (
    SELECT
        ds.submission_date,
        ds.hacker_id,
        ds.submissions_count,
        h.name
    FROM
        daily_submissions ds
    JOIN
        Hackers h ON ds.hacker_id = h.hacker_id
    WHERE
        ds.submissions_count = (
            SELECT
                MAX(submissions_count)
            FROM
                daily_submissions
            WHERE
                submission_date = ds.submission_date
        )
),
min_hacker_ids AS (
    SELECT
        submission_date,
        MIN(hacker_id) AS hacker_id
    FROM
        max_submissions
    GROUP BY
        submission_date
)
SELECT
    uh.submission_date,
    uh.unique_hackers_count,
    mh.hacker_id,
    h.name
FROM
    unique_hackers uh
JOIN
    min_hacker_ids mh ON uh.submission_date = mh.submission_date
JOIN
    Hackers h ON mh.hacker_id = h.hacker_id
ORDER BY
    uh.submission_date;
