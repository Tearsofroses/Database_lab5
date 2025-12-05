-- ==========================================
-- LAB 5: STORED PROCEDURE - Task f
-- Database: COMPANY_Lab5
-- ==========================================
-- f. Write a stored procedure that prints out the level of salary for each employee:
--    Rules: 
--    - if (salary < 20000) then "level C"
--    - if (salary between 20000 and 50000) then "level B"
--    - if (salary > 50000) then "level A"
-- ==========================================

USE COMPANY_Lab5;

DROP PROCEDURE IF EXISTS PrintEmployeeSalaryLevel;
DELIMITER //
CREATE PROCEDURE PrintEmployeeSalaryLevel()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_ssn CHAR(9);
    DECLARE v_fullname VARCHAR(50);
    DECLARE v_salary DECIMAL(10, 2);
    DECLARE v_level VARCHAR(10);
    
    -- Cursor to iterate through all employees
    DECLARE emp_cursor CURSOR FOR
        SELECT 
            e.Ssn,
            CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS Full_Name,
            e.Salary
        FROM EMPLOYEE e;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Create temporary table to store results
    DROP TEMPORARY TABLE IF EXISTS temp_salary_levels;
    CREATE TEMPORARY TABLE temp_salary_levels (
        SSN CHAR(9),
        Full_Name VARCHAR(50),
        Salary_Level VARCHAR(10)
    );
    
    OPEN emp_cursor;
    
    read_loop: LOOP
        FETCH emp_cursor INTO v_ssn, v_fullname, v_salary;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Determine salary level
        IF v_salary < 20000 THEN
            SET v_level = 'level C';
        ELSEIF v_salary >= 20000 AND v_salary <= 50000 THEN
            SET v_level = 'level B';
        ELSE
            SET v_level = 'level A';
        END IF;
        
        INSERT INTO temp_salary_levels VALUES (v_ssn, v_fullname, v_level);
    END LOOP;
    
    CLOSE emp_cursor;
    
    -- Return the results
    SELECT * FROM temp_salary_levels;
    
    DROP TEMPORARY TABLE IF EXISTS temp_salary_levels;
END //
DELIMITER ;
