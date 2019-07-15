drop table dependent;
drop table works_on;
drop table project;
drop table dept_locations;
drop table employee;
drop table department;

create table employee(
	fname varchar(30),
	minit char(1),
	lname varchar(30),
	ssn char(9),
	bdate date,
	address varchar(30),
	sex char(1),
	salary float(10,2),
	super_ssn char(9),
	dno smallint(6),
	constraint pk_employee PRIMARY KEY (ssn)
);

create table department(
	dname varchar(30),
	dnumber smallint,
	mgr_ssn char(9),
	mgr_start_date date,
	constraint pk_department PRIMARY KEY (dnumber)
);

create table dept_locations(
	dnumber smallint,
	dlocation varchar(20),
	constraint pk_dept_loc PRIMARY KEY (dnumber,dlocation)
);

create table project(
	pname varchar(30),
	pnumber smallint,
	plocation varchar(30),
	dnum smallint,
	constraint pk_project PRIMARY KEY (pnumber)
);

create table works_on(
	essn char(9),
	pno smallint,
	hours float(4,2),
	constraint pk_works_on PRIMARY KEY (essn, pno)
);

create table dependent(
	essn char(9),
	dependent_name varchar(30),
	sex char(1),
	bdate date,
	relationship varchar(20),
	constraint pk_dependent PRIMARY KEY (essn, dependent_name)
);

select * from employee;

insert into employee(fname,minit,lname,ssn,bdate,address,sex,salary,super_ssn,dno) VALUES
('John','B','Smith','123456789','1965-01-09','731 Fondren, Houston, TX','M',30000,'333445555',5),
('Franklin','T','Wong','333445555','1955-02-09','638 Fondren, Houston, TX','M',40000,'888665555',5),
('Alicia','J','Zelaya','999887777','1968-01-09','3321 Fondren, Houston, TX','F',25000,'987654321',4),
('Jennifer','S','Wallace','987654321','1941-01-09','21 Fondren, Houston, TX','F',43000,'888665555',4),
('Ramesh','K','Narayan','666884444','1962-01-09','975 Fondren, Houston, TX','M',38000,'333445555',5),
('Joyce','A','English','453453453','1972-01-09','5631 Fondren, Houston, TX','F',25000,'333445555',5),
('Ahmad','V','Jabbar','987987987','1969-01-09','980 Fondren, Houston, TX','M',25000,'987654321',4),
('James','E','Borg','888665555','1937-01-09','450 Fondren, Houston, TX','M',55000,NULL,1);

insert into department(dname,dnumber,mgr_ssn,mgr_start_date) VALUES
('Research',5,333445555,'1988-05-22'),
('Administration',4,987654321,'1995-05-22'),
('Headquarters',1,888665555,'1981-05-22');

insert into dept_locations(dnumber,dlocation) values
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

insert into works_on (essn, pno, hours) values
('123456789', 1, 32.5),
('123456789', 2, 7.5),
('666884444', 3, 40.0),
('453453453', 1, 20.0),
('453453453', 2, 20.0),
('333445555', 2, 10.0),
('333445555', 3, 10.0),
('333445555', 10, 10.0),
('333445555', 20, 10.0),
('999887777', 30, 30.0),
('999887777', 10, 10.0),
('987987987', 10, 35.0),
('987987987', 30, 5.0),
('987654321', 30, 20.0),
('987654321', 20, 15.0),
('888665555', 20, NULL);

insert into project(pname,pnumber,plocation,dnum) values
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

insert into dependent(essn,dependent_name,sex,bdate,relationship) values
('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
('333445555', 'Theodore', 'M', '1983-04-05', 'Son'),
('333445555', 'Joy', 'F', '1958-04-05', 'Spouse'),
('987654321', 'Abner', 'M', '1942-04-05', 'Spouse'),
('123456789', 'Michael', 'M', '1988-04-05', 'Son'),
('123456789', 'Alice', 'M', '1988-04-05', 'Daughter'),
('123456789', 'Elizabeth', 'M', '1967-04-05', 'Spouse');

alter table employee
	add constraint fk_super_ssn FOREIGN KEY (super_ssn) REFERENCES employee(ssn);

alter table employee
	add constraint fk_dno FOREIGN KEY (dno) REFERENCES department(dnumber);
    
alter table dept_locations
	add constraint fk_dnumber FOREIGN KEY (dnumber) REFERENCES department(dnumber);

alter table project
	add constraint fk_dnum FOREIGN KEY (dnum) REFERENCES department(dnumber);

alter table works_on
	add constraint fk_essn FOREIGN KEY (essn) REFERENCES employee(ssn);

alter table works_on
	add constraint fk_pno FOREIGN KEY (pno) REFERENCES project(pnumber);

alter table dependent
	add constraint fk_dep_essn FOREIGN KEY (essn) REFERENCES employee(ssn);
    
alter table employee modify bdate char(20);

select * from employee;

-- What is the sum of the house numbers of all employees?
select sum(substring_index(address, ' ', 1)) from employee;

-- Rank the employees in order of the house number in ascending order.
alter table employee add hno int;
update employee set hno = substring_index(address, ' ', 1);
select name,hno, rank() over (order by hno) as 'rank' from employee;

-- Find the average distance between the house of the employee with ssn '123456789' and the other employees' houses.
select  avg(abs(hno-(select hno from employee where ssn = '123456789'))) from employee where ssn != '123456789';

-- Write a SQL query to extract the name and birthdate of the employee's super_ssn using self-join. 
-- What is the birth date of the super_ssn of the employee with ssn '666884444'
select e.name , b.bdate from employee e inner join employee b  on e.super_ssn = b.ssn where e.ssn = '666884444';

-- Create a new column named 'age' storing the age of all employees as of 30 September 2018. What is the sum of the age of all employees?
alter table employee add age smallint; 
update employee set age = 2018 - extract(year from bdate);   
select sum(age) from employee;

-- Use self-join to find the difference between the age of the employees and their respective supervisors.
-- What is the difference in the age of employee with ssn '987654321' and its supervisor?
select e.age, b.age, e.name, b.name,abs(e.age-b.age), e.ssn from employee e inner join employee b on e.super_ssn = b.ssn where e.ssn ='987654321';

-- Use window function to rank the employees in order of salary/age (Salary divided by age) in descending order 
-- (Employee with greatest salary/age is ranked first and so forth). What is the Salary/Age of employee ranked fifth?
select ssn,name,salary/age as ratio, rank() over (order by salary/age desc) from employee;

-- create a stored procedure to display the details of the supervisor. Take the input as ssn and return nothing.
DELIMITER $$
create procedure supervisor 
(in n char(9))

select *

from employee

where ssn = (select super_ssn from employee where ssn = n);
end $$
DELIMITER ;

call supervisor('123456789'); 

-- Create a User defined function to calculate the Average distance of an employee's house from the other employees.
-- Take the input as the ssn and return the Average distance of that employee's house. Using the function, 
-- determine the average distance between the house of CEO (super_ssn is null) and the employees.

DELIMITER $$
create function distance (s char(20))
	returns float (10,4) deterministic

return (select avg(abs(hno- (select hno from employee where ssn = s))) from employee where ssn != s);
end
$$

DELIMITER ;

select distance(ssn), ssn from employee where super_ssn IS NULL;

-- determine the average distance considering only the employees in the same department.
-- What will be the department average distance for Franklin T Wong?
create function dep_distance (s char(20), d int)
	returns float (10,4) deterministic

return (select avg(abs(hno-(select hno from employee where ssn = s))) from employee where ssn != s and dno = d);

select dno, hno, name, dep_distance(ssn, dno) from employee where name = 'Franklin T wong';


alter table employee add d2 int;

update employee a set d2 = (select b.hno from employee b  where b.ssn = '123456789');

select hno where ssn = '123456789';

select * from employee;

UPDATE employee AS t1 INNER JOIN
(SELECT hno FROM employee WHERE ssn = '123456789') AS t2
SET t1.d2 = t2.hno;

select fname,ssn,(salary/age) as ratio, rank() over (order by (salary/age) desc) as rank1
 from employee;
 
 select * from employee;
 
 desc employee;