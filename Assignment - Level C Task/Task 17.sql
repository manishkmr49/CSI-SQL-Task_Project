USE AdventureWorks2019;

CREATE LOGIN Celebal WITH PASSWORD = 'Kumar@123';

CREATE USER Manish FOR LOGIN Celebal;

-- Provide permissions of DB_OWNER to the user
ALTER ROLE db_owner ADD MEMBER Manish;