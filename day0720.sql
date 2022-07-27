SELECT * FROM EX2_10;
-- SELECT 문 
--p.92
--급여가 5000이 넘는 사원번호와 사원명 조회

SELECT  employee_id, EMP_NAME
 FROM   employees
 WHERE  salary > 5000
   AND  job_id = 'IT_PROG'
 ORDER BY employee_id;

--급여가 5000 이상, job_id, IT_PROG 사원 조회
-- Select rows from a Table

SELECT EMPLOYEE_ID
      ,EMP_NAME
      ,JOB_ID
      ,salary
FROM EMPLOYEES
WHERE salary > 5000
    OR job_id = 'IT_PROG'
ORDER BY employee_id;

--테이블에 별칭 줄 수 있음
SELECT
 -- a 테이블에서 옴 (=employees)
 a.employee_id, a.emp_name, a.department_id,
 --b.테이블에서 옴 (=departments)
 b.department_name
 FROM
    employees a,
    departments b 
WHERE a.department_id = b.department_id;

SELECT * FROM DEPARTMENTS

--INSERT 문 
-- 4교시에 실습

-- p101
--Merge 
-- 조건을 비교해서 테이블에 해당 조건에 맞는 데이터 없으면 추가 
-- 있으면 UPDATE문을 수행하다.


create table ex3_3(
    employee_id NUMBER
    , bonus_amt NUMBER DEFAULT 0

) ;

    INSERT INTO ex3_3 (employee_id)
    SELECT e.employee_id
      FROM employees e, sales s
     WHERE e.employee_id = s.employee_id
       AND s.SALES_MONTH BETWEEN '200010' AND '200012'
     GROUP BY e.employee_id;

SELECT * FROM ex3_3 order by employee_id;

-- Select rows from a Table

SELECT 
  EMPLOYEE_ID
  , MANAGER_ID
  , SALARY
  , salary * 0.01
FROM employees
WHERE employee_id NOT IN (SELECT EMPLOYEE_ID
                        FROM ex3_3)
    AND manager_id = 146;

-- MERGE를 통해서 작성
-- 관리자 사번 148인 것 중, ex3_3 테이블에 없는
-- 사원의 사번, 관리자 사번, 급여, 급여 * 0.001 조회 
-- ex3_3 테이블의 160번 사원의 보너스 금액은 7.5로 신규 입력 AMOUNT_SOLD

SELECT * FROM ex3_3;

-- 서브쿼리 개념 : 메인 쿼리 안에 추가된 쿼리 
-- UPDATE & INSERT 구분 
-- 두개의 테이블 조인
MERGE INTO ex3_3 d
    USING (select employee_id, salary, MANAGER_ID
            FROM EMPLOYEES
           WHERE manager_id = 146) b
        ON (d.employee_id = b.employee_id)
    WHEN MATCHED THEN  
        UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01
    WHEN NOT MATCHED THEN
        INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary *.001)
        WHERE (b.salary < 8000);

SELECT *
    FROM ex3_3
ORDER BY employee_id;

-- p 106
--테이블 삭제 
DELETE ex3_3;
SELECT * FROM ex3_3 ORDER BY employee_id;

select PARTITION_NAME
    FROM USER_TAB_PARTITIONS
WHERE table_name = 'SALES';
-- p107
-- commit & rollback 
-- commit은 변경한 데이터를 데이터베이스에 마지막으로 반영
-- Rollback은 그 반대로 변경한 데이터를 변경하기 이전 상태로 되돌리느 역할 

create TABLE ex3_4(
    employee_id NUMBER);

INSERT INTO ex3_4 VALUES (100);

select * 
    from ex3_4;


commit;

-- p.109
TRUNCATE TABLE ex3_4;
rollback;

select * from employees

 SELECT ROWNUM, employee_id
      FROM employees
     WHERE ROWNUM < 5;

-- 연산자 
-- Operator 연산 수행 
-- 수식 연산자 & 분자 연산자 
-- '||' 두 문자를 붙이는 연결 연산자
SELECT employee_id || '-' || emp_name AS employee_info
  FROM employees 
WHERE ROWNUM < 5;

--표현식 
-- 조건문, if 조건문 (PL/SQL)
-- CASE 조건식
-- Select rows from a Table

SELECT 
    EMPLOYEE_ID
    , SALARY
    , CASE WHEN salary <= 5000 THEN 'C 등급'
         WHEN salary > 5000 AND salary <= 15000 THEN 'B등급'
         ELSE'A등급'
    END AS salary_grade
FROM employees; 

-- 조건식
-- TRUE,FALSE, UNKNOWN 세가지 타입으로 반환
-- 비교 조건식
-- 분석가, DB 데이터를 추출할 시, 서브쿼리 

SELECT 
    employee_id
    , SALARY
    FROM employees 
    WHERE salary = ANY(2000,3000, 4000)
    ORDER BY employee_id;

-- ANY -> OR 연산자 변환
-- Select rows from a Table

SELECT employee_id,
  SALARY
FROM employees
WHERE salary = 2000 or salary = 3000 or salary = 4000
order by employee_id;

SELECT employee_id, 
  salary
FROM employees
WHERE salary = ALL (2000, 3000, 4000)
ORDER BY employee_id;

SELECT employee_id, SALARY
    FROM employees
WHERE NOT(salary >= 2500)
ORDER BY employee_id;

--NULL 조건식

--IN 조건식
select employee_id, SALARY
    FROM EMPLOYEES
WHERE salary in (2000, 3000, 4000)
order by employee_id;

-- NOT IN
select employee_id, SALARY
    FROM EMPLOYEES
WHERE salary NOT in (2000, 3000, 4000)
order by employee_id;

-- EXISTS 조건식
-- 서브쿼리만 올 수 있음.

select department_id, DEPARTMENT_NAME
    from departments a
    where EXISTS( select *
                    from employees b
                    where a.department_id = b.department_id
                    and b.salary > 3000)
order by a.department_name;

select EMP_NAME
from EMPLOYEES
where emp_name like 'A%'
order by emp_name;

-- 4장 숫자 함수
-- p.125
select ABS(10), ABS(-10), ABS(-10.123)
from dual;

-- 내림
select round(10.123), round(10.541), round(11.001)
    FROM dual;

--trunc
--반올림 안함, 소수점 절삭, 자리수 지정 가능
select trunc(115.155), trunc(115.155, 1), trunc(115.155, 2), trunc(115.155, -2)
    from dual;

-- POWER
-- POWER 함수, SQRT
select power(3,2), power(3,3), power(3, 3.0001)
    from dual;

-- 제곱근 반환
select sqrt(2), sqrt(5), sqrt(9)
from dual;

-- 과거 : sql, db에서 자료를 조회 하는 등
-- 현재:sql -> 수학 & 통계 도구처럼 진화
-- 오라클 19c 부터 머신러닝 지원,

-- 문자열 데이터 전처리
-- 게임사,
-- 채팅 -> 문자 데이터

select initcap('never say goodbye'), initcap('never6say*good가bye')
 from dual;

 --LOWER 함수
 --매개변수로 들어오는 문자를 모두 소문자로, UPPDER 함수는 대문자로 반환
 select lower('NEVER SAY GOODBYE'), UPPER('never say goodbye')
 FROM DUAL;

 -- CONCAT(char1, char2), '||' 연산자와 비슷
 select concat('I have', ' A Dream'), 'I Have' || ' A Dream'
    FROM DUAL;

-- SUBSTR
-- 문자열 자르기
select substr('ABCDEFG', 1, 4), SUBSTRB('ABCDEFG', 1, 4)
from dual;

select substr('ABCDEFG', 1, 6), SUBSTRB('가나다라마바사', 1, 6)
from dual;

select ltrim('ABCDEFGABC', 'ABC'),
       ltrim('가나다라', '가'),
       RTRIM('ABCDEFGABC', 'ABC'),
       RTRIM('가나다라', '라')
    FROM DUAL;

-- LPAD, RPAD

-- 날짜 함수 (p.138)
select sysdate, systimestamp from dual;

-- ADD_MONTHS
-- ADD_MONTHS 함수, 매개변수로 들어온 날짜, integer 만큼 일을 더함
select add_months(sysdate, -1) from dual;

select months_between(sysdate, add_months(sysdate, 1)) mon1,
       months_between(add_months(sysdate, 1), sysdate) mon2
from dual;

--last day
select last_day(sysdate) from dual;

--NEXT_DAY
SELECT NEXT_DAY(SYSDATE,'FRIDAY')
    FROM DUAL;

--to_char(숫자 혹은 날짜)
select to_char(123456789, '999,999,999')
    FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')
    FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'D') FROM DUAL;

-- 문자를 숫자로 변환
SELECT TO_NUMBER('123456')
FROM DUAL;

-- NULL 관련 함수
--NVL:표현식 1이 NULL일 때, 표현식 2르 반환함
select NVL(manager_id, employee_id)
    FROM EMPLOYEES
WHERE manager_id IS NULL;

-- NVL2: 표현식1이 NULL이 아니면, 표현식2 출력,
         표현식2가 NULL이면, 표현식3을 출력

SELECT EMPLOYEE_ID,
       NVL2(commission_pct, salary + (salary *commission_pct), salary) AS salary2
       FROM employees
       WHERE employee_id IN (118, 179);

-- COALESCE (expr1, expr2,)
-- 매개변수로 들어오는 표현식에서 NULL이 아닌 첫 번째 표현식 반환
SELECT employee_id, salary, COMMISSION_PCT,
       COALESCE (salary * COMMISSION_PCT, salary) AS salary2
    FROM employees;

-- NULLIF (expr, expr2)
SELECT employee_id, 
       TO_CHAR(start_date, 'yyyy') start_year,
       TO_CHAR(end_date, 'YYYY') end_year,
       NULLIF(TO_CHAR(end_date, 'YYYY'), TO_CHAR(start_date, 'YYYY')) nullif_year
    FROM job_history;

-- DECODE

    SELECT prod_id,
             DECODE(channel_id, 3, 'Direct',
                                9, 'Direct',
                                5, 'Indirect',
                                4, 'Indirect',
                                   'Others')  decodes
       FROM sales
      WHERE rownum < 10;

SELECT GREATEST ( '빌게이츠','스티브 잡스','차형주'),
        LEAST ('빌게이츠','스티브 잡스','차형주')
FROM DUAL;