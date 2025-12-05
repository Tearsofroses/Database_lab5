-- ==========================================
-- LAB 5: TRIGGERS (a, b, e)
-- Database: COMPANY_Lab5
-- ==========================================

USE COMPANY_Lab5;

-- ==========================================
-- a. Create database triggers for the following situations:
-- ==========================================

-- ==========================================
-- Trigger 1: The supervisor of an employee must be older than the employee.
-- ==========================================
DROP TRIGGER IF EXISTS trg_supervisor_older_insert;
DELIMITER //
CREATE TRIGGER trg_supervisor_older_insert
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE supervisor_bdate DATE;
    IF NEW.Super_ssn IS NOT NULL THEN
        SELECT Bdate INTO supervisor_bdate FROM EMPLOYEE WHERE Ssn = NEW.Super_ssn;
        IF supervisor_bdate IS NOT NULL AND NEW.Bdate <= supervisor_bdate THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Supervisor must be older than the employee.';
        END IF;
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trg_supervisor_older_update;
DELIMITER //
CREATE TRIGGER trg_supervisor_older_update
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE supervisor_bdate DATE;
    IF NEW.Super_ssn IS NOT NULL THEN
        SELECT Bdate INTO supervisor_bdate FROM EMPLOYEE WHERE Ssn = NEW.Super_ssn;
        IF supervisor_bdate IS NOT NULL AND NEW.Bdate <= supervisor_bdate THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Supervisor must be older than the employee.';
        END IF;
    END IF;
END //
DELIMITER ;

-- ==========================================
-- Trigger 2: The salary of an employee cannot be greater than the salary of his/her supervisor.
-- ==========================================
DROP TRIGGER IF EXISTS trg_salary_less_than_supervisor_insert;
DELIMITER //
CREATE TRIGGER trg_salary_less_than_supervisor_insert
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE supervisor_salary DECIMAL(10, 2);
    IF NEW.Super_ssn IS NOT NULL THEN
        SELECT Salary INTO supervisor_salary FROM EMPLOYEE WHERE Ssn = NEW.Super_ssn;
        IF supervisor_salary IS NOT NULL AND NEW.Salary > supervisor_salary THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Employee salary cannot be greater than supervisor salary.';
        END IF;
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trg_salary_less_than_supervisor_update;
DELIMITER //
CREATE TRIGGER trg_salary_less_than_supervisor_update
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE supervisor_salary DECIMAL(10, 2);
    IF NEW.Super_ssn IS NOT NULL THEN
        SELECT Salary INTO supervisor_salary FROM EMPLOYEE WHERE Ssn = NEW.Super_ssn;
        IF supervisor_salary IS NOT NULL AND NEW.Salary > supervisor_salary THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Employee salary cannot be greater than supervisor salary.';
        END IF;
    END IF;
END //
DELIMITER ;

-- ==========================================
-- Trigger 3: The salary of an employee can only increase.
-- ==========================================
DROP TRIGGER IF EXISTS trg_salary_only_increase;
DELIMITER //
CREATE TRIGGER trg_salary_only_increase
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF NEW.Salary < OLD.Salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Employee salary can only increase, not decrease.';
    END IF;
END //
DELIMITER ;

-- ==========================================
-- Trigger 4: When increasing salary of employee, the increasing amount must not be more than 20% of current salary.
-- ==========================================
DROP TRIGGER IF EXISTS trg_salary_increase_max_20_percent;
DELIMITER //
CREATE TRIGGER trg_salary_increase_max_20_percent
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF NEW.Salary > OLD.Salary THEN
        IF (NEW.Salary - OLD.Salary) > (OLD.Salary * 0.20) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Salary increase cannot exceed 20% of current salary.';
        END IF;
    END IF;
END //
DELIMITER ;

-- ==========================================
-- Trigger 5: An employee works on at most 4 projects.
-- ==========================================
DROP TRIGGER IF EXISTS trg_max_4_projects_insert;
DELIMITER //
CREATE TRIGGER trg_max_4_projects_insert
BEFORE INSERT ON WORKS_ON
FOR EACH ROW
BEGIN
    DECLARE project_count INT;
    SELECT COUNT(*) INTO project_count FROM WORKS_ON WHERE Essn = NEW.Essn;
    IF project_count >= 4 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: An employee can work on at most 4 projects.';
    END IF;
END //
DELIMITER ;

-- ==========================================
-- Trigger 6: The maximum number of hours an employee can work on all projects per week is 56.
-- ==========================================
DROP TRIGGER IF EXISTS trg_max_56_hours_insert;
DELIMITER //
CREATE TRIGGER trg_max_56_hours_insert
BEFORE INSERT ON WORKS_ON
FOR EACH ROW
BEGIN
    DECLARE total_hours DECIMAL(5, 1);
    SELECT IFNULL(SUM(Hours), 0) INTO total_hours FROM WORKS_ON WHERE Essn = NEW.Essn;
    IF (total_hours + IFNULL(NEW.Hours, 0)) > 56 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Total hours per week cannot exceed 56.';
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trg_max_56_hours_update;
DELIMITER //
CREATE TRIGGER trg_max_56_hours_update
BEFORE UPDATE ON WORKS_ON
FOR EACH ROW
BEGIN
    DECLARE total_hours DECIMAL(5, 1);
    SELECT IFNULL(SUM(Hours), 0) INTO total_hours FROM WORKS_ON WHERE Essn = NEW.Essn AND Pno != NEW.Pno;
    IF (total_hours + IFNULL(NEW.Hours, 0)) > 56 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Total hours per week cannot exceed 56.';
    END IF;
END //
DELIMITER ;

-- ==========================================
-- Trigger 7: The location of a project must be one of the locations of its department.
-- ==========================================
DROP TRIGGER IF EXISTS trg_project_location_valid_insert;
DELIMITER //
CREATE TRIGGER trg_project_location_valid_insert
BEFORE INSERT ON PROJECT
FOR EACH ROW
BEGIN
    DECLARE location_exists INT;
    SELECT COUNT(*) INTO location_exists 
    FROM DEPT_LOCATIONS 
    WHERE Dnumber = NEW.Dnum AND Dlocation = NEW.Plocation;
    IF location_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Project location must be one of its department locations.';
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trg_project_location_valid_update;
DELIMITER //
CREATE TRIGGER trg_project_location_valid_update
BEFORE UPDATE ON PROJECT
FOR EACH ROW
BEGIN
    DECLARE location_exists INT;
    SELECT COUNT(*) INTO location_exists 
    FROM DEPT_LOCATIONS 
    WHERE Dnumber = NEW.Dnum AND Dlocation = NEW.Plocation;
    IF location_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Project location must be one of its department locations.';
    END IF;
END //
DELIMITER ;

-- ==========================================
-- Trigger 8: The salary of a department manager must be higher than the other employees 
--            working for that department.
-- ==========================================
DROP TRIGGER IF EXISTS trg_manager_salary_highest_insert;
DELIMITER //
CREATE TRIGGER trg_manager_salary_highest_insert
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE manager_salary DECIMAL(10, 2);
    DECLARE manager_ssn CHAR(9);
    
    IF NEW.Dno IS NOT NULL THEN
        SELECT Mgr_ssn INTO manager_ssn FROM DEPARTMENT WHERE Dnumber = NEW.Dno;
        IF manager_ssn IS NOT NULL AND manager_ssn != NEW.Ssn THEN
            SELECT Salary INTO manager_salary FROM EMPLOYEE WHERE Ssn = manager_ssn;
            IF manager_salary IS NOT NULL AND NEW.Salary >= manager_salary THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Error: Employee salary cannot be equal or greater than department manager salary.';
            END IF;
        END IF;
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trg_manager_salary_highest_update;
DELIMITER //
CREATE TRIGGER trg_manager_salary_highest_update
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE manager_salary DECIMAL(10, 2);
    DECLARE manager_ssn CHAR(9);
    
    IF NEW.Dno IS NOT NULL THEN
        SELECT Mgr_ssn INTO manager_ssn FROM DEPARTMENT WHERE Dnumber = NEW.Dno;
        IF manager_ssn IS NOT NULL AND manager_ssn != NEW.Ssn THEN
            SELECT Salary INTO manager_salary FROM EMPLOYEE WHERE Ssn = manager_ssn;
            IF manager_salary IS NOT NULL AND NEW.Salary >= manager_salary THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Error: Employee salary cannot be equal or greater than department manager salary.';
            END IF;
        END IF;
    END IF;
END //
DELIMITER ;

-- ==========================================
-- Trigger 9: Only department managers can work less than 5 hours on a project.
-- ==========================================
DROP TRIGGER IF EXISTS trg_min_5_hours_non_manager_insert;
DELIMITER //
CREATE TRIGGER trg_min_5_hours_non_manager_insert
BEFORE INSERT ON WORKS_ON
FOR EACH ROW
BEGIN
    DECLARE is_manager INT;
    IF NEW.Hours IS NOT NULL AND NEW.Hours < 5 THEN
        SELECT COUNT(*) INTO is_manager FROM DEPARTMENT WHERE Mgr_ssn = NEW.Essn;
        IF is_manager = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Only department managers can work less than 5 hours on a project.';
        END IF;
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trg_min_5_hours_non_manager_update;
DELIMITER //
CREATE TRIGGER trg_min_5_hours_non_manager_update
BEFORE UPDATE ON WORKS_ON
FOR EACH ROW
BEGIN
    DECLARE is_manager INT;
    IF NEW.Hours IS NOT NULL AND NEW.Hours < 5 THEN
        SELECT COUNT(*) INTO is_manager FROM DEPARTMENT WHERE Mgr_ssn = NEW.Essn;
        IF is_manager = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Only department managers can work less than 5 hours on a project.';
        END IF;
    END IF;
END //
DELIMITER ;

-- ==========================================
-- b. Alter table Department to add Num_of_Emp attribute
--    This attribute stores the number of employees working for each department
--    Its value must be automatically calculated.
-- ==========================================

-- Add the column
ALTER TABLE DEPARTMENT ADD COLUMN Num_of_Emp INT DEFAULT 0;

-- Initialize the column with current counts
UPDATE DEPARTMENT d
SET Num_of_Emp = (SELECT COUNT(*) FROM EMPLOYEE e WHERE e.Dno = d.Dnumber);

-- Trigger to update Num_of_Emp when employee is inserted
DROP TRIGGER IF EXISTS trg_update_num_emp_insert;
DELIMITER //
CREATE TRIGGER trg_update_num_emp_insert
AFTER INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF NEW.Dno IS NOT NULL THEN
        UPDATE DEPARTMENT 
        SET Num_of_Emp = Num_of_Emp + 1 
        WHERE Dnumber = NEW.Dno;
    END IF;
END //
DELIMITER ;

-- Trigger to update Num_of_Emp when employee is deleted
DROP TRIGGER IF EXISTS trg_update_num_emp_delete;
DELIMITER //
CREATE TRIGGER trg_update_num_emp_delete
AFTER DELETE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF OLD.Dno IS NOT NULL THEN
        UPDATE DEPARTMENT 
        SET Num_of_Emp = Num_of_Emp - 1 
        WHERE Dnumber = OLD.Dno;
    END IF;
END //
DELIMITER ;

-- Trigger to update Num_of_Emp when employee changes department
DROP TRIGGER IF EXISTS trg_update_num_emp_update;
DELIMITER //
CREATE TRIGGER trg_update_num_emp_update
AFTER UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF OLD.Dno IS NOT NULL AND (NEW.Dno IS NULL OR OLD.Dno != NEW.Dno) THEN
        UPDATE DEPARTMENT 
        SET Num_of_Emp = Num_of_Emp - 1 
        WHERE Dnumber = OLD.Dno;
    END IF;
    IF NEW.Dno IS NOT NULL AND (OLD.Dno IS NULL OR OLD.Dno != NEW.Dno) THEN
        UPDATE DEPARTMENT 
        SET Num_of_Emp = Num_of_Emp + 1 
        WHERE Dnumber = NEW.Dno;
    END IF;
END //
DELIMITER ;

-- ==========================================
-- e. Write a trigger that logs any changes in case the new salary is greater than 50000
--    updated or inserted into our database.
-- ==========================================

-- Create the LOG table
DROP TABLE IF EXISTS SALARY_LOG;
CREATE TABLE SALARY_LOG (
    Log_id INT AUTO_INCREMENT PRIMARY KEY,
    SSN CHAR(9),
    Content VARCHAR(255),
    Log_Date DATE
);

-- Trigger for INSERT
DROP TRIGGER IF EXISTS trg_log_salary_insert;
DELIMITER //
CREATE TRIGGER trg_log_salary_insert
AFTER INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF NEW.Salary > 50000 THEN
        INSERT INTO SALARY_LOG (SSN, Content, Log_Date)
        VALUES (NEW.Ssn, CONCAT('SALARY INSERT: ', NEW.Salary), CURDATE());
    END IF;
END //
DELIMITER ;

-- Trigger for UPDATE
DROP TRIGGER IF EXISTS trg_log_salary_update;
DELIMITER //
CREATE TRIGGER trg_log_salary_update
AFTER UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF NEW.Salary > 50000 THEN
        INSERT INTO SALARY_LOG (SSN, Content, Log_Date)
        VALUES (NEW.Ssn, CONCAT('SALARY UPDATE FROM ', OLD.Salary, ' TO ', NEW.Salary), CURDATE());
    END IF;
END //
DELIMITER ;
