-- ==========================================
-- LAB 5: TRIGGERS - Task b (Derived Attribute)
-- Database: COMPANY_Lab5
-- ==========================================
-- b. Write the trigger(s) to maintain the derived attribute Num_of_Emp
--    for each department of DEPARTMENT table.
-- ==========================================

USE COMPANY_Lab5;

-- -----------------------------------------
-- Trigger for INSERT: Increment Num_of_Emp when new employee is added
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_update_num_emp_insert;
DELIMITER //
CREATE TRIGGER trg_update_num_emp_insert
AFTER INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF NEW.Dno IS NOT NULL THEN
        UPDATE DEPARTMENT 
        SET Num_of_Emp = (SELECT COUNT(*) FROM EMPLOYEE WHERE Dno = NEW.Dno)
        WHERE Dnumber = NEW.Dno;
    END IF;
END //
DELIMITER ;

-- -----------------------------------------
-- Trigger for DELETE: Decrement Num_of_Emp when employee is removed
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_update_num_emp_delete;
DELIMITER //
CREATE TRIGGER trg_update_num_emp_delete
AFTER DELETE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF OLD.Dno IS NOT NULL THEN
        UPDATE DEPARTMENT 
        SET Num_of_Emp = (SELECT COUNT(*) FROM EMPLOYEE WHERE Dno = OLD.Dno)
        WHERE Dnumber = OLD.Dno;
    END IF;
END //
DELIMITER ;

-- -----------------------------------------
-- Trigger for UPDATE: Update Num_of_Emp when employee changes department
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_update_num_emp_update;
DELIMITER //
CREATE TRIGGER trg_update_num_emp_update
AFTER UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF OLD.Dno != NEW.Dno OR (OLD.Dno IS NULL AND NEW.Dno IS NOT NULL) OR (OLD.Dno IS NOT NULL AND NEW.Dno IS NULL) THEN
        IF OLD.Dno IS NOT NULL THEN
            UPDATE DEPARTMENT 
            SET Num_of_Emp = (SELECT COUNT(*) FROM EMPLOYEE WHERE Dno = OLD.Dno)
            WHERE Dnumber = OLD.Dno;
        END IF;
        
        IF NEW.Dno IS NOT NULL THEN
            UPDATE DEPARTMENT 
            SET Num_of_Emp = (SELECT COUNT(*) FROM EMPLOYEE WHERE Dno = NEW.Dno)
            WHERE Dnumber = NEW.Dno;
        END IF;
    END IF;
END //
DELIMITER ;
