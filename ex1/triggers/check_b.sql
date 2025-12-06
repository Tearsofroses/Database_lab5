-- ==========================================
-- CHECK SCRIPT: Task b - Num_of_Emp Derived Attribute
-- Database: COMPANY_Lab5
-- ==========================================

USE COMPANY_Lab5;

-- -----------------------------------------
-- Initial Check: Verify Num_of_Emp column exists and is initialized
-- -----------------------------------------
SELECT 
    Dnumber, 
    Dname, 
    Num_of_Emp,
    (SELECT COUNT(*) FROM EMPLOYEE WHERE Dno = DEPARTMENT.Dnumber) AS Actual_Count
FROM DEPARTMENT
ORDER BY Dnumber;

-- -----------------------------------------
-- Test 1: INSERT new employee
-- -----------------------------------------
-- Before state
SELECT Dnumber, Dname, Num_of_Emp FROM DEPARTMENT WHERE Dnumber = 5;

-- Insert new employee in department 5
INSERT INTO EMPLOYEE VALUES 
('Test', 'X', 'Insert', '111111120', '1990-01-01', '123 Test St', 'M', 30000, '333445555', 5);

-- After state - Num_of_Emp should increase by 1
SELECT Dnumber, Dname, Num_of_Emp FROM DEPARTMENT WHERE Dnumber = 5;

-- Cleanup
DELETE FROM EMPLOYEE WHERE Ssn = '111111120';

-- After cleanup - Num_of_Emp should return to original
SELECT Dnumber, Dname, Num_of_Emp FROM DEPARTMENT WHERE Dnumber = 5;

-- -----------------------------------------
-- Test 2: DELETE employee
-- -----------------------------------------
-- Insert test employee
INSERT INTO EMPLOYEE VALUES 
('Test', 'Y', 'Delete', '111111121', '1990-01-01', '123 Test St', 'F', 30000, '333445555', 4);

-- Before delete
SELECT Dnumber, Dname, Num_of_Emp FROM DEPARTMENT WHERE Dnumber = 4;

-- Delete employee
DELETE FROM EMPLOYEE WHERE Ssn = '111111121';

-- After delete - Num_of_Emp should decrease by 1
SELECT Dnumber, Dname, Num_of_Emp FROM DEPARTMENT WHERE Dnumber = 4;

-- -----------------------------------------
-- Test 3: UPDATE employee department
-- -----------------------------------------
-- Insert test employee in department 4
INSERT INTO EMPLOYEE VALUES 
('Test', 'Z', 'Update', '111111122', '1990-01-01', '123 Test St', 'M', 30000, '987654321', 4);

-- Before update
SELECT Dnumber, Dname, Num_of_Emp FROM DEPARTMENT WHERE Dnumber IN (4, 5) ORDER BY Dnumber;

-- Move employee from department 4 to department 5
UPDATE EMPLOYEE SET Dno = 5 WHERE Ssn = '111111122';

-- After update - Dept 4 should decrease, Dept 5 should increase
SELECT Dnumber, Dname, Num_of_Emp FROM DEPARTMENT WHERE Dnumber IN (4, 5) ORDER BY Dnumber;

-- Cleanup
DELETE FROM EMPLOYEE WHERE Ssn = '111111122';

-- Final verification
SELECT Dnumber, Dname, Num_of_Emp FROM DEPARTMENT WHERE Dnumber IN (4, 5) ORDER BY Dnumber;

-- -----------------------------------------
-- Final Comprehensive Check
-- -----------------------------------------
SELECT 
    Dnumber, 
    Dname, 
    Num_of_Emp,
    (SELECT COUNT(*) FROM EMPLOYEE WHERE Dno = DEPARTMENT.Dnumber) AS Actual_Count,
    CASE 
        WHEN Num_of_Emp = (SELECT COUNT(*) FROM EMPLOYEE WHERE Dno = DEPARTMENT.Dnumber) 
        THEN 'PASS' 
        ELSE 'FAIL' 
    END AS Status
FROM DEPARTMENT
ORDER BY Dnumber;
