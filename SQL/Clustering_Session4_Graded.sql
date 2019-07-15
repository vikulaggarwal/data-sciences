create table marks (
Student_id numeric,
Course varchar(30),
Marks numeric
);

select * from marks;
insert into marks (Student_id,Course,Marks)
values
(1,'CS1234',81),
(1,'CS1235',90),
(2,'CS1234',70),
(2,'CS1235',60),
(3,'CS1234',45),
(3,'CS1235',70);

SELECT Student_id FROM (SELECT Student_id, AVG(Marks) AS average_Sresult FROM marks GROUP BY Student_id) sre, (SELECT (AVG(Marks)) tavg FROM marks) ta WHERE sre.average_Sresult > ta.tavg;

select Student_id, avg(marks) from marks group by Student_id order by avg(marks) desc, Student_id;

select Course from (select Course,avg(marks) from marks group by Course order by avg(marks) desc limit 1) a;

select student_id
from marks
group by student_id
having avg(marks) > (select avg(marks) from marks)
order by student_id;

select avg(Marks) from marks;
SET SQL_SAFE_UPDATES = 0;
create table father (
father_id numeric,
son_id numeric );

insert into father (father_id,son_id)
values
(1,2),
(1,3),
(2,4),
(3,5),
(3,6),
(4,7);

select count(*) from (select a.father_id, b.son_id from father a ,father b where a.son_id = b.father_id) a;

select * from employee;

select dependent_name from dependent where essn in (select ssn from employee where dno = 5) order by dependent_name;

select dependent.dependent_name
from dependent join employee
on dependent.essn = employee.ssn
where employee.dno = 5
order by dependent.dependent_name;

create table MP (mp_name varchar(30), joining_date date);
create table MLA (mla_name varchar(30), joining_date date);

insert into MP (mp_name, joining_date) values
('Sahil Kumar','99-04-27'),
('Ramesh Lal','91-11-09'),
('Sahil Kumar','11-08-03'),
('Mahesh Singh','00-11-23'),
('Sahil Kumar','89-11-20');

select * from MP;

insert into MLA (mla_name, joining_date) values
('Sahil Kumar','80-04-20'),
('Mahesh Singh','85-05-22'),
('Mahesh Singh','91-12-29'),
('Ramesh Lal','85-05-22'),
('Akshay Prasad','80-04-20');

select * from MLA;

select mla_name from (select mla_name, mingap from (select mla_name, min(gap) as mingap from (select a.mla_name, b.joining_date - a.joining_date as gap from MLA a inner join MP b on a.mla_name = b.mp_name order by a.mla_name) c group by mla_name) d having mingap = max(mingap)) e;

select mla.mla_name
from mla
inner join
mp on mla.mla_name = mp.mp_name
group by mla.mla_name
order by min(mp.joining_date) - min(mla.joining_date) desc
limit 1;