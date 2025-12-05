-- ==========================================
-- LAB 5: VIEW - Task c
-- Database: COMPANY_Lab5
-- ==========================================
-- c. A view that has the project name, controlling department name, number of employees, 
--    and total hours worked per week on the project for each project.
-- ==========================================

USE COMPANY_Lab5;

DROP VIEW IF EXISTS ProjectInfo;
CREATE VIEW ProjectInfo AS
SELECT 
    p.Pname AS Project_Name,
    d.Dname AS Controlling_Department,
    COUNT(w.Essn) AS Number_of_Employees,
    SUM(IFNULL(w.Hours, 0)) AS Total_Hours_Per_Week
FROM PROJECT p
JOIN DEPARTMENT d ON p.Dnum = d.Dnumber
LEFT JOIN WORKS_ON w ON p.Pnumber = w.Pno
GROUP BY p.Pnumber, p.Pname, d.Dname;
