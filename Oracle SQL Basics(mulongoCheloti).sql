-- The User is MULONGOCHELOTI
SELECT NAME, CREATED, OPEN_MODE, PLATFORM_NAME, CDB FROM V$DATABASE;
SHOW CON_NAME;
SELECT USERNAME FROM DBA_USERS;
SET SERVEROUTPUT ON;

DECLARE 
    message varchar2(20):='Hello world!';
BEGIN
    dbms_output.put_line(message);
END;
/

-- ORACLE does not provide IF EXISTS Clause in the DROP TABLE Statement
-- But you can use PL/SQL block to implement this functionality

-- METHOD 1 : Using a count variable and IF statement
DECLARE cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO cnt FROM USER_TABLES WHERE TABLE_NAME='STUDENT';
    IF cnt <> 0 THEN
        EXECUTE IMMEDIATE 'DROP TABLE Student';
    ELSE
        dbms_output.put_line('The table does not exist');
    END IF;
END;
/

-- METHOD 2 : Using Exceptions: just run the DROP TABLE Statement and suppress the errors
-- This approach works faster and requires less resources
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Results';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE Student(
    RegNo NUMBER(10) NOT NULL,
    Stud_Name VARCHAR2(20) NOT NULL unique,
	DateOfBirth DATE, 
	Residence CHAR(15) DEFAULT 'NAIROBI',
    CONSTRAINT check_date CHECK (DateOfBirth <= '01-JAN-2000'),/* Date format is diff in t-sql and pl/sql. In T-SQL we can use /, JAN, etc */
	CONSTRAINT PRI_KEY PRIMARY KEY (RegNo)
    );
    
CREATE TABLE Results (
    STUD_ID NUMBER(10) NOT NULL,
	MATHS NUMBER(2) CHECK (MATHS<=99 AND MATHS>0),
    LANGUAGES NUMBER(2) CHECK (LANGUAGES<=99 AND LANGUAGES>0),
    SCIENCE NUMBER(2) CHECK (SCIENCE<=99 AND SCIENCE>0),
    SOCIALST_RE NUMBER(2) CHECK (SOCIALST_RE<=99 AND SOCIALST_RE>0)
    );
    
ALTER TABLE Results ADD CONSTRAINT FKID FOREIGN KEY(STUD_ID) REFERENCES Student(RegNo);

-- We can also create a foreign key with more than one field as in the example below
-- ALTER TABLE products ADD CONSTRAINT fk_supplier FOREIGN KEY (supplier_id, supplier_name)
-- REFERENCES supplier (supplier_id, supplier_name) ON DELETE CASCADE;

DESC Student;
DESCRIBE Results;

-- PL/SQL Keywords are NOT CASE-SENSITIVE except within string and character literals
-- This is due to the fact that ORACLE internally stores objects in the data dictionary in uppercase
-- String literals are strictly enclosed under single quotes

SELECT * FROM USER_TABLES  WHERE TABLE_NAME IN ('STUDENT','RESULTS');

SELECT * FROM USER_TABLES  WHERE TABLE_NAME='Student';
-- No match since ORACLE stored the table name as 'STUDENT' while you have searched for 'Student'

-- Single ALTER Statement to add multiple columns to the table
ALTER TABLE Student ADD ( Home_Addr VARCHAR2(20) DEFAULT 'New York', Email VARCHAR2(30) );

DESC Student;

SELECT * FROM ALL_CONS_COLUMNS WHERE TABLE_NAME = 'STUDENT' OR TABLE_NAME = 'RESULTS';
-- ALL_CONS_COLUMNS describes columns that are accessible to the current user and that are specified in constraints.

-- Single ALTER statment to modify datatype of two of your columns in your table
ALTER TABLE Student
	MODIFY ( Home_Addr VARCHAR2(25), Email CHAR(30) );
    
-- Renaming columns
ALTER TABLE Student
    RENAME COLUMN Home_Addr TO Permanent_Address;
    
ALTER TABLE Student    
    RENAME COLUMN Email TO Student_Email;
    
-- Renaming a table
-- ALTER TABLE Student RENAME TO Students;

-- Changing columns and table names has great effect on stored procedures, views, references and functions hence it is advised not to modify them once created


DESC STUDENT;

ALTER TABLE Student
	DROP COLUMN Permanent_Address;
    
ALTER TABLE Student    
    DROP COLUMN Student_Email;
    
-- We can now drop column from table since it is owned by mulongoCheloti and NOT SYS

  
SELECT * FROM USER_USERS;
-- Describes the current user:

INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Residence) VALUES (811, 'PAUL MULONGO', 'JUN-21-1999', 'BUNGOMA');

INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Residence) VALUES (819, 'LAURA MUTHEU','09-19/1999','KITUI');

INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Residence) VALUES (812, 'RANDOLPH KITILA', 'APR-20-1998','NAIROBI');
		
INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Residence) VALUES (814, 'MARY WANJIKU', 'MAR-24-1997', 'THIKA');
		
INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Residence) VALUES (816, 'RONY WAIREGA', 'AUG/20/1998', 'LIMURU');
		
INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Residence) VALUES (817, 'ELVIS ODUOR','09-13-1997','KISUMU');
		
INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Residence) VALUES (818, 'ALLAN PETER','FEB-14-1998','LIMURU');
            
INSERT INTO Student (RegNo, DateOfBirth, Stud_Name, Residence) VALUES (813, 'FEB-01-2000', 'BRIAN WAEMA', 'MAKINDU');
INSERT INTO Student (RegNo, DateOfBirth, Stud_Name, Residence) VALUES (815, 'MAY-01-2001', 'BRIDGET MWENGA', 'MACHAKOS');
INSERT INTO Student (RegNo, DateOfBirth, Stud_Name, Residence) VALUES (820, 'AUG-08-2000', 'SHARON GITOGO','THIKA');

-- Error report -ORA-02290: check constraint (MULONGOCHELOTI.CHECK_DATE) violated

ALTER TABLE Student DROP CONSTRAINT CHECK_DATE;


SELECT * FROM Student;

-- Inserting multiple rows using INSERT ALL
INSERT ALL
    INTO Results (STUD_ID, LANGUAGES, SOCIALST_RE, MATHS, SCIENCE) VALUES (811, 60,68,58,94)
    INTO Results (STUD_ID, LANGUAGES, SOCIALST_RE, MATHS, SCIENCE) VALUES (813, 60,45,80,58)
    INTO Results (STUD_ID, LANGUAGES, SOCIALST_RE, MATHS, SCIENCE) VALUES (814, 77,70,68,88)
SELECT * FROM DUAL;

SELECT * FROM Results; SELECT * FROM Student;

-- Limiting responses using FETCH [FIRST | NEXT] [number | percent] ROWS [ONLY | WITH  TIES]
    -- WITH TIES returns additional rows with the same sort key as the last row fetched.
    -- If you use WITH TIES, you must specify an ORDER BY clause otherwise the query will not return the additional rows
-- In SQL we use LIMIT and OFFSET
-- In T-SQL we use TOP number | percent Clause

SELECT * FROM Student FETCH NEXT 3 ROWS ONLY;

SELECT * FROM Student FETCH FIRST 50 PERCENT ROWS ONLY;

SELECT * FROM Student
    ORDER BY RESIDENCE
    FETCH NEXT 4 ROWS WITH TIES;
    -- Notice that the additional row has the sme value in RESIDENCE Column as the row 4
    
SELECT * FROM Student
    OFFSET 2 ROWS
    FETCH NEXT 3 ROWS ONLY;

SELECT * FROM Student LEFT JOIN Results ON Student.RegNo = Results.STUD_ID;

DELETE FROM Student WHERE RegNo = 811;
-- Error report -ORA-02292: integrity constraint (MULONGOCHELOTI.FKID) violated - child record found

-- SOLUTION 1: To delete from the parent table first delete its children in the child table
DELETE FROM Results WHERE STUD_ID = 811;
DELETE FROM Student WHERE RegNo = 811;

-- SOLUTION 2: We can use ON DELETE CASCADE when defining the FOREIGN KEY Constraint
-- ALTER TABLE Results ADD CONSTRAINT FKID FOREIGN KEY(STUD_ID) REFERENCES Student(RegNo) ON DELETE CASCADE;

-- SOLUTION 3; Since we can edit a constraint we just drop the constraint FKID and create another with the necessary adjustments
ALTER TABLE Results DROP CONSTRAINT FKID;
ALTER TABLE Results ADD CONSTRAINT FKID FOREIGN KEY(STUD_ID) REFERENCES Student(RegNo) ON DELETE CASCADE;
    
-- To find the affected table by ON DELETE CASCADE action
-- SELECT * FROM dba_constraints WHERE R_OWNER='owner of the primary key' AND R_CONSTRAINT_NAME='Name of the primary key' AND DELETE_RULE='CASCADE';

BEGIN
    EXECUTE IMMEDIATE 'DROP VIEW Born_90s';
    EXCEPTION
        WHEN OTHERS THEN NULL;
END;
/

CREATE VIEW Born_90s AS SELECT Stud_Name, Residence FROM Student WHERE EXTRACT(YEAR FROM DateOfBirth)<2000;

SELECT * FROM Born_90s;

-- CASE Statements
SELECT Stud_Name, Residence,
	CASE
		WHEN Residence = 'NAIROBI' THEN 'In Nairobi'
		WHEN Residence IN ('THIKA', 'LIMURU', 'KITUI') THEN 'Within Outskirts of Nairobi'
		ELSE 'Upcountry'
	END AS Availability
	FROM Born_90s
	ORDER BY Stud_Name DESC;
    
DROP VIEW Born_90s;

SELECT SYSDATE FROM DUAL;

CREATE VIEW Age_view AS SELECT Stud_Name, (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM DateOfBirth)) AS Age FROM Student WHERE EXTRACT(YEAR FROM DateOfBirth)<2000;
CREATE VIEW Age_view_1 AS SELECT Stud_Name, (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM DateOfBirth)) AS Age FROM Student WHERE EXTRACT(YEAR FROM DateOfBirth)=2000;
CREATE VIEW Age_view_2 AS SELECT Stud_Name, (2022-EXTRACT(YEAR FROM DateOfBirth)) AS Age FROM Student WHERE EXTRACT(YEAR FROM DateOfBirth)>2000;

SELECT * FROM Age_view; SELECT * FROM Age_view_1; SELECT * FROM Age_view_2;

DROP VIEW Age_view;

-- All views accessible to the current user
SELECT VIEW_NAME FROM ALL_VIEWS
    WHERE OWNER='MULONGOCHELOTI';


SELECT VIEW_NAME FROM ALL_VIEWS;
	-- Gets all the views

-- LIKE-- %(Any no. of characters) and _(a single character)

SELECT * FROM Student WHERE Stud_Name LIKE '%A';

SELECT * FROM Student WHERE Stud_Name LIKE 'R%';

SELECT * FROM Student WHERE Stud_Name LIKE '_a%';

SELECT * FROM Student WHERE Stud_Name LIKE '_A%';

DELETE FROM Student WHERE Residence LIKE 'MA%'; -- ON DELETE CASCADE applied


UPDATE Student SET Stud_Name='KITILA RANDO' WHERE RegNo=812;

DELETE FROM Student WHERE Stud_Name = 'LAURA MUTHEU';

SELECT * FROM mulongocheloti.Student;
DELETE FROM Student;
-- Deletes all records of the specified table hence the result records matching are also deleted due to the CASCADE Rule

SELECT * FROM Student;
SELECT * FROM Results;

ALTER TABLE Student 
	RENAME COLUMN Residence TO Town;
    
ALTER TABLE Student
    MODIFY Town VARCHAR(25);
    
INSERT ALL
    INTO Student (RegNo, Stud_Name, DateOfBirth, Town) VALUES (811, 'PAUL MULONGO', 'JUN-21-1999', 'BUNGOMA')
    INTO Student (RegNo, Stud_Name, DateOfBirth, Town) VALUES (819, 'LAURA MUTHEU','09-19/1999','KITUI')
    INTO Student (RegNo, Stud_Name, DateOfBirth, Town) VALUES (812, 'RANDOLPH KITILA', 'APR-20-1998','NAIROBI')
    INTO Student (RegNo, Stud_Name, DateOfBirth, Town) VALUES (814, 'MARY WANJIKU', 'MAR-24-1997', 'THIKA')
	INTO Student (RegNo, Stud_Name, DateOfBirth, Town) VALUES (816, 'RONY WAIREGA', 'AUG/20/1998', 'LIMURU')
	INTO Student (RegNo, Stud_Name, DateOfBirth, Town) VALUES (817, 'ELVIS ODUOR','09-13-1997','KISUMU')
	INTO Student (RegNo, Stud_Name, DateOfBirth, Town) VALUES (818, 'ALLAN PETER','FEB-14-1998','LIMURU')
    INTO Student (RegNo, DateOfBirth, Stud_Name, Town) VALUES (813, 'FEB-01-2000', 'BRIAN WAEMA', 'MAKINDU')
    INTO Student (RegNo, DateOfBirth, Stud_Name, Town) VALUES (815, 'MAY-01-2001', 'BRIDGET MWENGA', 'MACHAKOS')
    INTO Student (RegNo, DateOfBirth, Stud_Name, Town) VALUES (820, 'AUG-08-2000', 'SHARON GITOGO','THIKA')
    INTO Results (STUD_ID, LANGUAGES, SOCIALST_RE, MATHS, SCIENCE) VALUES (811, 60,68,58,94)
    INTO Results (STUD_ID, LANGUAGES, SOCIALST_RE, MATHS, SCIENCE) VALUES (813, 60,45,80,58)
    INTO Results (STUD_ID, LANGUAGES, SOCIALST_RE, MATHS, SCIENCE) VALUES (814, 77,70,68,88)
SELECT * FROM DUAL;
    

-- Adding the DEFAULT Constraint to already created table column
ALTER TABLE Student
	MODIFY DateOfBirth DEFAULT 'JAN-01-2000';
    
-- In T-SQL we write
	-- ADD CONSTRAINT <constraint_name> DEFAULT <default_value> FOR <cloumn_name>;
    
-- In SQL we write
	-- ALTER <column_name> SET DEFAULT <default_value>;

INSERT INTO Student(RegNo, Stud_Name) VALUES (822, 'ABEL BARASA');

SELECT * FROM Student;

-- Disabling | Enabling  | Dropping a unique constraint
-- ALTER TABLE table_name ENABLE CONSTRAINT constraint_name;
-- ALTER TABLE table_name DISABLE CONSTRAINT constraint_name;
-- ALTER TABLE table_name DROP CONSTRAINT constraint_name;

-- For the DEFAULT Constraint if NOT named we can't drop it but only nullify
ALTER TABLE Student 
    MODIFY DateOfBirth DEFAULT NULL;
    

INSERT INTO Student(RegNo, Stud_Name, DateOfBirth)
	VALUES (823, 'RUTH MUSYOKA','MAY/4/2002');

SELECT * FROM Student;

SELECT Stud_Name, EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM DateOfBirth) AS Age FROM Student;

-- Add a calculated column
ALTER TABLE Student
	ADD Age NUMBER GENERATED ALWAYS AS (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM DateOfBirth))VIRTUAL;

ALTER TABLE Student 
	ADD (Position NUMBER NOT NULL, Prize DECIMAL(10,2) NOT NULL);

/* Error report -ORA-01758: table must be empty to add mandatory (NOT NULL) column */

DELETE FROM Student;

INSERT ALL
    INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (811, 'PAUL MULONGO', 'JUN-21-1999', 'BUNGOMA',1,5000)
    INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (819, 'LAURA MUTHEU','09-19/1999','KITUI',10,200)
    INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (812, 'RANDOLPH KITILA', 'APR-20-1998','NAIROBI',5,1500)
    INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (814, 'MARY WANJIKU', 'MAR-24-1997', 'THIKA',7,800)
	INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (816, 'RONY WAIREGA', 'AUG/20/1998', 'LIMURU',2,4000)
	INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (817, 'ELVIS ODUOR','09-13-1997','KISUMU',4,2000)
	INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (818, 'ALLAN PETER','FEB-14-1998','LIMURU',6,1000)
    INTO Student (RegNo, DateOfBirth, Stud_Name, Town, Position, Prize) VALUES (813, 'FEB-01-2000', 'BRIAN WAEMA', 'MAKINDU',3,3000)
    INTO Student (RegNo, DateOfBirth, Stud_Name, Town, Position, Prize) VALUES (815, 'MAY-01-2001', 'BRIDGET MWENGA', 'MACHAKOS',9,450)
    INTO Student (RegNo, DateOfBirth, Stud_Name, Town, Position, Prize) VALUES (820, 'AUG-08-2000', 'SHARON GITOGO','THIKA',8,650)
    INTO Results (STUD_ID, LANGUAGES, SOCIALST_RE, MATHS, SCIENCE) VALUES (811, 60,68,58,94)
    INTO Results (STUD_ID, LANGUAGES, SOCIALST_RE, MATHS, SCIENCE) VALUES (813, 60,45,80,58)
    INTO Results (STUD_ID, LANGUAGES, SOCIALST_RE, MATHS, SCIENCE) VALUES (814, 77,70,68,88)
SELECT * FROM DUAL;


SELECT * FROM Student WHERE Prize>=1000 ORDER BY Position DESC;

ALTER TABLE Student ADD CONSTRAINT UniqConstraints UNIQUE(Position, Prize);

INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize)
	VALUES	(824, 'PAULINE MUSENYA', '1/6/98', 'WOTE',3,3000.00);

   -- Error report -ORA-00001: unique constraint (MULONGOCHELOTI.UNIQCONSTRAINTS) violated

ALTER TABLE Student DISABLE CONSTRAINT UniqConstraints;

SELECT * FROM Student 
    ORDER BY POSITION
    FETCH FIRST 3 ROWS WITH TIES;

SELECT COLUMN_NAME, NULLABLE, DATA_TYPE, DATA_LENGTH, DATA_DEFAULT FROM ALL_TAB_COLUMNS
    WHERE TABLE_NAME='STUDENT' AND OWNER='MULONGOCHELOTI';
-- equivalent to
DESC Student;

DELETE FROM Student;

ALTER TABLE Student ADD CONSTRAINT Prize_limit CHECK(Prize>100);

-- The CHECK Constraint enables a condition to check the value being entered into a record. If the condition evaluates to false, the record violates the
-- constraint and it is not entered into the table.

INSERT ALL
    INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (811, 'PAUL MULONGO', 'JUN-21-1999', 'BUNGOMA',1,5000)
    INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (819, 'LAURA MUTHEU','09-19/1999','KITUI',10,200)
    INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (812, 'RANDOLPH KITILA', 'APR-20-1998','NAIROBI',5,1500)
    INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (814, 'MARY WANJIKU', 'MAR-24-1997', 'THIKA',7,800)
	INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (816, 'RONY WAIREGA', 'AUG/20/1998', 'LIMURU',2,4000)
	INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (817, 'ELVIS ODUOR','09-13-1997','KISUMU',4,2000)
	INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize) VALUES (818, 'ALLAN PETER','FEB-14-1998','LIMURU',6,1000)
    INTO Student (RegNo, DateOfBirth, Stud_Name, Town, Position, Prize) VALUES (813, 'FEB-01-2000', 'BRIAN WAEMA', 'MAKINDU',3,3000)
    INTO Student (RegNo, DateOfBirth, Stud_Name, Town, Position, Prize) VALUES (815, 'MAY-01-2001', 'BRIDGET MWENGA', 'MACHAKOS',9,450)
    INTO Student (RegNo, DateOfBirth, Stud_Name, Town, Position, Prize) VALUES (820, 'AUG-08-2000', 'SHARON GITOGO','THIKA',8,650)
    INTO Results (STUD_ID, LANGUAGES, SOCIALST_RE, MATHS, SCIENCE) VALUES (811, 60,68,58,94)
    INTO Results (STUD_ID, LANGUAGES, SOCIALST_RE, MATHS, SCIENCE) VALUES (813, 60,45,80,58)
    INTO Results (STUD_ID, LANGUAGES, SOCIALST_RE, MATHS, SCIENCE) VALUES (814, 77,70,68,88)
SELECT * FROM DUAL;

INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize)
	VALUES	(825, 'PAULINE MUSENYA', '6/11/1998', 'WOTE',15,100.00);
-- Error report -ORA-02290: check constraint (MULONGOCHELOTI.PRIZE_LIMIT) violated

INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize)
	VALUES	(825, 'PAULINE MUSENYA', '6/11/1998', 'WOTE',15,100.01);

SELECT * FROM Student;

ALTER TABLE Student DROP CONSTRAINT Prize_limit;

-- Understanding DATE_FORMAT()
SELECT DateOfBirth, TO_DATE(DateOfBirth, '%MMDDYY') AS modifiedDate FROM student;
SELECT DateOfBirth, DATE_FORMAT(DateOfBirth, '%M-%y-%d') AS modifiedDate FROM student;
SELECT DateOfBirth, DATE_FORMAT(DateOfBirth, '%D %M, %Y') AS modifiedDate FROM student;

SELECT TO_DATE('070198', 'MMDDYY') FROM DUAL;
SELECT  EXTRACT( HOUR FROM TO_TIMESTAMP('2001/05/23 08:30:25', 'YYYY/MM/DD HH:MI:SS')) FROM DUAL;
-- TO_DATE() takes in a string and returns a date value
-- TO_TIMESTAMP() takes in a string and returns a timestamp

    
/* 
CREATE table statement that has a PRIMARY KEY column and have that column auto generate a value on INSERT.
*/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE testTable';
    EXCEPTION
        WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE testTable (ID Number GENERATED BY DEFAULT ON NULL AS IDENTITY,
                        Name VARCHAR2(20) NOT NULL
                         );
    -- The default initial value and interval values for auto increment identity columns equals to 1
  
 -- To change auto_increment initial and interval value use START WITH and INCREMENT BY Clauses
 BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE testTable1';
    EXCEPTION
        WHEN OTHERS THEN NULL;
END;
/
CREATE TABLE testTable1 (ID Number GENERATED BY DEFAULT ON NULL AS IDENTITY CACHE 50 START WITH 10 INCREMENT BY 5,
                         Name VARCHAR2(20) NOT NULL
                         );
                         
-- When you create an identity column, Oracle generate 20 auto increment values before hand for performance reasons
-- and ORACLE recommends to include CACHE Clause greater than the default of 20 to improve performance

