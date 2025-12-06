-- ==========================================
-- LAB 5: TRIGGERS - Task a (Constraints)
-- Database: COMPANY_Lab5
-- ==========================================
-- a. Write triggers to enforce the following constraints:
--    1. An employee's supervisor must be older than the employee.
--    2. An employee's salary must be less than his/her supervisor's salary.
--    3. Salary can only increase.
--    4. Salary can be raised only by a maximum of 20%.
--    5. Each employee can work on at most 4 projects.
--    6. Each employee can work on no more than 56 hours/week total.
--    7. An employee can only work on projects of the controlling department.
--    8. A manager's salary must be the highest in the department.
--    9. A non-manager employee must work at least 5 hours.
-- ==========================================

USE COMPANY_Lab5;

-- -----------------------------------------
-- Constraint 1: An employee's supervisor must be older than the employee
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_supervisor_older_insert;
DELIMITER //
CREATE TRIGGER trg_supervisor_older_insert
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE supervisor_bdate DATE;
    
    IF NEW.Super_ssn IS NOT NULL THEN
        SELECT Bdate INTO supervisor_bdate FROM EMPLOYEE WHERE Ssn = NEW.Super_ssn;
        
        IF supervisor_bdate IS NOT NULL AND supervisor_bdate > NEW.Bdate THEN
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
        
        IF supervisor_bdate IS NOT NULL AND supervisor_bdate > NEW.Bdate THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Supervisor must be older than the employee.';
        END IF;
    END IF;
END //
DELIMITER ;

-- -----------------------------------------
-- Constraint 2: An employee's salary must be less than his/her supervisor's salary
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_salary_less_than_supervisor;
DELIMITER //
CREATE TRIGGER trg_salary_less_than_supervisor
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE supervisor_salary DECIMAL(10, 2);
    
    IF NEW.Super_ssn IS NOT NULL THEN
        SELECT Salary INTO supervisor_salary FROM EMPLOYEE WHERE Ssn = NEW.Super_ssn;
        
        IF supervisor_salary IS NOT NULL AND NEW.Salary >= supervisor_salary THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Employee salary must be less than supervisor salary.';
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
        
        IF supervisor_salary IS NOT NULL AND NEW.Salary >= supervisor_salary THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Employee salary must be less than supervisor salary.';
        END IF;
    END IF;
END //
DELIMITER ;

-- -----------------------------------------
-- Constraint 3: Salary can only increase
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_salary_only_increase;
DELIMITER //
CREATE TRIGGER trg_salary_only_increase
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF NEW.Salary < OLD.Salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Salary can only increase, not decrease.';
    END IF;
END //
DELIMITER ;

-- -----------------------------------------
-- Constraint 4: Salary can be raised only by a maximum of 20%
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_salary_increase_max_20_percent;
DELIMITER //
CREATE TRIGGER trg_salary_increase_max_20_percent
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF NEW.Salary > OLD.Salary * 1.20 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Salary increase cannot exceed 20%.';
    END IF;
END //
DELIMITER ;

-- -----------------------------------------
-- Constraint 5: Each employee can work on at most 4 projects
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_max_4_projects;
DELIMITER //
CREATE TRIGGER trg_max_4_projects
BEFORE INSERT ON WORKS_ON
FOR EACH ROW
BEGIN
    DECLARE project_count INT;
    
    SELECT COUNT(*) INTO project_count FROM WORKS_ON WHERE Essn = NEW.Essn;
    
    IF project_count >= 4 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Employee cannot work on more than 4 projects.';
    END IF;
END //
DELIMITER ;

-- -----------------------------------------
-- Constraint 6: Each employee can work on no more than 56 hours/week total
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_max_56_hours;
DELIMITER //
CREATE TRIGGER trg_max_56_hours
BEFORE INSERT ON WORKS_ON
FOR EACH ROW
BEGIN
    DECLARE total_hours DECIMAL(5, 1);
    
    SELECT IFNULL(SUM(Hours), 0) INTO total_hours FROM WORKS_ON WHERE Essn = NEW.Essn;
    
    IF (total_hours + IFNULL(NEW.Hours, 0)) > 56 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Total weekly hours cannot exceed 56.';
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
    
    SELECT IFNULL(SUM(Hours), 0) INTO total_hours FROM WORKS_ON 
    WHERE Essn = NEW.Essn AND Pno != OLD.Pno;
    
    IF (total_hours + IFNULL(NEW.Hours, 0)) > 56 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Total weekly hours cannot exceed 56.';
    END IF;
END //
DELIMITER ;

-- -----------------------------------------
-- Constraint 7: An employee can only work on projects of the controlling department
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_project_dept_valid;
DELIMITER //
CREATE TRIGGER trg_project_dept_valid
BEFORE INSERT ON WORKS_ON
FOR EACH ROW
BEGIN
    DECLARE emp_dept INT;
    DECLARE project_dept INT;
    
    SELECT Dno INTO emp_dept FROM EMPLOYEE WHERE Ssn = NEW.Essn;
    SELECT Dnum INTO project_dept FROM PROJECT WHERE Pnumber = NEW.Pno;
    
    IF emp_dept != project_dept THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Employee can only work on projects controlled by their department.';
    END IF;
END //
DELIMITER ;

-- Additional trigger: Project location must be one of department locations
DROP TRIGGER IF EXISTS trg_project_location_valid;
DELIMITER //
CREATE TRIGGER trg_project_location_valid
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

-- -----------------------------------------
-- Constraint 8: A manager's salary must be the highest in the department
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_manager_salary_highest;
DELIMITER //
CREATE TRIGGER trg_manager_salary_highest
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE is_manager INT;
    DECLARE max_other_salary DECIMAL(10, 2);
    
    SELECT COUNT(*) INTO is_manager FROM DEPARTMENT WHERE Mgr_ssn = NEW.Ssn;
    
    IF is_manager > 0 THEN
        SELECT MAX(Salary) INTO max_other_salary 
        FROM EMPLOYEE e
        JOIN DEPARTMENT d ON d.Dnumber = e.Dno
        WHERE d.Mgr_ssn = NEW.Ssn AND e.Ssn != NEW.Ssn;
        
        IF max_other_salary IS NOT NULL AND NEW.Salary <= max_other_salary THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Manager salary must be highest in the department.';
        END IF;
    END IF;
END //
DELIMITER ;

-- -----------------------------------------
-- Constraint 9: A non-manager employee must work at least 5 hours
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_min_5_hours_non_manager;
DELIMITER //
CREATE TRIGGER trg_min_5_hours_non_manager
BEFORE INSERT ON WORKS_ON
FOR EACH ROW
BEGIN
    DECLARE is_manager INT;
    
    SELECT COUNT(*) INTO is_manager FROM DEPARTMENT WHERE Mgr_ssn = NEW.Essn;
    
    IF is_manager = 0 AND (NEW.Hours IS NULL OR NEW.Hours < 5) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Non-manager employee must work at least 5 hours on a project.';
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
    
    SELECT COUNT(*) INTO is_manager FROM DEPARTMENT WHERE Mgr_ssn = NEW.Essn;
    
    IF is_manager = 0 AND (NEW.Hours IS NULL OR NEW.Hours < 5) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Non-manager employee must work at least 5 hours on a project.';
    END IF;
END //
DELIMITER ;
