 SELECT table_name FROM user_tables;
 
 
 -- SQL vs PL/SQL
 --SQL (분석가(90%) + 개발자(30%)
 -- 프로그래밍 성격이 얕음
 --PL/SQL (분석가(10%) + 개발자(70%) + DBA) 
 --basics: table, view --> PL/SQL function, procedure 
 
 -- 테이블 생성
 /*
 CREATE TABLE 테이블명(
    컬럼1 컬럼1_데이터타입 결측치 허용유무,
    
)
*/  
-- P.50 
CREATE TABLE ex2_1(
    COLUMN1     CHAR(10),
    COLUMN2     VARCHAR2(10),
    COLUMN3     VARCHAR2(10),
    COLUMN4     NUMBER
);
 
-- 데이터 추가 
INSERT INTO ex2_1 (column1, column2) VALUES ('abc', 'abc');

-- 테이블 생성, 추가, 삭제, 수정 코드를
-- 파이썬이나, JAVA에서 다 쓸 코드를... 

-- 데이터 조회 
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
    
INSERT INTO ex2_2 (column3) VALUES('홍길동');

SELECT column3, LENGTH(column3) AS len3, LENGTHB(column3) AS bytelen
    FROM ex2_2;
    
-- 숫자 데이터 타입 
    
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

-FLOAT 형
CREATE TABLE ex2_4(
       COL_FLOT1 FLOAT(32),
       COL_FLOT2 FLOAT
);

INSERT INTO ex2_4 (col_flot1, col_flot2) VALUES (1234567891234, 1234567891234);

    
-- 날짜 데이터 타입
CREATE TABLE ex2_5(
    COL_DATE       DATE,
    COL_TIMESTAMP  TIMESTAMP
);

INSERT INTO ex2_5 VALUES(SYSDATE, SYSTIMESTAMP);

SELECT *  FROM ex2_5;

-- NULL: 값이 없음 

-- p.60 
CREATE TABLE ex2_6(
    COL_NULL        VARCHAR2(10),
    COL_NOT_NULL    VARCHAR2(10) NOT NULL
);
-- 에러 발생
INSERT INTO ex2_6 VALUES ('AA', '');

-정상적으로 삽입 됨
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


-- 기본키
-- Primary Key 
-- UNIQUE(중복허용), NOT NULL(결측치 허용 안됨)
-- 테이블 당 1개의 기본키만 설정 가능 

CREATE TABLE ex2_8(
        COL1    VARCHAR2(10) PRIMARY KEY,
        COL2    VARCHAR2(10)
);

--INSERT INTO ex2_8 VALUES('', 'AA');
INSERT INTO ex2_8 VALUES('AA', 'AA');

-- 외래키 : 테이블 간의 참조 데이터 무결성 위한 제약 조건 
-- 참조 무결성을 보장한다.
-- 잘못된 정보가 입력되는 것을 방지함 

-- Check 
-- 컬럼에 입력되는 데이터를 체크해 특정 조건에 맞는 데이터만 
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

-- 오류
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

-- 테이블 변경 
-- ALTAR TABLE 
ALTER TABLE ex2_10 RENAME COLUMN Col1 TO Col11;
SELECT * FROM ex2_10;

DESC ex2_10;

ALTER TABLE ex2_10 MODIFY Col2 VARCHAR2(30);

DESC ex2_10;

-- 신규 칼럼 추가 
ALTER TABLE ex2_10 ADD Col3 NUMBER; 
DESC ex2_10;

--컴럼 삭제 
ALTER TABLE ex2_10 DROP COLUMN Col3;
DESC ex2_10;

--제약조건 추가 
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

-뷰 생성 
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
  
--데이터 수정 

--데이터 삭제 

--테이블 삭제 

