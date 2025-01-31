use AdventureWorks2022;

select * from HumanResources.Employee;

--find employee who are married
select *
from HumanResources.Employee
where MaritalStatus = 'M';

-- find all employees under job title Marketing

select * from HumanResources.Employee
where JobTitle = 'Marketing Specialist';

-- find all employees under job title Marketing and gender is male

select * from
HumanResources.Employee
where JobTitle = 'Marketing Specialist' and Gender = 'M'; 

-- find all employees under job title Marketing and gender is female and 
-- arrange it by descending birth date

select * from
HumanResources.Employee
where JobTitle = 'Marketing Specialist' and Gender = 'F'
ORDER BY BirthDate desc; 


-- count number of jobtile where gender is male

select JobTitle, COUNT(*)from
HumanResources.Employee
where Gender = 'M'
group by JobTitle;

-- for total count we use count() aggregate function
select count(*) from
HumanResources.Employee

-- count number for where gender is male
select COUNT(*)from
HumanResources.Employee
where Gender = 'M';

--Q1.Find the employees having salaried flag is 1

select * from
HumanResources.Employee
where SalariedFlag = 1

--Q2.Find the employees having vacation hr more than 70

select * from
HumanResources.Employee
where VacationHours > 70;

--Q3.Find the employees having vacation hr more than 70 but less than 90

select * from
HumanResources.Employee
where VacationHours > 70 and VacationHours < 90;

select * from
HumanResources.Employee
where VacationHours between 70 and 90;

--Q4.Find all jobs having title as designer

select * from
HumanResources.Employee
where JobTitle = 'Design Engineer';

--Q5.Find total employee works as technician

select * from
HumanResources.Employee
where JobTitle = 'Production Technician - WC60';

--better method
select * from
HumanResources.Employee
where JobTitle like '%Technician%';  -- % --> any values before and after technician

--Q5.Display data having nationalidnumber,job title,marital status,gender for all under
--marketing job title

select NationalIDNumber,JobTitle,MaritalStatus,Gender
from HumanResources.Employee
where JobTitle like '%marketing%';

--Q6.Find all unique marital status

select distinct MaritalStatus
from HumanResources.Employee;


--Q7.Find max vacation hours
select max(VacationHours)
from HumanResources.Employee;


--Q8.Find the less sick leaves hours
select min(SickLeaveHours)
from HumanResources.Employee;


--Q9. Find all employees from production department

select * from HumanResources.Department
where name = 'Production';

select * from HumanResources.Employee
where BusinessEntityID in
(select BusinessEntityID
from HumanResources.EmployeeDepartmentHistory
where DepartmentID = 7)

--Q10. Find all departments under research and development

select *
from HumanResources.Department;

select *
from HumanResources.Department
where GroupName = 'Research and Development';

--Q.11 find all emp under research and devlopment


select * from HumanResources.Employee
where BusinessEntityID in(
select BusinessEntityID from HumanResources.EmployeeDepartmentHistory
where DepartmentID in
(select DepartmentID
from HumanResources.Department
where GroupName = 'Research and Development'));

--Q12. Find all employees who work in a day shift

--select * from HumanResources.Shift;
--select  * from HumanResources.EmployeeDepartmentHistory;

select * from HumanResources.Employee
where BusinessEntityID in (
select BusinessEntityID from HumanResources.EmployeeDepartmentHistory
where ShiftID in (
select ShiftID from HumanResources.Shift
where name = 'Day'));

--Q13.Find all employees where pay frequency is 1

select * from HumanResources.Employee
where BusinessEntityID in(
select BusinessEntityID from HumanResources.EmployeePayHistory
where PayFrequency = 1);

--Q14. Find all candidate who are not placed

--method-1
select * from HumanResources.JobCandidate
where BusinessEntityID  IS NULL;

--method-2 
--select * from HumanResources.JobCandidate
--where BusinessEntityID in (select BusinessEntityID from
--HumanResources.JobCandidate);

--Q15. Find the address of employee

select * from Person.Address
where AddressID in(
select AddressID from Person.BusinessEntityAddress
where BusinessEntityID in
(select BusinessEntityID
from HumanResources.Employee));

--Q16.Find the name for employees working in group research and development

select FirstName,MiddleName,LastName from Person.Person 
where BusinessEntityID in(
select BusinessEntityID from HumanResources.EmployeeDepartmentHistory 
where DepartmentID in
(select DepartmentID
from HumanResources.Department 
where GroupName = 'Research and Development'));

SELECT p.FirstName, p.MiddleName, p.LastName, d.GroupName
FROM Person.Person p
JOIN HumanResources.EmployeeDepartmentHistory edh ON p.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE d.GroupName = 'Research and Development';
