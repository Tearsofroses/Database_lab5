-- ==========================================
-- CHECK SCRIPT: Stored Procedures
-- Database: COMPANY_Lab5
-- ==========================================

USE COMPANY_Lab5;

-- -----------------------------------------
-- Show all stored procedures in the database
-- -----------------------------------------
SELECT ROUTINE_NAME AS Procedure_Name, ROUTINE_TYPE
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_SCHEMA = 'COMPANY_Lab5' AND ROUTINE_TYPE = 'PROCEDURE'
ORDER BY ROUTINE_NAME;

-- -----------------------------------------
-- Test Procedure d: PrintEmployeeDetails
-- -----------------------------------------
SELECT '=== Procedure d: PrintEmployeeDetails ===' AS Test;
CALL PrintEmployeeDetails();

-- -----------------------------------------
-- Test Procedure f: PrintEmployeeSalaryLevel
-- -----------------------------------------
SELECT '=== Procedure f: PrintEmployeeSalaryLevel ===' AS Test;
CALL PrintEmployeeSalaryLevel();
