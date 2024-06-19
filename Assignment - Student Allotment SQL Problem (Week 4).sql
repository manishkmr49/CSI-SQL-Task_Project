-- Create StudentDetails table
CREATE TABLE StudentDetails (
    StudentId INT PRIMARY KEY,
    StudentName NVARCHAR(100),
    GPA FLOAT,
    Branch NVARCHAR(50),
    Section NVARCHAR(10)
);
GO

-- Create SubjectDetails table
CREATE TABLE SubjectDetails (
    SubjectId NVARCHAR(10) PRIMARY KEY,
    SubjectName NVARCHAR(100),
    MaxSeats INT,
    RemainingSeats INT
);
GO

-- Create StudentPreference table
CREATE TABLE StudentPreference (
    StudentId INT,
    SubjectId NVARCHAR(10),
    Preference INT,
    PRIMARY KEY (StudentId, Preference),
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId),
    FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId)
);
GO

-- Create Allotments table
CREATE TABLE Allotments (
    SubjectId NVARCHAR(10),
    StudentId INT,
    PRIMARY KEY (SubjectId, StudentId),
    FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId),
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId)
);
GO

-- Create UnallottedStudents table
CREATE TABLE UnallottedStudents (
    StudentId INT PRIMARY KEY,
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId)
);
GO
-- Insert data into StudentDetails
INSERT INTO StudentDetails (StudentId, StudentName, GPA, Branch, Section)
VALUES
(159103036, 'Mohit Agarwal', 8.9, 'CCE', 'A'),
(159103037, 'Rohit Agarwal', 5.2, 'CCE', 'A'),
(159103038, 'Shohit Garg', 7.1, 'CCE', 'B'),
(159103039, 'Mrinal Malhotra', 7.9, 'CCE', 'A'),
(159103040, 'Mehreet Singh', 5.6, 'CCE', 'A'),
(159103041, 'Arjun Tehlan', 9.2, 'CCE', 'B');
GO

-- Insert data into SubjectDetails
INSERT INTO SubjectDetails (SubjectId, SubjectName, MaxSeats, RemainingSeats)
VALUES
('PO1491', 'Basics of Political Science', 60, 2),
('PO1492', 'Basics of Accounting', 120, 119),
('PO1493', 'Basics of Financial Markets', 90, 90),
('PO1494', 'Eco philosophy', 60, 50),
('PO1495', 'Automotive Trends', 60, 60);
GO

-- Insert data into StudentPreference
INSERT INTO StudentPreference (StudentId, SubjectId, Preference)
VALUES
(159103036, 'PO1491', 1),
(159103036, 'PO1492', 2),
(159103036, 'PO1493', 3),
(159103036, 'PO1494', 4),
(159103036, 'PO1495', 5),
(159103037, 'PO1491', 1),
(159103037, 'PO1492', 2),
(159103037, 'PO1493', 3),
(159103037, 'PO1494', 4),
(159103037, 'PO1495', 5),
(159103038, 'PO1491', 1),
(159103038, 'PO1492', 2),
(159103038, 'PO1493', 3),
(159103038, 'PO1494', 4),
(159103038, 'PO1495', 5),
(159103039, 'PO1491', 1),
(159103039, 'PO1492', 2),
(159103039, 'PO1493', 3),
(159103039, 'PO1494', 4),
(159103039, 'PO1495', 5),
(159103040, 'PO1491', 1),
(159103040, 'PO1492', 2),
(159103040, 'PO1493', 3),
(159103040, 'PO1494', 4),
(159103040, 'PO1495', 5),
(159103041, 'PO1491', 1),
(159103041, 'PO1492', 2),
(159103041, 'PO1493', 3),
(159103041, 'PO1494', 4),
(159103041, 'PO1495', 5);
GO
-- Create the AllocateSubjects stored procedure
CREATE PROCEDURE AllocateSubjects
AS
BEGIN
    SET NOCOUNT ON;

    -- Variables
    DECLARE @studentId INT;
    DECLARE @subjectId NVARCHAR(10);
    DECLARE @current_preference INT;
    DECLARE @allotted BIT;

    -- Cursor to iterate through each student ordered by GPA descending
    DECLARE student_cursor CURSOR FOR
        SELECT StudentId
        FROM StudentDetails
        ORDER BY GPA DESC;

    OPEN student_cursor;
    
    FETCH NEXT FROM student_cursor INTO @studentId;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @current_preference = 1;
        SET @allotted = 0;

        WHILE @current_preference <= 5 AND @allotted = 0
        BEGIN
            -- Fetch the subject corresponding to current preference
            SELECT @subjectId = sp.SubjectId
            FROM StudentPreference sp
            WHERE sp.StudentId = @studentId AND sp.Preference = @current_preference;

            -- Check if the subject is available and has remaining seats
            IF EXISTS (
                SELECT 1
                FROM SubjectDetails
                WHERE SubjectId = @subjectId AND RemainingSeats > 0
            )
            BEGIN
                -- Allocate subject to student
                INSERT INTO Allotments (SubjectId, StudentId)
                VALUES (@subjectId, @studentId);

                -- Update remaining seats for the subject
                UPDATE SubjectDetails
                SET RemainingSeats = RemainingSeats - 1
                WHERE SubjectId = @subjectId;

                SET @allotted = 1; -- Allocation succeeded, exit the preference loop
            END

            SET @current_preference = @current_preference + 1;
        END

        -- If @allotted is still 0, the student could not be allocated any preference
        IF @allotted = 0
        BEGIN
            -- Mark student as unallotted
            INSERT INTO UnallottedStudents (StudentId)
            VALUES (@studentId);
        END

        FETCH NEXT FROM student_cursor INTO @studentId;
    END

    CLOSE student_cursor;
    DEALLOCATE student_cursor;
END;
GO
-- Execute the AllocateSubjects stored procedure
EXEC AllocateSubjects;
GO

-- Display the results of the allocations
SELECT * FROM Allotments;
GO

-- Display unallotted students
SELECT * FROM UnallottedStudents;
GO
