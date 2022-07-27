SELECT * from employees;

select count(department_id)
    from employees;

select count(distinct department_id)
    from employees;

select distinct DEPARTMENT_ID
from EMPLOYEES
order by 1;

--합계 평균, 최대

select sum(salary)
    from employees;

select sum(salary), sum(distinct salary)
    from employees;

select AVG(salary), AVG(distinct salary) 
    from EMPLOYEES;

select min(salary), max( salary)
    from employees;

select min(distinct salary), max(distinct salary)
    from employees;

select variance(salary), stddev(salary)
    from employees;

-- 그룹바이 HAVING
-- 그전까지는 전체 데이터를 기준으로 집계
select department_id, sum(salary)
    from EMPLOYEES
group by DEPARTMENT_ID
order by department_id;

select * 
    from KOR_LOAN_STATUS;

select period, region, sum(LOAN_JAN_AMT) tot1_jan
    from KOR_LOAN_STATUS
where period like '2013%'
group by period, REGION
order by period, region;

-- 틀림
/*
SELECT period, region, SUM(loan_jan_amt) totl_jan
    FROM kor_loan_status
WHERE period = '201311'
GROUP BY region
ORDER BY region; */

SELECT period, region, SUM(loan_jan_amt) totl_jan
    FROM kor_loan_status
WHERE period = '201311'
GROUP BY period, region
HAVING SUM(loan_jan_amt)>100000 
ORDER BY region;

--ROLLUP절과 CUBE절
select period, gubun, sum(loan_jan_amt) tot1_jan
    from KOR_LOAN_STATUS
where period LIKE '2013%'
group by period, GUBUN
order by period;

select period, gubun, sum(loan_jan_amt) tot1_jan
  from KOR_LOAN_STATUS
where period like '2013%'
group by rollup(period, gubun);

select period, gubun, SUM(loan_jan_amt) tot1_jan
  from KOR_LOAN_STATUS
where period like '2013%'
group by cube(period, gubun);

CREATE TABLE exp_goods_asia (
           country VARCHAR2(10),
           seq     NUMBER,
           goods   VARCHAR2(80));

    INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
    INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
    INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
    INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
    INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
    INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
    INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
    INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
    INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
    INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

    INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
    INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
    INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
    INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
    INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
    INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
    INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
    INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
    INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
    INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');
commit;

select * from exp_goods_asia;

select goods
from exp_goods_asia
where country ='한국'
order by seq;

select goods
  from exp_goods_asia
where country = '한국'
UNION
SELECT goods
  from exp_goods_asia
where country = '일본';

--UNION ALL

select goods
  from exp_goods_asia
where country = '한국'
union ALL
select goods
  from exp_goods_asia
where country = '일본';

--교집합
select goods
  from exp_goods_asia
where country = '한국'
INTERSECT
select goods
  from exp_goods_asia
where country = '일본';

--차집합
select goods
  from exp_goods_asia
where country = '한국'
MINUS
SELECT goods
  from exp_goods_asia
where country = '일본';

--GROUPING SETS절
SELECT period, gubun, SUM(loan_jan_amt) tot1_jan
  from kor_loan_status
WHERE period like '2013%'
group by grouping sets(period, gubun);

SELECT period, gubun, SUM(loan_jan_amt) tot1_jan
  from kor_loan_status
WHERE period like '2013%'
  AND region in('서울', '경기')
group by grouping sets(period, (gubun, region));

-- 177p 조인의 활용
-- 돋등 조인
SELECT a.employee_id
       , a.emp_name
       , a.department_id
       , b.department_name
FROM employees a, departments b
where a.department_id = b.department_id;

--세미조인
--서브쿼리를 이용해 서브쿼리에 존재하는 데이터만 메인 쿼리에서 추출
-- EXISTS 사용
select department_id, DEPARTMENT_NAME
from departments a
where exists(select *
                    FROM employees b
                    WHERE a.department_id = b.department_id
                      AND b.salary>3000)
ORDER BY a.department_name;

select department_id, DEPARTMENT_NAME
  from departments A
where a.department_id IN (select b.department_id
                            from EMPLOYEES b
                            where b.salary > 3000)
order by department_name;

select 
    a.department_id
    , a.DEPARTMENT_NAME
from departments a, employees b
WHERE a.department_id = b.department_id
  and b.salary >3000
order by a.department_name; 

select
    a.employee_id
    , a. EMP_NAME
    , a.department_id
    , b.department_name
from employees a
    , departments b
where a.department_id = b.DEPARTMENT_ID
  and a.department_id not in( select DEPARTMENT_ID
                                from DEPARTMENTS
                                where manager_id is null);

select count(*)
  from EMPLOYEES a
where not exists (select 1
                    from departments C
                   where a.department_id = c.DEPARTMENT_ID
                      and manager_id is null);

-- 셀프 조인
-- 조인을 하려면, 두개의 테이블
-- 하나의 테이블을 , 두개로 분리

select a.employee_id, a.emp_name, b.employee_id, b.emp_name, a.department_id
  from employees a,
       employees b
  where a.EMPLOYEE_ID < b.EMPLOYEE_ID
    and a.department_id = b.DEPARTMENT_ID
    and a.department_id = 20;

-- 외부 조인
-- 일반 조인
select a.department_id, a.department_name, b.job_id, b.department_id
  from departments a,
       job_history b
where a.department_id = b.department_id; 

select a.department_id, a.department_name, b.job_id, b.department_id
  from departments a,
       job_history b
where a.department_id = b.department_id(+); 

select a.employee_id, a.emp_name, b.job_id, b.department_id
  from employees a,
       job_history b
where a.employee_id = b.employee_id(+)
  and a.department_id = b.department_id(+); 

-- ANSI 조인

-- Select rows from a Table

SELECT a.employee_id
        , a.emp_name
        , b.department_id
        , b.department_name
FROM employees a
inner join departments b
    on(a.department_id = b.department_id)
WHERE a.HIRE_DATE>= TO_DATE('2003-01-01', 'YYYY-MM-DD');

-- p.187 외부조인
select a.employee_id, a.emp_name, b.job_id, b.department_id
    from employees A
    right outer join job_history b
      on (a.employee_id = b.EMPLOYEE_ID
          and a.department_id = b.department_id);

select a.employee_id, a.emp_name, b.job_id, b.department_id
    from job_history b
  right outer join employees a
    on (a.employee_id   = b.employee_id
        and a.department_id = b.department_id) ;

-- 서브쿼리
-- SQL 수업의 하이라이트 ||
-- 서브쿼리
-- SELECT, FROM, WHERE
select count(*)
from EMPLOYEES
where salary >= (select avg(salary)
  from employees );

-- IN (복수 결정값을 넣을 수 있음)
select count(*)
from EMPLOYEES
WHERE department_id in(select DEPARTMENT_ID
                         from DEPARTMENTS
                        where parent_id is null);

-- 
select EMPLOYEE_ID
        ,EMP_NAME
        ,JOB_ID
from EMPLOYEES
where (employee_id, job_id) in (select employee_id,
                                                   JOB_ID
                                from job_history);
--서브쿼리 select뿐 아니라 update, delete 등
--전 사원의 급여를 평균 금액으로 갱신
--commit 금지


create table employees0721 AS
select * from employees

update EMPLOYEES
    set salary = ( select AVG(salary)
                     from employees );

-- 연관성 있는 서브쿼리
select a.department_id, a.department_name
    from departments A
where exists( select 1
                from job_history b
              where a.department_id = b.department_id);

SELECT
    a.employee_id
    , (select b.emp_name
       from employees b
       where a.employee_id = b.employee_id) AS emp_name
       , a.department_id
       , (select b.department_name
          from departments b
          where a.department_id = b.department_id) as DEPARTMENT_NAME
from job_history a;

-- 메인쿼리
    SELECT a.department_id, a.department_name
      FROM departments a
     WHERE EXISTS ( SELECT 1
                      FROM employees b
                     WHERE a.department_id = b.department_id 
                       AND b.salary > ( SELECT AVG(salary) 
                                          FROM employees )
                   );
select 1
from departments a, employees b
where a.department_id = b.department_id;

--p.196
-- 메인쿼리: 사원 테이블의 사원들이 부서별 평균 급여를 조회
-- 서브쿼리: 상위 부서가 기획부(부서번호가 90)에 속함
select department_id, avg(salary)
from EMPLOYEES
where DEPARTMENT_ID in (select department_id
                        from DEPARTMENTS
                        where parent_id = 90)
group by department_id;

