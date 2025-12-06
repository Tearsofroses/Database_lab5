-- ==========================================
-- CHECK SCRIPT: Triggers
-- Database: COMPANY_Lab5
-- ==========================================

USE COMPANY_Lab5;

-- -----------------------------------------
-- Show all triggers in the database
-- -----------------------------------------
SELECT TRIGGER_NAME, EVENT_MANIPULATION, EVENT_OBJECT_TABLE, ACTION_TIMING
FROM INFORMATION_SCHEMA.TRIGGERS
WHERE TRIGGER_SCHEMA = 'COMPANY_Lab5'
ORDER BY EVENT_OBJECT_TABLE, TRIGGER_NAME;

-- -----------------------------------------
-- Test Data Setup for Triggers
-- -----------------------------------------

-- Ensure we have test departments
INSERT IGNORE INTO DEPARTMENT (Dname, Dnumber, Mgr_ssn, Mgr_start_date, Num_of_Emp)
VALUES ('Test Department', 99, NULL, '2020-01-01', 0);

-- -----------------------------------------
-- Test Constraint a.1: Supervisor must be older
-- -----------------------------------------
-- VALID INSERT: Employee born 1990, Supervisor (333445555) born 1955
INSERT INTO EMPLOYEE VALUES 
('Test', 'A', 'Valid', '111111110', '1990-01-01', '123 Test St', 'M', 25000, '333445555', 5);
-- Result: Success

-- INVALID INSERT: Employee born 1940, Supervisor born 1955 (supervisor younger)
INSERT INTO EMPLOYEE VALUES 
('Test', 'B', 'Invalid', '111111111', '1940-01-01', '123 Test St', 'M', 25000, '333445555', 5);
-- Result: Error - Supervisor must be older than the employee.

-- Cleanup
DELETE FROM EMPLOYEE WHERE Ssn IN ('111111110', '111111111');

-- -----------------------------------------
-- Test Constraint a.2: Salary cannot exceed supervisor's salary
-- -----------------------------------------
-- VALID INSERT: Employee salary 35000, Supervisor salary 40000
INSERT INTO EMPLOYEE VALUES 
('Test', 'C', 'Valid', '111111112', '1990-01-01', '123 Test St', 'M', 35000, '333445555', 5);
-- Result: Success

-- INVALID INSERT: Employee salary 50000 > Supervisor salary 40000
INSERT INTO EMPLOYEE VALUES 
('Test', 'D', 'Invalid', '111111113', '1990-01-01', '123 Test St', 'M', 50000, '333445555', 5);
-- Result: Error - Employee salary cannot be greater than supervisor salary.

-- Cleanup
DELETE FROM EMPLOYEE WHERE Ssn IN ('111111112', '111111113');

-- -----------------------------------------
-- Test Constraint a.3: Salary can only increase
-- -----------------------------------------
-- VALID UPDATE: Increase salary from 30000 to 32000
UPDATE EMPLOYEE SET Salary = 32000 WHERE Ssn = '123456789';
-- Result: Success

-- INVALID UPDATE: Decrease salary from 32000 to 28000
UPDATE EMPLOYEE SET Salary = 28000 WHERE Ssn = '123456789';
-- Result: Error - Employee salary can only increase, not decrease.

-- Restore original salary
UPDATE EMPLOYEE SET Salary = 30000 WHERE Ssn = '123456789';

-- -----------------------------------------
-- Test Constraint a.4: Max 20% salary increase
-- -----------------------------------------
-- VALID UPDATE: Increase salary by 15% (30000 -> 34500)
UPDATE EMPLOYEE SET Salary = 34500 WHERE Ssn = '123456789';
-- Result: Success

-- INVALID UPDATE: Increase salary by 50% (30000 -> 45000)
UPDATE EMPLOYEE SET Salary = 45000 WHERE Ssn = '123456789';
-- Result: Error - Salary increase cannot exceed 20% of current salary.

-- Restore original salary
UPDATE EMPLOYEE SET Salary = 30000 WHERE Ssn = '123456789';

-- -----------------------------------------
-- Test Constraint a.5: Max 4 projects per employee
-- -----------------------------------------
-- Check current projects for employee '123456789'
SELECT Essn, Pno FROM WORKS_ON WHERE Essn = '123456789';

-- INVALID INSERT: Adding 5th project (employee already has 4 projects)
-- Note: Use existing project number (10, 20, 30 exist)
INSERT INTO WORKS_ON VALUES ('123456789', 10, 10);
-- Result: Error - An employee can work on at most 4 projects.

-- VALID INSERT: Employee with less than 4 projects (666884444 has fewer projects)
-- Check available projects for employee in dept 5
SELECT Pnumber FROM PROJECT WHERE Pnumber NOT IN (SELECT Pno FROM WORKS_ON WHERE Essn = '666884444') AND Dnum = 5;
INSERT INTO WORKS_ON VALUES ('666884444', 1, 10);
-- Result: Success

-- Cleanup
DELETE FROM WORKS_ON WHERE Essn = '666884444' AND Pno = 1;

-- -----------------------------------------
-- Test Constraint a.6: Max 56 hours/week
-- -----------------------------------------
-- Check current hours for employee '123456789'
SELECT Essn, SUM(Hours) AS Total_Hours FROM WORKS_ON WHERE Essn = '123456789';

-- VALID INSERT: Adding hours that don't exceed 56 total
-- Note: Use existing project number that employee isn't working on yet (project 3, dept 5)
INSERT INTO WORKS_ON VALUES ('123456789', 3, 5);
-- Result: Success

-- INVALID INSERT: Adding hours that would exceed 56
-- First check if this would exceed: existing hours + new hours > 56
INSERT INTO WORKS_ON VALUES ('666884444', 2, 50);
-- Result: Error - Total hours per week cannot exceed 56.

-- Cleanup
DELETE FROM WORKS_ON WHERE (Essn = '123456789' AND Pno = 3) OR (Essn = '666884444' AND Pno = 2);

-- -----------------------------------------
-- Test Constraint a.7: Project location must match department location
-- -----------------------------------------
-- Check Dept 5 locations
SELECT Dnumber, Dlocation FROM DEPT_LOCATIONS WHERE Dnumber = 5;

-- VALID INSERT: Project in valid department location
INSERT INTO PROJECT VALUES ('TestProject', 99, 'Houston', 5);
-- Result: Success

-- INVALID INSERT: Project in location not belonging to department
INSERT INTO PROJECT VALUES ('BadProject', 100, 'New York', 5);
-- Result: Error - Project location must be one of its department locations.

-- Cleanup
DELETE FROM PROJECT WHERE Pnumber IN (99, 100);

-- -----------------------------------------
-- Test Constraint a.8: Manager salary must be highest
-- -----------------------------------------
-- Check Dept 5 manager and salaries
SELECT Mgr_ssn, (SELECT Salary FROM EMPLOYEE WHERE Ssn = Mgr_ssn) AS Manager_Salary
FROM DEPARTMENT WHERE Dnumber = 5;

-- VALID INSERT: Employee salary < Manager salary
INSERT INTO EMPLOYEE VALUES 
('Test', 'E', 'Valid', '111111114', '1990-01-01', '123 St', 'M', 35000, '333445555', 5);
-- Result: Success

-- INVALID INSERT: Employee salary >= Manager salary
INSERT INTO EMPLOYEE VALUES 
('Test', 'F', 'Invalid', '111111115', '1990-01-01', '123 St', 'M', 50000, '333445555', 5);
-- Result: Error - Employee salary cannot be equal or greater than manager salary.

-- Cleanup
DELETE FROM EMPLOYEE WHERE Ssn IN ('111111114', '111111115');

-- -----------------------------------------
-- Test Constraint a.9: Only managers can work less than 5 hours
-- -----------------------------------------
-- Check which projects each person works on
SELECT Essn, COUNT(*) AS Project_Count FROM WORKS_ON GROUP BY Essn;

-- VALID INSERT: Manager (888665555, Dept 1 manager) working 3 hours on project 20 (dept 1)
-- Manager 888665555 currently works only on project 20 with NULL hours
UPDATE WORKS_ON SET Hours = 3 WHERE Essn = '888665555' AND Pno = 20;
-- Result: Success (managers can work < 5 hours)

-- INVALID INSERT: Non-manager (453453453) working 3 hours on project 3 from dept 5
INSERT INTO WORKS_ON VALUES ('453453453', 3, 3);
-- Result: Error - Only department managers can work less than 5 hours.

-- VALID INSERT: Non-manager working 10 hours
INSERT INTO WORKS_ON VALUES ('453453453', 3, 10);
-- Result: Success

-- Cleanup
UPDATE WORKS_ON SET Hours = NULL WHERE Essn = '888665555' AND Pno = 20;
DELETE FROM WORKS_ON WHERE Essn = '453453453' AND Pno = 3;

-- -----------------------------------------
-- Test Task b: Num_of_Emp derived attribute
-- -----------------------------------------
-- Check current counts
SELECT Dnumber, Dname, Num_of_Emp,
    (SELECT COUNT(*) FROM EMPLOYEE WHERE Dno = DEPARTMENT.Dnumber) AS Actual_Count
FROM DEPARTMENT;

-- -----------------------------------------
-- Test Task e: Salary log
-- -----------------------------------------
-- View the salary log
SELECT * FROM SALARY_LOG ORDER BY Change_Date DESC;

-- -----------------------------------------
-- Cleanup test data
-- -----------------------------------------
-- DELETE FROM DEPARTMENT WHERE Dnumber = 99;
