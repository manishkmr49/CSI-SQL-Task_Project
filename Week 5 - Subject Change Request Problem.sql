CREATE TABLE dbo.SubjectAllotments (
    StudentId VARCHAR(50),
    SubjectId VARCHAR(50),
    Is_valid BIT
);


CREATE TABLE dbo.SubjectRequest (
    StudentId VARCHAR(50),
    SubjectId VARCHAR(50)
);


GO




INSERT INTO dbo.SubjectAllotments (StudentId, SubjectId, Is_valid)
VALUES 
    ('159103036', 'PO1491', 1), 
    ('159103036', 'PO1492', 0),
    ('159103036', 'PO1493', 0),
    ('159103036', 'PO1494', 0),
    ('159103036', 'PO1495', 0);


INSERT INTO dbo.SubjectRequest (StudentId, SubjectId)
VALUES 
    ('159103036', 'PO1496'); 


GO



CREATE PROCEDURE dbo.UpdateSubjectAllotments
AS
BEGIN

    BEGIN TRANSACTION;

   
    UPDATE sa
    SET sa.Is_valid = 0
    FROM dbo.SubjectAllotments sa
    JOIN dbo.SubjectRequest sr ON sa.StudentId = sr.StudentId
    WHERE sa.Is_valid = 1 AND sa.SubjectId <> sr.SubjectId;


    INSERT INTO dbo.SubjectAllotments (StudentId, SubjectId, Is_valid)
    SELECT sr.StudentId, sr.SubjectId, 1
    FROM dbo.SubjectRequest sr
    LEFT JOIN dbo.SubjectAllotments sa 
    ON sr.StudentId = sa.StudentId AND sa.Is_valid = 1
    WHERE sa.StudentId IS NULL OR sa.SubjectId <> sr.SubjectId;


    COMMIT TRANSACTION;
END;


GO




EXEC dbo.UpdateSubjectAllotments;


GO

SELECT * FROM dbo.SubjectAllotments;


SELECT * FROM dbo.SubjectRequest;


GO