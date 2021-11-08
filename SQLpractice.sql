create table employeedemo(
ID int,
firstname varchar(20),
lastname varchar(20),
age int,
gender varchar(10));




drop table employeedemo;

select * from employeedemo;
select * from employeepay;


create table employeepay(
ID int,
jobtitle varchar(50),
pay int);


insert into employeedemo values
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male');

Insert Into employeepay VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000);


-- basic function in SQL: Top, Distinct, count, As, max, min, avg

select distinct(age)  As 'unique_age' from employeedemo;

/* 
where statement:
=,<>, <, >, and, or, like, null, not null, In
*/
select * from employeedemo
where age >= 32 and gender = 'male';

select * from employeedemo
where lastname like '%s%o%';

select * from employeedemo
where lastname is not null;

select * from employeedemo
where firstname in ('jim','michael');

/* 
Group by (you group by the unique features for the derived column), Order by
*/

select gender,age, count(gender) as agecount from employeedemo
where age > 31
group by gender, age
order by agecount asc;

/*
Inner join, outer join
*/


select * from employeedemo
full outer join employeepay
	ON employeedemo.ID = employeepay.ID;

/*
Union, Union All
*/

select employeedemo.ID, employeedemo.firstname 
from employeedemo
union
select employeepay.ID, employeepay.jobtitle
from employeepay

/* 
Case statement
*/

select firstname, lastname, age, gender,
Case
	when age > 30 then 'old'
	when age between 29 and 30 then 'OK'
	else 'young'
end as 'status',
Case
	when gender = 'Female' then 'good'
	else 'not that good'
end as 'I judge'
from employeedemo
where age is not null
order by age;


/* 
having
*/

select jobtitle, avg(pay)
from employeedemo
join employeepay
	on employeedemo.ID = employeepay.ID
group by jobtitle
having avg(pay)> 45000
order by avg(pay)

/*
updating/deleting data

typr update or delete with a "where" clause
*/

/*
partition by
*/
select firstname, lastname , gender, pay
, avg(pay) over (partition by gender) as Total_Gender
from employeedemo as demo
join employeepay as pay
	on demo.ID = pay.ID

select * 
from employeedemo as demo
join employeepay as pay
	on demo.ID = pay.ID

/*

String Functions - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower

*/

Drop Table if exists EmployeeErrors;


CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using Trim, LTRIM, RTRIM

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors 

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors 

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors 

	



-- Using Replace

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors


-- Using Substring

Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3), Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemo dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3)



-- Using UPPER and lower

Select firstname, LOWER(firstname)
from EmployeeErrors

Select Firstname, UPPER(FirstName)
from EmployeeErrors

/*
Stored Procedures
*/
DROP PROCEDURE IF EXISTS Temp_Employee;  
 
CREATE PROCEDURE Temp_Employee
AS
DROP TABLE IF EXISTS #temp_employee
Create table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)

Insert into #temp_employee
SELECT JobTitle, Count(jobtitle), Avg(age), AVG(pay)
FROM employeedemo emp
JOIN employeepay sal
	ON emp.ID = sal.ID
group by JobTitle

Select * 
From #temp_employee
GO;
exec Temp_Employee;



CREATE PROCEDURE Temp_Employee2 
@JobTitle nvarchar(100)
AS
DROP TABLE IF EXISTS #temp_employee3
Create table #temp_employee3 (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee3
SELECT JobTitle, Count(jobtitle), Avg(age), AVG(pay)
FROM employeedemo emp
JOIN employeepay sal
	ON emp.ID = sal.ID
where JobTitle = @JobTitle --- make sure to change this in this script from original above
group by JobTitle

Select * 
From #temp_employee3
GO;


exec Temp_Employee2 @jobtitle = 'Salesman'
exec Temp_Employee2 @jobtitle = 'Accountant'


/*
Subqueries (in the Select, From, and Where Statement)
*/


Select ID, JobTitle, pay
From Employeepay

-- Subquery in Select

Select EmployeeID, Salary, (Select AVG(Salary) From EmployeeSalary) as AllAvgSalary
From EmployeeSalary

-- How to do it with Partition By
Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
From EmployeeSalary

-- Why Group By doesn't work
Select EmployeeID, Salary, AVG(Salary) as AllAvgSalary
From EmployeeSalary
Group By EmployeeID, Salary
order by EmployeeID


-- Subquery in From

Select a.EmployeeID, AllAvgSalary
From 
	(Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
	 From EmployeeSalary) a
Order by a.EmployeeID


-- Subquery in Where


Select EmployeeID, JobTitle, Salary
From EmployeeSalary
where EmployeeID in (
	Select EmployeeID 
	From EmployeeDemographics
	where Age > 30)