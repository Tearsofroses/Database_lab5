-- ==========================================
-- LAB 5: FUNCTIONS (c)
-- Database: COMPANY_Lab5
-- ==========================================

USE COMPANY_Lab5;

-- ==========================================
-- c. Write a function that returns the total number of projects when given an employee's ID.
--    Input: employee ID
--    Output: total number of projects
-- ==========================================

DROP FUNCTION IF EXISTS GetTotalProjectsForEmployee;
DELIMITER //
CREATE FUNCTION GetTotalProjectsForEmployee(emp_ssn CHAR(9))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_projects INT;
    
    SELECT COUNT(*) INTO total_projects
    FROM WORKS_ON
    WHERE Essn = emp_ssn;
    
    RETURN total_projects;
END //
DELIMITER ;

-- Example usage:
-- SELECT GetTotalProjectsForEmployee('123456789') AS Total_Projects;
-- SELECT GetTotalProjectsForEmployee('333445555') AS Total_Projects;
