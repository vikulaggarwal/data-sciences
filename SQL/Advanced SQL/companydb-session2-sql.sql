
use companydb;
SET SQL_SAFE_UPDATES = 0;

-- ------------------------------ Session 2 :: START ------------------------------

SELECT 
    *
FROM
    employee;

SELECT 
    dno, SUM(pay) AS dep_salary
FROM
    employee
GROUP BY dno;

select 
  ssn, 
  concat(fname, ' ', lname) as emp_name, 
  dno, 
  pay,
  sum(pay) over () as total_salary,
  sum(pay) over (partition by dno) as dep_salary
from 
  employee
order by 
  dno;

-- 2.1 Introduction to Windowing functions :: END

select essn, pno, hours,

avg(hours) over() as Average,

hours*100/sum(hours) over (partition by pno) as contribution_project,

hours*100/sum(hours) over (partition by essn) as contribution_personal

from works_on

order by essn;

-- 2.2 Window functions Applications :: START

select 
  ssn, 
  concat(fname, ' ', lname)                 as emp_name, 
  dno, 
  salary,
  sum(salary) over (partition by dno order by ssn rows unbounded preceding)                            as cumulative_total,
  sum(salary) over (partition by dno order by ssn rows between 1 preceding and 1 following )   as one_above_and_one_below
from employee;

select 
  ssn, 
  concat(fname, ' ', lname)                 as emp_name, 
  dno, 
  pay,
  first_value(pay) over (partition by dno order by ssn rows unbounded preceding)                  as first_val,   -- similarly last_value
  nth_value(pay,2) over (partition by dno order by ssn rows unbounded preceding)                as second_val
from employee;

-- 2.2 Window functions Applications :: END

-- 2.3 Named Windows :: START

select 
  ssn,
  pay,
  row_number() over (order by pay)                   as 'row_number',
  rank() over (order by pay)                                as 'rank',
  dense_rank() over (order by pay)                    as 'dense_rank'
from employee;

select 
  ssn,
  pay,
  row_number() over w                   as 'row_number',
  rank() over w                                as 'rank',
  dense_rank() over w                    as 'dense_rank'
from employee 
window w as (order by pay);

select 
  ssn,
  pay,
  dno,
  row_number() over w                   as 'row_number',
  rank() over w                                as 'rank',
  dense_rank() over w                    as 'dense_rank'
from employee 
window w as (partition by dno order by pay);

-- 2.3 Named Windows :: END

-- ------------------------------ Session 2 :: END ------------------------------

select concat ( fname, ' ', lname) as name , ssn,

row_number() over w as 'row_number' ,

rank() over w as 'rank'

from employee

window w as (order by concat(fname, ' ', lname));