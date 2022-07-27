 SELECT table_name FROM user_tables;
 
 
 -- SQL vs PL/SQL
 --SQL (�м���(90%) + ������(30%)
 -- ���α׷��� ������ ����
 --PL/SQL (�м���(10%) + ������(70%) + DBA) 
 --basics: table, view --> PL/SQL function, procedure 
 
 -- ���̺� ����
 /*
 CREATE TABLE ���̺��(
    �÷�1 �÷�1_������Ÿ�� ����ġ �������,
    
)
*/  
-- P.50 
CREATE TABLE ex2_1(
    COLUMN1     CHAR(10),
    COLUMN2     VARCHAR2(10),
    COLUMN3     VARCHAR2(10),
    COLUMN4     NUMBER
);
 
-- ������ �߰� 
INSERT INTO ex2_1 (column1, column2) VALUES ('abc', 'abc');

-- ���̺� ����, �߰�, ����, ���� �ڵ带
-- ���̽��̳�, JAVA���� �� �� �ڵ带... 

-- ������ ��ȸ 
SELECT column1, LENGTH(column1) as len1 
FROM ex2_1
-- p.53
CREATE TABLE ex2_2( 
    COLUMN1 VARCHAR2(3), --default value is byte 
    COLUMN2 VARCHAR2(3 byte), 
    COLUMN3 VARCHAR2(3 char)
);

--add data
INSERT INTO ex2_2 VALUES('abc', 'abc', 'abc');

SELECT column1, LENGTH(column1) AS len1, 
       column2, LENGTH(column2) AS len2,
       column3, LENGTH(column3) AS len3
    FROM ex2_2;
    
INSERT INTO ex2_2 (column3) VALUES('ȫ�浿');

SELECT column3, LENGTH(column3) AS len3, LENGTHB(column3) AS bytelen
    FROM ex2_2;
    
-- ���� ������ Ÿ�� 
    
CREATE TABLE ex2_3(
    COL_INT INTEGER,
    COL_DEC DECIMAL, 
    COL_NUM NUMBER
);

SELECT column_id
       , column_name
       , data_type
       , data_length
FROM user_tab_cols
WHERE table_name = 'EX2_3'
ORDER BY column_id;

-FLOAT ��
CREATE TABLE ex2_4(
       COL_FLOT1 FLOAT(32),
       COL_FLOT2 FLOAT
);

INSERT INTO ex2_4 (col_flot1, col_flot2) VALUES (1234567891234, 1234567891234);

    
-- ��¥ ������ Ÿ��
CREATE TABLE ex2_5(
    COL_DATE       DATE,
    COL_TIMESTAMP  TIMESTAMP
);

INSERT INTO ex2_5 VALUES(SYSDATE, SYSTIMESTAMP);

SELECT *  FROM ex2_5;

-- NULL: ���� ���� 

-- p.60 
CREATE TABLE ex2_6(
    COL_NULL        VARCHAR2(10),
    COL_NOT_NULL    VARCHAR2(10) NOT NULL
);
-- ���� �߻�
INSERT INTO ex2_6 VALUES ('AA', '');

-���������� ���� ��
INSERT INTO ex2_6 VALUES ('AA', 'BB');
SELECT * FROM ex2_6;

--p.61
SELECT constraint_name, constraint_type, table_name, search_condition
    FROM user_constraints
WHERE table_name = 'EX2_6'; 


--UNIQUE
--allow duplicates 
CREATE TABLE ex2_7(
    COL_UNIQUE_NULL       VARCHAR2(10) UNIQUE
    , COL_UNIQUE_NNULL    VARCHAR2(10) UNIQUE NOT NULL
    , COL_UNIQUE          VARCHAR2(10)
    , CONSTRAINTS unique_nm1 UNIQUE (COL_UNIQUE)
);

SELECT constraint_name
       , constraint_type
       , table_name
       , search_condition
FROM user_constraints
WHERE table_name = 'EX2_7';

INSERT INTO ex2_7 VALUES('', 'BB', 'BB');

INSERT INTO ex2_7 VALUES('AA', 'AA', 'AA');

INSERT INTO ex2_7 VALUES('', 'CC', 'CC'); 


-- �⺻Ű
-- Primary Key 
-- UNIQUE(�ߺ����), NOT NULL(����ġ ��� �ȵ�)
-- ���̺� �� 1���� �⺻Ű�� ���� ���� 

CREATE TABLE ex2_8(
        COL1    VARCHAR2(10) PRIMARY KEY,
        COL2    VARCHAR2(10)
);

--INSERT INTO ex2_8 VALUES('', 'AA');
INSERT INTO ex2_8 VALUES('AA', 'AA');

-- �ܷ�Ű : ���̺� ���� ���� ������ ���Ἲ ���� ���� ���� 
-- ���� ���Ἲ�� �����Ѵ�.
-- �߸��� ������ �ԷµǴ� ���� ������ 

-- Check 
-- �÷��� �ԷµǴ� �����͸� üũ�� Ư�� ���ǿ� �´� �����͸� 
CREATE TABLE ex2_9(
        num1            NUMBER
        ,   CONSTRAINTS check1 CHECK (num1 BETWEEN 1 AND 9)
        ,   gender          VARCHAR2(10)
        CONSTRAINTS check2  CHECK (gender IN ('MALE', 'FEMALE'))
);

SELECT constraint_name
       , constraint_type
       , table_name
       , search_condition
FROM user_constraints
WHERE table_name = 'EX2_9';

-- ����
INSERT INTO ex2_9 VALUES (10, 'MAN');
INSERT INTO ex2_9 VALUES (10, 'FEMALE');
INSERT INTO ex2_9 VALUES (5, 'FEMALE');

--Default
CREATE TABLE ex2_10(
    Col1    VARCHAR2(10) NOT NULL
    ,  Col2 VARCHAR2(10) NULL
    ,  Create_date DATE DEFAULT SYSDATE
    , Create_timestamp DATE DEFAULT SYSTIMESTAMP
);

INSERT INTO ex2_10 (col1, col2) VALUES ('AA', 'BB');

SELECT *
    FROM ex2_10;

alter session set nls_date_format='YYYY/MM/DD HH24:MI:SS';
DROP TABLE ex2_10;

-- ���̺� ���� 
-- ALTAR TABLE 
ALTER TABLE ex2_10 RENAME COLUMN Col1 TO Col11;
SELECT * FROM ex2_10;

DESC ex2_10;

ALTER TABLE ex2_10 MODIFY Col2 VARCHAR2(30);

DESC ex2_10;

-- �ű� Į�� �߰� 
ALTER TABLE ex2_10 ADD Col3 NUMBER; 
DESC ex2_10;

--�ķ� ���� 
ALTER TABLE ex2_10 DROP COLUMN Col3;
DESC ex2_10;

--�������� �߰� 
ALTER TABLE ex2_10 ADD CONSTRAINTS pk_ex2_10 PRIMARY KEY(col11);

ALTER TABLE ex2_10 DROP CONSTRAINTS pk_ex2_10;

SELECT constraint_name
       , constraint_type
       , table_name
       , search_condition
FROM user_constraints
WHERE table_name = 'EX2_10';

-- copy table 
CREATE TABLE ex2_9_1 AS 
SELECT * FROM ex2_9; 

DESC ex2_9_1;

-�� ���� 
CREATE OR REPLACE VIEW emp_dept_v1 AS 
SELECT a.employee_id
       , a.emp_name
       , a.department_id
       , b.department_name
 FROM employees a,
      departments b
WHERE a.department_id = b.department_id;

SELECT * 
  FROM emp_dept_v1;
  
--������ ���� 

--������ ���� 

--���̺� ���� 

