-- ==========================================
-- CHECK SCRIPT: Views
-- Database: COMPANY_Lab5
-- ==========================================

USE COMPANY_Lab5;

-- -----------------------------------------
-- Show all views in the database
-- -----------------------------------------
SELECT TABLE_NAME AS View_Name
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'COMPANY_Lab5'
ORDER BY TABLE_NAME;

-- -----------------------------------------
-- Test View a: DepartmentManagerInfo
-- -----------------------------------------
SELECT '=== View a: DepartmentManagerInfo ===' AS Test;
SELECT * FROM DepartmentManagerInfo;

-- -----------------------------------------
-- Test View b: ResearchEmployeeSupervisor
-- -----------------------------------------
SELECT '=== View b: ResearchEmployeeSupervisor ===' AS Test;
SELECT * FROM ResearchEmployeeSupervisor;

-- -----------------------------------------
-- Test View c: ProjectInfo
-- -----------------------------------------
SELECT '=== View c: ProjectInfo ===' AS Test;
SELECT * FROM ProjectInfo;

-- -----------------------------------------
-- Test View d: ProjectInfoMoreThanTwo
-- -----------------------------------------
SELECT '=== View d: ProjectInfoMoreThanTwo ===' AS Test;
SELECT * FROM ProjectInfoMoreThanTwo;

-- -----------------------------------------
-- Test View e: EmployeesWithManyDependents
-- -----------------------------------------
SELECT '=== View e: EmployeesWithManyDependents ===' AS Test;
SELECT * FROM EmployeesWithManyDependents;

-- -----------------------------------------
-- Test View f: JulyBirthdayEmployees
-- -----------------------------------------
SELECT '=== View f: JulyBirthdayEmployees ===' AS Test;
SELECT * FROM JulyBirthdayEmployees;

-- -----------------------------------------
-- Test View g: YoungDependents
-- -----------------------------------------
SELECT '=== View g: YoungDependents ===' AS Test;
SELECT * FROM YoungDependents;
