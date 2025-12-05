-- ==========================================
-- LAB 5: VIEW - Task b
-- Database: COMPANY_Lab5
-- ==========================================
-- b. A view that has the employee name, supervisor name, and employee salary for each employee
--    who works in the 'Research' department.
-- ==========================================

USE COMPANY_Lab5;

DROP VIEW IF EXISTS ResearchEmployeeSupervisor;
CREATE VIEW ResearchEmployeeSupervisor AS
SELECT 
    CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS Employee_Name,
    CONCAT(s.Fname, ' ', s.Minit, ' ', s.Lname) AS Supervisor_Name,
    e.Salary AS Employee_Salary
FROM EMPLOYEE e
LEFT JOIN EMPLOYEE s ON e.Super_ssn = s.Ssn
JOIN DEPARTMENT d ON e.Dno = d.Dnumber
WHERE d.Dname = 'Research';
