-- ==========================================
-- LAB 5: VIEW - Task d
-- Database: COMPANY_Lab5
-- ==========================================
-- d. A view that has the project name, controlling department name, number of employees, 
--    and total hours worked per week on the project for each project with more than two 
--    employees working on it.
-- ==========================================

USE COMPANY_Lab5;

DROP VIEW IF EXISTS ProjectInfoMoreThanTwo;
CREATE VIEW ProjectInfoMoreThanTwo AS
SELECT 
    p.Pname AS Project_Name,
    d.Dname AS Controlling_Department,
    COUNT(w.Essn) AS Number_of_Employees,
    SUM(IFNULL(w.Hours, 0)) AS Total_Hours_Per_Week
FROM PROJECT p
JOIN DEPARTMENT d ON p.Dnum = d.Dnumber
LEFT JOIN WORKS_ON w ON p.Pnumber = w.Pno
GROUP BY p.Pnumber, p.Pname, d.Dname
HAVING COUNT(w.Essn) > 2;
