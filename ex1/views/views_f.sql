-- ==========================================
-- LAB 5: VIEW - Task f
-- Database: COMPANY_Lab5
-- ==========================================
-- f. A view (Full Name of employee, date of birth, gender) for those employees who have 
--    their birthdate in July.
-- ==========================================

USE COMPANY_Lab5;

DROP VIEW IF EXISTS JulyBirthdayEmployees;
CREATE VIEW JulyBirthdayEmployees AS
SELECT 
    CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS Full_Name,
    e.Bdate AS Date_of_Birth,
    e.Sex AS Gender
FROM EMPLOYEE e
WHERE MONTH(e.Bdate) = 7;
