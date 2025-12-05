-- ==========================================
-- LAB 5: VIEW - Task g
-- Database: COMPANY_Lab5
-- ==========================================
-- g. A view (Name of dependent, SSN of employee, date of birth of dependent) that includes 
--    information on all dependents who are less than 18 years old.
-- ==========================================

USE COMPANY_Lab5;

DROP VIEW IF EXISTS YoungDependents;
CREATE VIEW YoungDependents AS
SELECT 
    dep.Dependent_name AS Dependent_Name,
    dep.Essn AS Employee_SSN,
    dep.Bdate AS Dependent_Date_of_Birth
FROM DEPENDENT dep
WHERE TIMESTAMPDIFF(YEAR, dep.Bdate, CURDATE()) < 18;
