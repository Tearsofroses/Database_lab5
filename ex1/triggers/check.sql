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
-- This should FAIL (supervisor younger than employee):
-- INSERT INTO EMPLOYEE VALUES ('Test', 'T', 'Emp1', '111111111', '1990-01-01', '123 Test', 'M', 25000, '123456789', 5);

-- -----------------------------------------
-- Test Constraint a.3: Salary can only increase
-- -----------------------------------------
-- This should FAIL:
-- UPDATE EMPLOYEE SET Salary = Salary - 1000 WHERE Ssn = '123456789';

-- -----------------------------------------
-- Test Constraint a.4: Max 20% salary increase
-- -----------------------------------------
-- This should FAIL (more than 20% increase):
-- UPDATE EMPLOYEE SET Salary = Salary * 1.5 WHERE Ssn = '123456789';

-- -----------------------------------------
-- Test Constraint a.5: Max 4 projects per employee
-- -----------------------------------------
-- Add more than 4 projects to test (should fail on 5th):

-- -----------------------------------------
-- Test Constraint a.6: Max 56 hours/week
-- -----------------------------------------
-- Add hours exceeding 56 to test (should fail):

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
