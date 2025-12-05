-- ==========================================
-- LAB 5: VIEW - Task e
-- Database: COMPANY_Lab5
-- ==========================================
-- e. A view (SSN, Full Name of employee, Number of dependents) that includes information 
--    about employees who have the number of dependents greater than 2.
-- ==========================================

USE COMPANY_Lab5;

DROP VIEW IF EXISTS EmployeesWithManyDependents;
CREATE VIEW EmployeesWithManyDependents AS
SELECT 
    e.Ssn AS SSN,
    CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS Full_Name,
    COUNT(dep.Dependent_name) AS Number_of_Dependents
FROM EMPLOYEE e
JOIN DEPENDENT dep ON e.Ssn = dep.Essn
GROUP BY e.Ssn, e.Fname, e.Minit, e.Lname
HAVING COUNT(dep.Dependent_name) > 2;
