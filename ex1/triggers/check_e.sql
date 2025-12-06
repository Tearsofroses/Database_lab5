-- ==========================================
-- CHECK SCRIPT: Task e - Salary Log
-- Database: COMPANY_Lab5
-- ==========================================

USE COMPANY_Lab5;

-- -----------------------------------------
-- View current SALARY_LOG table
-- -----------------------------------------
SELECT * FROM SALARY_LOG ORDER BY Log_ID DESC LIMIT 10;

-- -----------------------------------------
-- Test 1: INSERT new employee with high salary (> 50000)
-- -----------------------------------------
-- Insert employee with salary > 50000
INSERT INTO EMPLOYEE VALUES 
('High', 'H', 'Earner', '888888888', '1980-01-01', '123 St', 'M', 55000, NULL, 1);

-- Check the log - should have entry for INSERT
SELECT * FROM SALARY_LOG WHERE ESSN = '888888888';

-- Expected: Log entry with Old_Salary = NULL, New_Salary = 55000

-- -----------------------------------------
-- Test 2: UPDATE employee salary to > 50000
-- -----------------------------------------
-- Update salary from 55000 to 60000
UPDATE EMPLOYEE SET Salary = 60000 WHERE Ssn = '888888888';

-- Check the log - should have entry for UPDATE
SELECT * FROM SALARY_LOG WHERE ESSN = '888888888' ORDER BY Log_ID DESC;

-- Expected: Log entry with Old_Salary = 55000, New_Salary = 60000

-- -----------------------------------------
-- Test 3: INSERT employee with low salary (< 50000)
-- -----------------------------------------
-- Insert employee with salary < 50000
INSERT INTO EMPLOYEE VALUES 
('Low', 'L', 'Earner', '777777777', '1985-01-01', '456 St', 'F', 30000, NULL, 1);

-- Check the log - should have entry for INSERT
SELECT * FROM SALARY_LOG WHERE ESSN = '777777777';

-- Expected: Log entry with Old_Salary = NULL, New_Salary = 30000

-- -----------------------------------------
-- Test 4: UPDATE employee salary from low to high (crossing 50000 threshold)
-- -----------------------------------------
-- Update salary from 30000 to 52000
UPDATE EMPLOYEE SET Salary = 52000 WHERE Ssn = '777777777';

-- Check the log - should have entry for UPDATE
SELECT * FROM SALARY_LOG WHERE ESSN = '777777777' ORDER BY Log_ID DESC;

-- Expected: Log entry with Old_Salary = 30000, New_Salary = 52000

-- -----------------------------------------
-- Test 5: UPDATE employee with low salary to another low salary
-- -----------------------------------------
-- Update salary from 52000 to 48000 (decrease, but will fail due to constraint)
-- Note: This will fail due to trg_salary_only_increase, so skip this test

-- -----------------------------------------
-- View all log entries
-- -----------------------------------------
SELECT 
    Log_ID,
    User_Name,
    DATE_FORMAT(Change_Date, '%Y-%m-%d %H:%i:%s') AS Change_Date,
    ESSN,
    Old_Salary,
    New_Salary,
    CASE 
        WHEN Old_Salary IS NULL THEN 'INSERT'
        ELSE 'UPDATE'
    END AS Action_Type
FROM SALARY_LOG
ORDER BY Log_ID DESC;

-- -----------------------------------------
-- Cleanup
-- -----------------------------------------
DELETE FROM EMPLOYEE WHERE Ssn IN ('888888888', '777777777');

-- View final log state
SELECT * FROM SALARY_LOG ORDER BY Log_ID DESC LIMIT 10;
