-- ==========================================
-- CHECK SCRIPT: Functions
-- Database: COMPANY_Lab5
-- ==========================================

USE COMPANY_Lab5;

-- -----------------------------------------
-- Show all functions in the database
-- -----------------------------------------
SELECT ROUTINE_NAME AS Function_Name, ROUTINE_TYPE
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_SCHEMA = 'COMPANY_Lab5' AND ROUTINE_TYPE = 'FUNCTION'
ORDER BY ROUTINE_NAME;

-- -----------------------------------------
-- Test Function c: GetTotalProjectsForEmployee
-- -----------------------------------------
SELECT '=== Function c: GetTotalProjectsForEmployee ===' AS Test;

-- Test with various employee SSNs
SELECT '123456789' AS Employee_SSN, GetTotalProjectsForEmployee('123456789') AS Total_Projects;
SELECT '333445555' AS Employee_SSN, GetTotalProjectsForEmployee('333445555') AS Total_Projects;
SELECT '999887777' AS Employee_SSN, GetTotalProjectsForEmployee('999887777') AS Total_Projects;

-- Show all employees with their project counts
SELECT 
    e.Ssn,
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    GetTotalProjectsForEmployee(e.Ssn) AS Total_Projects
FROM EMPLOYEE e
ORDER BY Total_Projects DESC;
