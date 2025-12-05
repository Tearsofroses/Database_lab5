-- ==========================================
-- LAB 5: VIEW - Task a
-- Database: COMPANY_Lab5
-- ==========================================
-- a. A view that has the department name, manager name, and manager salary for every department.
-- ==========================================

USE COMPANY_Lab5;

DROP VIEW IF EXISTS DepartmentManagerInfo;
CREATE VIEW DepartmentManagerInfo AS
SELECT 
    d.Dname AS Department_Name,
    CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS Manager_Name,
    e.Salary AS Manager_Salary
FROM DEPARTMENT d
JOIN EMPLOYEE e ON d.Mgr_ssn = e.Ssn;
