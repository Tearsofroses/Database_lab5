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
