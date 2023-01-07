-- DDL operations:
-- Database Creation:
CREATE DATABASE db_org;
USE db_org;
SET SQL_SAFE_UPDATES = 0;

-- Table Creation:
CREATE TABLE tbl_employee
(
	employee_name varchar(100) PRIMARY KEY NOT NULL,
    street varchar(100) NOT NULL,
    city varchar(100)
);

CREATE TABLE tbl_company
(
	company_name varchar(100) PRIMARY KEY NOT NULL,
    city varchar(50) NOT NULL
);

CREATE TABLE tbl_works
(
	employee_name varchar(100) NOT NULL,
    FOREIGN KEY (employee_name ) REFERENCES tbl_employee(employee_name),
    company_name varchar(100) NOT NULL,
	FOREIGN KEY (company_name) REFERENCES tbl_company(company_name),
    salary int NOT NULL
);

CREATE TABLE tbl_manages
(
	employee_name varchar(100) NOT NULL,
    FOREIGN KEY (employee_name) REFERENCES tbl_employee(employee_name),
    manager_name varchar(100) NOT NULL
);


-- DML operations:
INSERT INTO tbl_employee (employee_name, street, city) 
VALUES ("Prabin" , "annapurna", "pokhara"),
("Jones", "mc square", "einstein"),
("Raj Kumar", "Sadak galli", "Nepaltar"),
("Sajjan","pati sadak", "Jorpati"),
("Sujan", "Nice road","Bhaisepati"),
("Mary", "Country road 322", "Austin"),
("Elon", "ns 144", "Texus"),
("Subek", "Bharatpur galli 787", "Chitwan"),
("Sita", "xyc11", "New Road"),
("Ram", "rrr 78", "Bharatpur");
UPDATE  tbl_employee 
SET street ="Country road 322" where employee_name ="Jones"; -- this is done for question 2.e to make same street and city.

INSERT INTO tbl_company 
VALUES ("SIVAM", "Biratnagar"),
("First Bank Corporation", "New York"),
("New finance", "pokhara"),
("Raj Enterprise", "Nuwakot"),
("NABIL", "Kathmandu"),
("Small Bank Corporation", "Texas"),
("Medium Bank Corporation", "Texas"),
("Tesla INC", "Texas");

INSERT INTO tbl_works
VALUES ("Prabin", "New finance", 10000),
("Jones", "First Bank Corporation", 14000),
("Raj Kumar", "SIVAM", 9000),
("Sajjan","Small Bank Corporation", 6000),
("Sujan", "First Bank Corporation" ,25000),
("Mary", "Raj Enterprise", 8500),
("Elon", "Small Bank Corporation", 16230),
("Subek", "NABIL", 5250),
("Sita", "First Bank Corporation", 7500),
("Ram", "First Bank Corporation", 9000);
-- SET SQL_SAFE_UPDATES = 0;

INSERT INTO tbl_manages
VALUES ("Prabin", "Jones"),
("Jones", "Prabin"),
("Raj Kumar", "Jones"),
("Sajjan","Jones"),
("Sujan", "Raj Kumar"),
("Mary", "Jones"),
("Elon", "Mary"),
("Subek", "Elon");

SELECT * FROM tbl_employee;
SELECT * FROM tbl_company;
SELECT * FROM tbl_manages;
SELECT * FROM tbl_works;

-- Question 2
-- Ques 2.a
		-- Using nested sub-query:
        SELECT tbl_works.employee_name FROM tbl_works
        WHERE company_name = 'First Bank Corporation';
		-- Using inner joins:

-- Ques 2.b
		-- Using nested sub-query:
        SELECT tbl_employee.employee_name, tbl_employee.city FROM tbl_employee, tbl_works WHERE tbl_works.employee_name = tbl_employee.employee_name
        AND tbl_works.company_name= "First Bank Corporation";
        -- Using inner joins:
        SELECT tbl_employee.employee_name, tbl_employee.city FROM tbl_employee INNER JOIN tbl_works
        ON tbl_employee.employee_name = tbl_works.employee_name  WHERE tbl_works.company_name = 'First Bank Corporation';
        
-- Ques 2.c
		-- Using nested sub-query:
        SELECT tbl_employee.employee_name, tbl_employee.street, tbl_employee.city FROM tbl_employee, tbl_works 
        WHERE tbl_employee.employee_name = tbl_works.employee_name AND tbl_works.company_name = "First Bank Corporation"
        AND tbl_works.salary > 10000;
        -- Using inner joins:
		SELECT tbl_employee.employee_name, tbl_employee.street, tbl_employee.city FROM tbl_employee INNER JOIN tbl_works 
        ON tbl_employee.employee_name = tbl_works.employee_name WHERE tbl_works.company_name = "First Bank Corporation"
        AND tbl_works.salary > 10000;
        
-- Ques 2.d 
		-- Using nested sub-query:
        SELECT * FROM tbl_employee, tbl_works, tbl_company
        WHERE tbl_employee.employee_name = tbl_works.employee_name 
		AND tbl_works.company_name = tbl_company.company_name
        AND tbl_employee.city = tbl_company.city;
		-- Using inner joins:
        SELECT * FROM tbl_employee INNER JOIN tbl_works ON tbl_employee.employee_name = tbl_works.employee_name, tbl_company
        WHERE tbl_works.company_name = tbl_company.company_name 
        AND tbl_employee.city = tbl_company.city;

-- Ques 2.e   (done but: Confused in this question)
		-- Using nested sub-query:
        SELECT * FROM tbl_employee tbl_e1
        INNER JOIN tbl_manages tbl_m1 ON tbl_e1.employee_name = tbl_m1.employee_name
        INNER JOIN tbl_employee tbl_e2 ON tbl_e2.employee_name = tbl_m1.manager_name
        WHERE tbl_e1.street = tbl_e2.street AND tbl_e1.city = tbl_e2.city ;
	
       
-- Ques 2.f)
		SELECT * FROM tbl_works WHERE company_name <> "First Bank Corporation";

-- Ques 2.g)
	SELECT * FROM tbl_works WHERE Salary >
	(SELECT MAX(Salary) AS max_salary_small_bank FROM tbl_works WHERE tbl_works.company_name = "Small Bank Corporation");
    
-- Ques 2.h) Here "Small Bank Corporation" won't be listed.
	SELECT * FROM tbl_company WHERE tbl_company.company_name <> "Small Bank Corporation"  AND tbl_company.city IN 
    (SELECT tbl_company.city FROM tbl_company WHERE tbl_company.company_name = "Small Bank Corporation");
    
-- Ques 2.i)
	SELECT * FROM tbl_works WHERE tbl_works.salary > 
    (SELECT AVG(salary) FROM tbl_works);
    
-- Ques 2.j)
	(SELECT  company_name FROM tbl_works
    GROUP BY company_name
    ORDER BY COUNT(company_name) DESC)
    LIMIT 1;

-- Ques 2.k) calculates the company with lowest average salary:
	 SELECT company_name FROM tbl_works
     GROUP BY company_name
     ORDER BY AVG(salary) ASC
     LIMIT 1;
     
-- Ques 2.l) 
	SELECT company_name FROM 
    ( SELECT tbl_works.company_name, AVG(tbl_works.salary) as company_avg_salary FROM tbl_works -- responsible to generate table containing average salary of all company
    GROUP BY company_name
    ORDER BY AVG(tbl_works.salary) ASC)  AS tbl_der_avg_salary
    WHERE company_avg_salary  <  -- comparison of salary of derived average table (tbl_der_avg_salary).
    (SELECT AVG(salary) FROM tbl_works WHERE tbl_works.company_name = "First Bank Corporation") -- to generate the avergae salary of first bank corporation.
    ;
    
    
-- Question no. 3
-- Ques 3.a)
	UPDATE tbl_employee 
	SET city = 'Newton' WHERE employee_name ='Jones';
    
-- Ques 3.b)
	UPDATE tbl_works 
    SET salary = salary + 0.10*salary WHERE company_name= "First Bank Corporation";
    
-- Ques 3.c)
	UPDATE tbl_works
    SET salary= salary + 0.10*salary 
    WHERE employee_name IN (SELECT manager_name FROM tbl_manages);
	
-- Ques 3.d)
	UPDATE works w
	SET salary = 
		CASE 
			WHEN salary * 1.1 <= 100000 THEN salary * 1.1
			ELSE salary * 1.03
		END
	WHERE employee_name IN (SELECT manager_name FROM tbl_manages);
	
-- Ques 3.e)
	DELETE FROM tbl_works WHERE company_name = "Small Bank Corporation";


	
    
   
        
        
        
        
        
        


