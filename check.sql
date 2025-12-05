-- ==========================================
-- LAB 5: VALIDATION / CHECK SCRIPT
-- ==========================================

USE COMPANY_Lab5;

-- ==========================================
-- TEST VIEWS
-- ==========================================

-- View a: DepartmentManagerInfo
SELECT * FROM DepartmentManagerInfo;

-- View b: ResearchEmployeeSupervisor
SELECT * FROM ResearchEmployeeSupervisor;

-- View c: ProjectInfo
SELECT * FROM ProjectInfo;


-- View d: ProjectInfoMoreThanTwo
SELECT * FROM ProjectInfoMoreThanTwo;

-- View e: EmployeesWithManyDependents
SELECT * FROM EmployeesWithManyDependents;

-- View f: JulyBirthdayEmployees
SELECT * FROM JulyBirthdayEmployees;

-- View g: YoungDependents
SELECT * FROM YoungDependents;

-- ==========================================
-- TEST FUNCTION
-- ==========================================

-- Function c: GetTotalProjectsForEmployee
SELECT '123456789' AS Employee_SSN, GetTotalProjectsForEmployee('123456789') AS Total_Projects;
SELECT '333445555' AS Employee_SSN, GetTotalProjectsForEmployee('333445555') AS Total_Projects;
SELECT '888665555' AS Employee_SSN, GetTotalProjectsForEmployee('888665555') AS Total_Projects;

-- ==========================================
-- TEST STORED PROCEDURES
-- ==========================================

-- Procedure d: PrintEmployeeDetails
CALL PrintEmployeeDetails();

-- Procedure f: PrintEmployeeSalaryLevel
CALL PrintEmployeeSalaryLevel();

-- ==========================================
-- TEST TRIGGERS
-- ==========================================

-- Test Salary Log Trigger
SELECT * FROM SALARY_LOG;

-- Test Num_of_Emp attribute
SELECT Dname, Dnumber, Num_of_Emp FROM DEPARTMENT;

-- ==========================================
-- TEST TRIGGER CONSTRAINTS WITH INSERT/UPDATE
-- ==========================================

-- Test a.1: Supervisor must be older (should FAIL - employee older than supervisor)
-- INSERT INTO EMPLOYEE VALUES ('Test','X','OldUser','111111111','1950-01-01','Test','M',25000,'333445555',5);

-- Test a.2: Salary cannot exceed supervisor's salary (should FAIL)
-- INSERT INTO EMPLOYEE VALUES ('Test','X','HighPay','111111111','1990-01-01','Test','M',50000,'333445555',5);

-- Test a.3: Salary can only increase (should FAIL - decreasing salary)
-- UPDATE EMPLOYEE SET Salary = 20000 WHERE Ssn = '123456789';

-- Test a.4: Max 20% salary increase (should FAIL - increase > 20%)
-- UPDATE EMPLOYEE SET Salary = 50000 WHERE Ssn = '123456789';

-- Test a.5: Max 4 projects per employee (should FAIL - Franklin Wong already has 4)
-- INSERT INTO WORKS_ON VALUES ('333445555', 30, 5.0);

-- Test a.6: Max 56 hours per week (should FAIL - would exceed 56)
-- INSERT INTO WORKS_ON VALUES ('123456789', 30, 20.0);

-- Test a.7: Project location must match department (should FAIL - Dallas not in Research)
-- INSERT INTO PROJECT VALUES ('TestProject', 100, 'Dallas', 5);

-- Test a.8: Manager salary must be highest (should FAIL - salary >= manager)
-- INSERT INTO EMPLOYEE VALUES ('Test','X','HighPay','111111111','1990-01-01','Test','M',45000,NULL,5);

-- Test a.9: Only managers can work < 5 hours (should FAIL - non-manager)
-- INSERT INTO WORKS_ON VALUES ('123456789', 30, 3.0);

-- ==========================================
-- VALID INSERT TESTS (should SUCCEED)
-- ==========================================

-- Valid employee insert (younger than supervisor, lower salary)
INSERT INTO EMPLOYEE VALUES ('Test','V','Valid','111111111','1990-01-01','Test Address','M',25000,'333445555',5);
SELECT * FROM EMPLOYEE WHERE Ssn = '111111111';

-- Verify Num_of_Emp increased
SELECT Dname, Num_of_Emp FROM DEPARTMENT WHERE Dnumber = 5;

-- Valid project assignment
INSERT INTO WORKS_ON VALUES ('111111111', 1, 10.0);
SELECT * FROM WORKS_ON WHERE Essn = '111111111';

-- Clean up test data
DELETE FROM WORKS_ON WHERE Essn = '111111111';
DELETE FROM EMPLOYEE WHERE Ssn = '111111111';

-- Verify Num_of_Emp decreased back
SELECT Dname, Num_of_Emp FROM DEPARTMENT WHERE Dnumber = 5;

-- ==========================================
-- EXERCISE 2: HOTEL DATABASE
-- ==========================================

USE Hotel_Lab5;

-- Hotel Data
SELECT * FROM Hotel;

-- Room Data
SELECT * FROM Room;

-- Guest Data
SELECT * FROM Guest;

-- Booking Data
SELECT * FROM Booking;

-- LondonHotelRoom View
SELECT * FROM LondonHotelRoom;

-- TotalAmount calculation
SELECT guestNo, guestName, TotalAmount FROM Guest;
