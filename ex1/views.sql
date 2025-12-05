-- ==========================================
-- LAB 5: VIEWS (a-g)
-- Database: COMPANY_Lab5
-- ==========================================

USE COMPANY_Lab5;

-- ==========================================
-- a. A view that has the department name, manager name, and manager salary for every department.
-- ==========================================
DROP VIEW IF EXISTS DepartmentManagerInfo;
CREATE VIEW DepartmentManagerInfo AS
SELECT 
    d.Dname AS Department_Name,
    CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS Manager_Name,
    e.Salary AS Manager_Salary
FROM DEPARTMENT d
JOIN EMPLOYEE e ON d.Mgr_ssn = e.Ssn;

-- ==========================================
-- b. A view that has the employee name, supervisor name, and employee salary for each employee
--    who works in the 'Research' department.
-- ==========================================
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

-- ==========================================
-- c. A view that has the project name, controlling department name, number of employees, 
--    and total hours worked per week on the project for each project.
-- ==========================================
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

-- ==========================================
-- d. A view that has the project name, controlling department name, number of employees, 
--    and total hours worked per week on the project for each project with more than two 
--    employees working on it.
-- ==========================================
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

-- ==========================================
-- e. A view (SSN, Full Name of employee, Number of dependents) that includes information 
--    about employees who have the number of dependents greater than 2.
-- ==========================================
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

-- ==========================================
-- f. A view (Full Name of employee, date of birth, gender) for those employees who have 
--    their birthdate in July.
-- ==========================================
DROP VIEW IF EXISTS JulyBirthdayEmployees;
CREATE VIEW JulyBirthdayEmployees AS
SELECT 
    CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS Full_Name,
    e.Bdate AS Date_of_Birth,
    e.Sex AS Gender
FROM EMPLOYEE e
WHERE MONTH(e.Bdate) = 7;

-- ==========================================
-- g. A view (Name of dependent, SSN of employee, date of birth of dependent) that includes 
--    information on all dependents who are less than 18 years old.
-- ==========================================
DROP VIEW IF EXISTS YoungDependents;
CREATE VIEW YoungDependents AS
SELECT 
    dep.Dependent_name AS Dependent_Name,
    dep.Essn AS Employee_SSN,
    dep.Bdate AS Dependent_Date_of_Birth
FROM DEPENDENT dep
WHERE TIMESTAMPDIFF(YEAR, dep.Bdate, CURDATE()) < 18;
