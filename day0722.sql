-- 198p 
-- 서브쿼리
-- SELECT, FROM, WHERE 
-- FROM : 인라인 뷰
-- 메인 쿼리 : 사원테이블에서는 id, name 출력
--                    부서테이블에서는 부서ID, 부서명 출력
--                     사원테이블의 급여가 기획부서의 평균급여보다 높은 사람
--                     a.salary > d.avg_salary
-- 서브쿼리 : 기획부서의 평균급여
SELECT 
    a.employee_id
    , a.emp_name
    , b.department_id
    , b.department_name
FROM employees a
            , departments b 
            , (SELECT AVG(c.salary) AS avg_salary
               FROM departments b
                           , employees c
               WHERE b.parent_id = 90
                    AND b.department_id = c.department_id) d
WHERE a.department_id = b.department_id
    AND a.salary > d.avg_salary;

-- p.199 하단
-- 2000년 이탈리아 평균 매출액(연평균)보다 큰 월의 평균 매출액을 구하는 것
-- 월별 평균 매출액 쿼리
SELECT 
    a.sales_month
    , ROUND(AVG(a.amount_sold)) AS month_avg 
FROM 
    sales a 
    , customers b
    , countries c
WHERE a.sales_month BETWEEN '200001' AND '200012'
    AND a.cust_id = b.CUST_ID 
    AND b.COUNTRY_ID = c.COUNTRY_ID
    AND c.COUNTRY_NAME = 'Italy' -- 이탈리아
GROUP BY a.sales_month;

-- 연평균 매출액 쿼리
SELECT 
    ROUND(AVG(a.amount_sold)) AS year_avg
FROM 
    sales a
    , customers b
    , countries c
WHERE a.sales_month BETWEEN '20001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID 
    AND c.COUNTRY_NAME = 'Italy'; -- 이탈리아
    


SELECT a.*
FROM (SELECT 
                 a.sales_month
                , ROUND(AVG(a.amount_sold)) AS month_avg 
            FROM 
                sales a 
                , customers b
                , countries c
            WHERE a.sales_month BETWEEN '200001' AND '200012'
                AND a.cust_id = b.CUST_ID 
                AND b.COUNTRY_ID = c.COUNTRY_ID
                AND c.COUNTRY_NAME = 'Italy' -- 이탈리아
                GROUP BY a.sales_month) a
                , (SELECT 
    ROUND(AVG(a.amount_sold)) AS year_avg
FROM 
    sales a
    , customers b
    , countries c
WHERE a.sales_month BETWEEN '20001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID 
    AND c.COUNTRY_NAME = 'Italy') b
WHERE a.month_avg > b.year_avg;

-- 계층형 쿼리
--p.208 부서정보
-- p.211
-- START WITH 조건 & CONNECT BY 조건
-- parent_id == 상위 부서 정보를 가지고 있음.
-- CONNECT BY PRIOR department_id = parent_id
SELECT
    DEPARTMENT_ID
    , LPAD('', 3*(LEVEL -1)) || department_name, LEVEL
from DEPARTMENTS
start with parent_id is NULL
connect by prior department_id=parent_id;

-- 사원테이블에 있는 manager_id, emd

select a.employee_id, lpad(' ', 3 *(LEVEL -1)) || a.emp_name,
    LEVEL,
    b.department_name
FROM employees a,
     departments b
WHERE a.department_id = b.DEPARTMENT_ID
    AND a.DEPARTMENT_ID = 30
start with a.manager_id is NULL
connect by NOCYCLE prior a.employee_id = a.manager_id;

-- p.213
--께층형 쿼리 심화학습
--쿼리가 나옴. ORDER BY 정렬 가능
-- ORDER SIBLINGS BY

select department_id, lpad(' ', 3 *(LEVEL -1)) || department_name, LEVEL
    FROM departments 
    start with parent_id is NULL
    connect by prior department_id = parent_id
ORDER SIBLINGS BY department_name;

    SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name, LEVEL,
           CONNECT_BY_ROOT department_name AS root_name
      FROM departments
     START WITH parent_id IS NULL
    CONNECT BY PRIOR department_id  = parent_id;

-- connect_by_isleaf
--계층형 쿼리 응용
--샘플 데이터 만들기
CREATE TABLE ex7_1 AS
SELECT
    ROWNUM seq
    , '2014' || LPAD(CEIL(ROWNUM/1000), 2, '0') MONTH
    , ROUND(DBMS_RANDOM.VALUE(100, 1000)) amt
FROM DUAL
CONNECT BY LEVEL <= 12000;

SELECT * FROM ex7_1

select 
    month
    , sum(amt)
FROM ex7_1
group by MONTH
order by month;


--WITH절
-- 서브쿼리의 가독성 향상
-- 연도별, 최종, 월별
WITH b2 AS (
    SELECT 
        period
        , region
        , sum(loan_jan_amt) jan_amt
    FROM kor_loan_status
    GROUP BY period, region
)

SELECT b2.* FROM b2;

select * from EMPLOYEES;

drop table EMPLOYEES;

DESC EMPLOYEES0721;

CREATE TABLE employees (
  EMPLOYEE_ID		NUMBER(6) NOT NULL,
  EMP_NAME	VARCHAR2(80) NOT NULL	,
  EMAIL		VARCHAR2(50),
  PHONE_NUMBER		VARCHAR2(30),
  HIRE_DATE		DATE NOT NULL,
  SALARY		NUMBER(8,2),
  MANAGER_ID		NUMBER(6),
  COMMISSION_PCT		NUMBER(2,2),
  RETIRE_DATE		DATE,
  DEPARTMENT_ID		NUMBER(6),
  JOB_ID		VARCHAR2(10),
  CREATE_DATE		DATE,
  UPDATE_DATE		DATE
);

select * from employees;

--231p 
-- 분석함수와 윈도우함수
-- 문법
-- 분석 함수(매개변수) OVER(PARTITION BY ...)
-- 분석 함수
-- ROW_NUMBER()/ ROWNUM
SELECT
    DEPARTMENT_ID
    , EMP_NAME
    , ROW_NUMBER() over (partition by DEPARTMENT_ID
                         order by department_id, emp_name)dep_rows
    FROM employees;

with temp as(
SELECT
    DEPARTMENT_ID
    ,EMP_NAME
    ,salary
   -- ,rank() over(partition by department_id order by salary)dep_rank
    ,DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary)dep_rank
from employees
)
select *
from temp
where dep_rank<=3;


-- p 234

-- CUME_DIST(): 상대적인 누적분포도 값을 반환
SELECT
    DEPARTMENT_ID
    , EMP_NAME
    , SALARY
    , CUME_DIST () over (partition by DEPARTMENT_ID
                         order by salary ) dep_dist
    FROM employees;

--percent_rank 함수
--백분위 순위 반환
-- 60번 부서에 대한 cume_dist(.percent_rank()값을 조회한다)
select department_id, emp_name,
       salary, 
       rank() OVER (partition by department_id
                    order by salary) raking
        ,CUME_DIST() OVER (PARTITION BY department_id
                           ORDER BY salary) cume_dist_value
        , PERCENT_RANK() OVER (PARTITION BY DEPARTMENT_ID
                               order by salary) percentile
 FROM employees
WHERE department_id = 60;

--p.236 NTILE 함수
-- Select rows from a Table

SELECT DEPARTMENT_ID,
  emp_name,
  salary,
  NTILE(4) OVER (PARTITION BY department_id ORDER BY salary) NTILES
FROM EMPLOYEES
WHERE department_id IN (30, 60);

--LAG, LEAD
--LAG 선행로우의 값을 반환한다
-- LEAD 후행로우의 값을 반환한다

SELECT
    EMP_NAME
    ,HIRE_DATE
    ,SALARY
    ,LAG(salary, 1, 0) OVER(ORDER BY hire_date) as prev_sal
    , LEAD(salary, 1, 0) OVER (ORDER BY hire_date) AS next_sal
 FROM EMPLOYEES
WHERE department_id = 30;

-- window 절
-- 240p
-- 정렬은 입사일자 순으로 처리.
-- 급여, unbounded preceding 부서별 입사일자가 가장 빠른 사원 
-- unbounded following 부서별 입사일자가 가장 늦은 사원 
-- 누적 합계 
select
    DEPARTMENT_ID
    , EMP_NAME
    , HIRE_DATE
    , SALARY
    , sum(salary) over (partition by department_id order by hire_date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
                        AS all_salary,
      sum(salary) OVER (PARTITION BY department_id ORDER BY hire_Date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
                        AS first_current_sal,
      sum(salary) OVER (partition by department_id order by HIRE_DATE
                        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) 
                        AS current_end_sal
    FROM EMPLOYEES
WHERE department_id IN (30, 90);

--WINDOW 함수

