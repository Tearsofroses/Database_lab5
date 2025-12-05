-- ==========================================
-- LAB 5: TRIGGERS - Task e (Logging)
-- Database: COMPANY_Lab5
-- ==========================================
-- e. Write the trigger(s) to maintain a log table containing information 
--    about the changes of employees' salaries.
--    Log table: (User, Date, ESSN, Old_Salary, New_Salary)
-- ==========================================

USE COMPANY_Lab5;

-- -----------------------------------------
-- Create the log table if it doesn't exist
-- -----------------------------------------

DROP TABLE IF EXISTS SALARY_LOG;
CREATE TABLE SALARY_LOG (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_Name VARCHAR(100),
    Change_Date DATETIME,
    ESSN CHAR(9),
    Old_Salary DECIMAL(10, 2),
    New_Salary DECIMAL(10, 2)
);

-- -----------------------------------------
-- Trigger for INSERT: Log initial salary when employee is created
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_log_salary_insert;
DELIMITER //
CREATE TRIGGER trg_log_salary_insert
AFTER INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    INSERT INTO SALARY_LOG (User_Name, Change_Date, ESSN, Old_Salary, New_Salary)
    VALUES (CURRENT_USER(), NOW(), NEW.Ssn, NULL, NEW.Salary);
END //
DELIMITER ;

-- -----------------------------------------
-- Trigger for UPDATE: Log salary changes
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_log_salary_update;
DELIMITER //
CREATE TRIGGER trg_log_salary_update
AFTER UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF OLD.Salary != NEW.Salary THEN
        INSERT INTO SALARY_LOG (User_Name, Change_Date, ESSN, Old_Salary, New_Salary)
        VALUES (CURRENT_USER(), NOW(), NEW.Ssn, OLD.Salary, NEW.Salary);
    END IF;
END //
DELIMITER ;
