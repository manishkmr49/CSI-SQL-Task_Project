-- Create Company table
IF OBJECT_ID('dbo.Company', 'U') IS NULL
BEGIN
    CREATE TABLE Company (
        company_code VARCHAR(10) PRIMARY KEY,
        founder VARCHAR(50)
    );
END

-- Create Lead_Manager table
IF OBJECT_ID('dbo.Lead_Manager', 'U') IS NULL
BEGIN
    CREATE TABLE Lead_Manager (
        lead_manager_code VARCHAR(10) PRIMARY KEY,
        company_code VARCHAR(10),
        FOREIGN KEY (company_code) REFERENCES Company(company_code)
    );
END

-- Create Senior_Manager table
IF OBJECT_ID('dbo.Senior_Manager', 'U') IS NULL
BEGIN
    CREATE TABLE Senior_Manager (
        senior_manager_code VARCHAR(10) PRIMARY KEY,
        lead_manager_code VARCHAR(10),
        company_code VARCHAR(10),
        FOREIGN KEY (lead_manager_code) REFERENCES Lead_Manager(lead_manager_code),
        FOREIGN KEY (company_code) REFERENCES Company(company_code)
    );
END

-- Create Manager table
IF OBJECT_ID('dbo.Manager', 'U') IS NULL
BEGIN
    CREATE TABLE Manager (
        manager_code VARCHAR(10) PRIMARY KEY,
        senior_manager_code VARCHAR(10),
        lead_manager_code VARCHAR(10),
        company_code VARCHAR(10),
        FOREIGN KEY (senior_manager_code) REFERENCES Senior_Manager(senior_manager_code),
        FOREIGN KEY (lead_manager_code) REFERENCES Lead_Manager(lead_manager_code),
        FOREIGN KEY (company_code) REFERENCES Company(company_code)
    );
END

-- Create Employee table
IF OBJECT_ID('dbo.Employee', 'U') IS NULL
BEGIN
    CREATE TABLE Employee (
        employee_code VARCHAR(10) PRIMARY KEY,
        manager_code VARCHAR(10),
        senior_manager_code VARCHAR(10),
        lead_manager_code VARCHAR(10),
        company_code VARCHAR(10),
        FOREIGN KEY (manager_code) REFERENCES Manager(manager_code),
        FOREIGN KEY (senior_manager_code) REFERENCES Senior_Manager(senior_manager_code),
        FOREIGN KEY (lead_manager_code) REFERENCES Lead_Manager(lead_manager_code),
        FOREIGN KEY (company_code) REFERENCES Company(company_code)
    );
END

-- Insert sample data into Company table
DELETE FROM Company;
INSERT INTO Company (company_code, founder) VALUES
('C1', 'Monika'),
('C2', 'Samantha');

-- Insert sample data into Lead_Manager table
DELETE FROM Lead_Manager;
INSERT INTO Lead_Manager (lead_manager_code, company_code) VALUES
('LM1', 'C1'),
('LM2', 'C2');

-- Insert sample data into Senior_Manager table
DELETE FROM Senior_Manager;
INSERT INTO Senior_Manager (senior_manager_code, lead_manager_code, company_code) VALUES
('SM1', 'LM1', 'C1'),
('SM2', 'LM1', 'C1'),
('SM3', 'LM2', 'C2');

-- Insert sample data into Manager table
DELETE FROM Manager;
INSERT INTO Manager (manager_code, senior_manager_code, lead_manager_code, company_code) VALUES
('M1', 'SM1', 'LM1', 'C1'),
('M2', 'SM3', 'LM2', 'C2'),
('M3', 'SM3', 'LM2', 'C2');

-- Insert sample data into Employee table
DELETE FROM Employee;
INSERT INTO Employee (employee_code, manager_code, senior_manager_code, lead_manager_code, company_code) VALUES
('E1', 'M1', 'SM1', 'LM1', 'C1'),
('E2', 'M1', 'SM1', 'LM1', 'C1'),
('E3', 'M2', 'SM3', 'LM2', 'C2'),
('E4', 'M3', 'SM3', 'LM2', 'C2');

-- Query to get the desired output
SELECT 
    C.company_code,
    C.founder,
    COALESCE(LM.lead_manager_count, 0) AS lead_manager_count,
    COALESCE(SM.senior_manager_count, 0) AS senior_manager_count,
    COALESCE(M.manager_count, 0) AS manager_count,
    COALESCE(E.employee_count, 0) AS employee_count
FROM 
    Company C
LEFT JOIN (
    SELECT 
        company_code, 
        COUNT(DISTINCT lead_manager_code) AS lead_manager_count
    FROM Lead_Manager
    GROUP BY company_code
) LM ON C.company_code = LM.company_code
LEFT JOIN (
    SELECT 
        company_code, 
        COUNT(DISTINCT senior_manager_code) AS senior_manager_count
    FROM Senior_Manager
    GROUP BY company_code
) SM ON C.company_code = SM.company_code
LEFT JOIN (
    SELECT 
        company_code, 
        COUNT(DISTINCT manager_code) AS manager_count
    FROM Manager
    GROUP BY company_code
) M ON C.company_code = M.company_code
LEFT JOIN (
    SELECT 
        company_code, 
        COUNT(DISTINCT employee_code) AS employee_count
    FROM Employee
    GROUP BY company_code
) E ON C.company_code = E.company_code
ORDER BY 
    C.company_code;
