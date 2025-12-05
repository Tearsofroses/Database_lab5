-- ==========================================
-- LAB 5: STORED PROCEDURE - Task d
-- Database: COMPANY_Lab5
-- ==========================================
-- d. Create a stored procedure that prints SSN, Full name, Department name, 
--    and annual salary of all employees.
-- ==========================================

USE COMPANY_Lab5;

DROP PROCEDURE IF EXISTS PrintEmployeeDetails;
DELIMITER //
CREATE PROCEDURE PrintEmployeeDetails()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_ssn CHAR(9);
    DECLARE v_fullname VARCHAR(50);
    DECLARE v_dname VARCHAR(25);
    DECLARE v_annual_salary DECIMAL(12, 2);
    
    -- Cursor to iterate through all employees
    DECLARE emp_cursor CURSOR FOR
        SELECT 
            e.Ssn,
            CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS Full_Name,
            d.Dname,
            e.Salary * 12 AS Annual_Salary
        FROM EMPLOYEE e
        LEFT JOIN DEPARTMENT d ON e.Dno = d.Dnumber;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Create temporary table to store results
    DROP TEMPORARY TABLE IF EXISTS temp_employee_details;
    CREATE TEMPORARY TABLE temp_employee_details (
        SSN CHAR(9),
        Full_Name VARCHAR(50),
        Department_Name VARCHAR(25),
        Annual_Salary DECIMAL(12, 2)
    );
    
    OPEN emp_cursor;
    
    read_loop: LOOP
        FETCH emp_cursor INTO v_ssn, v_fullname, v_dname, v_annual_salary;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        INSERT INTO temp_employee_details VALUES (v_ssn, v_fullname, v_dname, v_annual_salary);
    END LOOP;
    
    CLOSE emp_cursor;
    
    -- Return the results
    SELECT * FROM temp_employee_details;
    
    DROP TEMPORARY TABLE IF EXISTS temp_employee_details;
END //
DELIMITER ;
