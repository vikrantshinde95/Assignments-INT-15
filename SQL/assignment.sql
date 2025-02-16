use AdventureWorks2022;

--1.Create a customer table having following column with suitable data type
--Cust_id  (automatically incremented primary key)
--Customer name (only characters must be there)
--Aadhar card (unique per customer)
--Mobile number (unique per customer)
--Date of birth (check if the customer is having age more than15)
--Address
--Address type code (B- business, H- HOME, O-office and should not accept any other)
--State code ( MH – Maharashtra, KA for Karnataka)

use temp;

create schema worksheet;

create table worksheet.customer(
customer_id int identity primary key,
customer_name varchar(50),
Aadhar_id char(10) unique,
mob_no bigint unique,
dob date check(datediff(year,dob,getdate())>15),
address varchar(100),
address_type char(1) check(len(address_type)=1 and address_type in ('b','h','o')),
state_code char(2) check (len(state_code)=2)
)

--Create another table for Address type which is having
--Address type code must accept only (B,H,O)
--Address type  having the information as  (B- business, H- HOME, O-office)

create table worksheet.address_type(
	
	address_type char(1) primary key check(len(address_type)=1 and address_type in ('b','o','h')),
	information varchar(50)

)

--Create table state_info having columns as  
--State_id  primary unique
--State name 
--Country_code char(2)

create table worksheet.state_info(
state_id int primary key,
state_name varchar(40),
country_code char(2)
)

INSERT INTO worksheet.address_type VALUES('B','Business Address')

--Alter tables to link all tables based on suitable columns and foreign keys.

alter table worksheet.customer
add constraint new2 foreign key (address_type) references assign.address_type(address_type) 

drop table worksheet.address_type

--Change the column name from customer table customer name as c_name
EXEC sp_rename 'worksheet.customer.customer_name', 'Cust_name', 'COLUMN';

select * from worksheet.customer

--Insert the suitable records into the respective tables
INSERT INTO worksheet.address_type VALUES('o','Office Address')

INSERT INTO worksheet.customer VALUES('Vikrant','1234567890',1234567890,'1980-04-30','Pune','o','MH')

INSERT INTO worksheet.state_info VALUES(1,'Maharashtra','MH')


--Change the data type of  country_code to varchar(3)

alter table worksheet.state_info
alter column country_code varchar(3)


use AdventureWorks2022;

--Q1.find the average currency rate conversion from USD to Algerian Dinar and Australian Doller 

select * from Sales.Currency where name ='Algerian Dinar'
select * from Sales.CurrencyRate
select * from Sales.CountryRegionCurrency 

select cr.ToCurrencyCode,
		cr.FromCurrencyCode,
		AVG(AverageRate)
from Sales.CurrencyRate cr,
Sales.Currency c
where ToCurrencyCode in ('DZD','AUD')
group by cr.ToCurrencyCode,cr.FromCurrencyCode 

--Q2.Find the products having offer on it and display product name ,
--safety Stock Level, Listprice,  and product model id, type of discount, 
--percentage of discount,  offer start date and offer end date

select * from Sales.SpecialOffer

select * from Production.Product
select * from Sales.SpecialOfferProduct

select p.Name,
       p.SafetyStockLevel,
	   p.ListPrice,
	   p.ProductModelID,
	   so.DiscountPct,
	   so.StartDate,
	   so.EndDate
from Sales.SpecialOfferProduct sop,
Production.Product p,
Sales.SpecialOffer so
where sop.SpecialOfferID = so.SpecialOfferID and
sop.ProductID = p.ProductID


--Q3.create view to display Product name and Product review
select * from Production.Product
select * from Production.ProductReview

create view v1 as 
select p.Name ,
       pr.Comments
from Production.ProductReview pr,
Production.Product p
where pr.ProductID = p.ProductID

select * from v1;

--Q4.find out the vendor for product paint, Adjustable Race and blade

select * from Production.Product where name in ('Adjustable Race','Blade','Paint')
select * from Purchasing.ProductVendor
select * from Purchasing.Vendor

select p.Name,
		v.Name,
		count(*) cnt
from Purchasing.Vendor v,
Production.Product p,
Purchasing.ProductVendor pv
where v.BusinessEntityID = pv.BusinessEntityID
and p.ProductID = pv.ProductID
and p.Name in ('Adjustable Race','Blade') or p.Name like ('paint%')
group by p.Name,v.Name



--Q5.find product details shipped through ZY - EXPRESS

select * from Purchasing.ShipMethod
select * from Production.Product
select * from Production.TransactionHistory
select * from Purchasing.PurchaseOrderDetail
select * from Purchasing.PurchaseOrderHeader 

select distinct 
		p.Name,
		p.ProductID,
		sm.Name
from Purchasing.PurchaseOrderHeader poh,
Purchasing.PurchaseOrderDetail pod,
Production.Product p,
Purchasing.ShipMethod sm
where sm.ShipMethodID = poh.ShipMethodID
and pod.PurchaseOrderID = poh.PurchaseOrderID
and pod.ProductID = p.ProductID
and sm.Name = 'ZY - EXPRESS'


--Q6.find the tax amt for products where order date and ship date are on the same day

select * from Sales.SalesOrderDetail

select * from Sales.SalesOrderHeader
WHERE ORDERDATE IN(
SELECT SOH.ORDERDATE FROM Sales.SalesOrderHeader SOH
UNION
SELECT OH.ShipDate FROM Sales.SalesOrderHeader OH)

select * from Production.Product

select	p.Name,
		so.taxAmt,
		SO.OrderDate 
from Sales.SalesOrderDetail s, 
Sales.SalesOrderHeader so,
Production.Product p 
where SO.OrderDate  IN (select SOH.ORDERDATE from Sales.SalesOrderHeader SOH
union
select OH.ShipDate from Sales.SalesOrderHeader OH) 
and s.salesorderid=so.salesorderid 
and s.productid=p.productid  

select * from Sales.SalesOrderHeader so 

--Q7. find the average days required to ship the product based on shipment type.

select	sm.Name ,
		avg(datediff(day,h.OrderDate,h.ShipDate))
from Purchasing.PurchaseOrderHeader h,
Purchasing.ShipMethod sm
where h.ShipMethodID = sm.ShipMethodID
select *
from Purchasing.ShipMethod

select sm.Name , 
		avg(datediff(day,h.OrderDate,h.ShipDate))
from Sales.salesOrderHeader h,
Purchasing.ShipMethod sm
where h.ShipMethodID = sm.ShipMethodID
group by sm.name
 
 
--Q8. find the name of employees working in day shift
 
select * 
from Person.Person 
where BusinessEntityID in (
select BusinessEntityID 
		from HumanResources.EmployeeDepartmentHistory
where ShiftID in(
select ShiftID 
		from HumanResources.Shift where name ='day'))

select count(*)
from HumanResources.Shift s,
HumanResources.EmployeeDepartmentHistory ed
where s.ShiftID = ed.ShiftID
and s.Name = 'Day'
and EndDate is NULL

--Q9.based on product and product cost history find the name , 
--service provider time and average Standardcost

SELECT * from Production.Product

select	p.Name,
		min(pch.StartDate),
		max(pch.EndDate),
		datediff(day,min(pch.StartDate),
		max(pch.EndDate)) as dd, 
		avg(pch.StandardCost)
from Production.Product p,
Production.ProductCostHistory pch
where pch.ProductID = p.ProductID
group by p.Name

--Q10.find products with average cost more than 500

select Name,
		avg(StandardCost) average
from Production.Product
group by Name
having avg(StandardCost) > 500
order by avg(StandardCost)

--Q11.find the employee who worked in multiple territory

select * from Sales.SalesTerritory
select * from Sales.SalesTerritoryHistory
select * from Person.Person

select	pp.FirstName , 
		count(*) cnt
from Sales.SalesTerritory st,
Sales.SalesTerritoryHistory sth,
Person.Person pp
where sth.BusinessEntityID = pp.BusinessEntityID
and st.TerritoryID = sth.TerritoryID
group by pp.FirstName
having count(*) > 1

--Q12.find out the Product model name,  product description for culture as Arabic
SELECT * from Production.ProductModelProductDescriptionCulture
select * from Production.ProductDescription
select * from Production.ProductModel
select * from Production.Culture

select	pm.Name,
		pd.Description
from Production.ProductModel pm,
Production.ProductDescription pd,
Production.Culture c,
Production.ProductModelProductDescriptionCulture ppd
where pm.ProductModelID = ppd.ProductModelID
and c.CultureID = ppd.CultureID
and ppd.ProductDescriptionID = pd.ProductDescriptionID
and c.Name like '%Arabic'

--13. Find first 20 employees who joined very early in the company

select top(20) 
		p.FirstName,
		p.LastName,
		StartDate
from HumanResources.Employee e,
HumanResources.EmployeeDepartmentHistory d,
Person.Person p
where e.BusinessEntityID = d.BusinessEntityID 
and p.BusinessEntityId=e.BusinessEntityID
and EndDate is null 
order by startdate

--14.Find most trending product based on sales and purchase.

select * from Sales.SalesOrderDetail
select * from Purchasing.PurchaseOrderDetail

select ps.Name ,
		sum(p.OrderQty),
		sum(s.OrderQty)
from Purchasing.PurchaseOrderDetail p,
Sales.SalesOrderDetail s,
Production.Product ps
where ps.ProductID = s.ProductID
and p.ProductID = ps.ProductID
group by ps.Name
order by (sum(p.OrderQty)+sum(s.OrderQty))desc




--Q15.display empname,terriroty name,group,saleslastyear salesquota,bonus

use AdventureWorks2022;

select * from Sales.SalesPerson
select * from Sales.SalesTerritory
select * from Person.Person

Select(SELECT CONCAT_ws(' ',firstname,lastname) FROM Person.Person p 
       	 where p.BusinessEntityID=ss.BusinessEntityID) fullname,
	   (select [Group] from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) grp,
	   (select SalesLastYear from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID),
	   (select SalesQuota from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID),
	   (select Bonus from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) bonus
	   from Sales.SalesPerson ss;

--Q16.display EMP name, territory name, saleslastyear salesquota 
--and bonus from Germany and United Kingdom

Select(SELECT CONCAT_ws(' ',firstname,lastname) FROM Person.Person p 
       	 where p.BusinessEntityID=ss.BusinessEntityID) empname,
	   (select  [Group] from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) grp,
	   (select Name from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) cname,
	   (select SalesLastYear from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) slast,
	   (select SalesQuota from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) squota,
	   (select Bonus from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) bonus
FROM Sales.SalesPerson ss
WHERE ss.TerritoryID IN 
(SELECT TerritoryID 
FROM Sales.SalesTerritory 
WHERE Name IN ('Germany', 'United Kingdom'));

--Q17.Find all employees who worked in all North America territory

--method-1
Select(SELECT CONCAT_ws(' ',firstname,lastname) FROM Person.Person p 
       	 where p.BusinessEntityID=ss.BusinessEntityID) empname,
	   (select  [Group] from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) grp,
	   (select Name from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) cname,
	   (select SalesLastYear from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) slast,
	   (select SalesQuota from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) squota,
	   (select Bonus from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) bonus
FROM Sales.SalesPerson ss
WHERE ss.TerritoryID IN 
(SELECT TerritoryID 
FROM Sales.SalesTerritory 
WHERE [Group] = 'North America');

--method-2
Select
		(SELECT CONCAT_ws(' ',firstname,lastname) 
		FROM Person.Person p 
where p.BusinessEntityID=ss.BusinessEntityID) empname
FROM Sales.SalesPerson ss
WHERE ss.TerritoryID IN 
(SELECT TerritoryID 
FROM Sales.SalesTerritory 
WHERE [Group] = 'North America');

--Q18.find all products in the cart

select * from Sales.ShoppingCartItem
select *from Production.Product

select * 
from Production.Product
where ProductID in
(select ProductID
from Sales.ShoppingCartItem);

--Q19.find the product with special offer
select * from Sales.SpecialOffer;
select * from Sales.SpecialOfferProduct;
select * from Production.Product


select	p.productid,
		p.name as prodname,
		sop.specialofferid
from production.product p,
Sales.SpecialOfferProduct sop
where p.ProductID = sop.ProductID;

--Q20. find the employee's name,job title,credit card details whose
-- credit card expired in month 11and year 2008

select * from HumanResources.Employee

select * from Sales.CreditCard

select * from Sales.PersonCreditCard

select (select FirstName
        from Person.Person p
		where p.BusinessEntityID = pc.BusinessEntityID) FirstNAME,
		(select JobTitle
		from HumanResources.Employee e
		where e.BusinessEntityID = pc.BusinessEntityID) Job_Title,
		(select CONCAT_WS(' ',cc.CardType,cc.ExpMonth,cc.ExpYear) 
		from Sales.CreditCard cc
		where cc.CreditCardID = pc.CreditCardID)ExpiryDATE
from Sales.PersonCreditCard pc
where pc.CreditCardID in (select CreditCardID
		from Sales.CreditCard crd
		where crd.ExpMonth = 11 and crd.ExpYear = 2008)


--Q20.Find the employee whose payment might be revised  (Hint : Employee payment history)
select * from HumanResources.EmployeePayHistory
select * from HumanResources.EmployeeDepartmentHistory

select	BusinessEntityID ,
		count(*) cnt
from HumanResources.EmployeePayHistory
group by BusinessEntityID
having count(*)>1

select * 
from HumanResources.Employee
where BusinessEntityID not in (
select BusinessEntityID 
from HumanResources.EmployeePayHistory);


--Q21.Find the personal details with address and address 
--type(hint: Business Entiry Address , Address, Address type)
 
select  p.FirstName,
		p.LastName,
		a.AddressLine1,
		att.AddressTypeID
from Person.BusinessEntityAddress bea,
Person.Address a,
Person.Person p,
Person.AddressType att
where a.AddressID = bea.AddressID and
att.AddressTypeID = bea.AddressTypeID 
and p.BusinessEntityID = bea.BusinessEntityID

--22. Find total standard cost for the active Product. (Product cost history)
select	p.Name, 
		c.StandardCost
from Production.ProductCostHistory c,
Production.Product p
where c.ProductID = p.ProductID
and c.EndDate is null


--joins
--23.Find the personal details with address and address 
--type(hint: Business Entiry Address , Address, Address type)

select p.FirstName,
		p.LastName,
		a.AddressLine1,
		at.AddressTypeID
from Person.BusinessEntityAddress ba,
Person.Address a,
Person.Person p,
Person.AddressType at
where a.AddressID = ba.AddressID and
at.AddressTypeID = ba.AddressTypeID 
and p.BusinessEntityID = ba.BusinessEntityID
 
--Q24. Find the name of employees working in group of North America territory

select	p.FirstName,
		p.LastName,
		st.Name,
		st.[group] 
from Person.Person p,
Sales.SalesTerritory st,
Sales.SalesTerritoryHistory sth
where st.TerritoryID = sth.TerritoryID and
sth.BusinessEntityID = p.BusinessEntityID
and st.[Group] = 'North America'
 
 
--Q25.display the personal details of  employee whose payment is revised for more than once.

SELECT eph.BusinessEntityID,
		p.FirstName,
		p.LastName,
		COUNT(*) as rev
FROM HumanResources.EmployeePayHistory eph,
Person.Person p
where p.BusinessEntityID = eph.BusinessEntityID
GROUP BY eph.BusinessEntityID,p.FirstName,p.LastName
HAVING COUNT(*) > 1;



 --Q25.find the duration of payment revision on every interval  (inline view) 
 --Output must be as given format revised time – count of revised salries
--duration – last duration of revision e.g there are two revision
--date 01-01-2022 and revised in 01-01-2024   so duration here is 2years


select id,
		DATEDIFF(day,rim,rm) dy 
from
(select id,
		max(rid) rm,
		max(ro) rim 
from
(select BusinessEntityID id, 
		RateChangeDate rid, 
		LAG(ratechangedate,1)
over (partition by BusinessEntityID order by ratechangedate) ro
from HumanResources.EmployeePayHistory)t1
where ro is not null
group by id)t2




---------------------------------------------------------------


--Q26. check if any employee from jobcandidate table is having any payment revisions

select  e.BusinessEntityID,
		p.FirstName,	
		p.LastName,
		count(*) as rev
from HumanResources.JobCandidate jc,
HumanResources.EmployeePayHistory e	,
Person.Person p
where e.BusinessEntityID = jc.BusinessEntityID
and jc.BusinessEntityID = p.BusinessEntityID
group by  e.BusinessEntityID,p.FirstName,p.LastName
having count(*)>0

--27.Which shelf is having maximum quantity (product inventory)

select	shelf,
		max(distinct quantity)
from Production.ProductInventory
group by shelf
order by max(distinct quantity) desc

--28.Which shelf is using maximum bin(product inventory)

select shelf,
		max(distinct bin)
from Production.ProductInventory
group by shelf
order by max(distinct bin) desc

--29.Which location is having minimum bin (product inventory)

select l.Name,
		min( bin) 
from Production.ProductInventory i,
Production.Location l
where i.LocationID = l.LocationID
group by l.Name
order by min(bin)


--30.Find out the product available in most of the locations (product inventory)

select	distinct 
		p.name,
		count(LocationID)
from Production.ProductInventory i,
Production.Product p
where p.ProductID = i.ProductID
group by p.name
order by count(LocationID) desc

--31.Which sales order is having most order qualtity.
--wrong

select SalesOrderID ,
		sum(OrderQty)
from Sales.SalesOrderDetail
group by SalesOrderID
order by sum(OrderQty) desc

-- 32. find the duration of payment revision on every interval  (inline view) 
-- Output must be as given format

select fn,ln,rc,DATEDIFF(year,lag,date)duration 
from(
select distinct fn,ln,rc,max(r)date,max(l)lag 
from (
select  p.FirstName fn,
		p.LastName ln,
		count(RateChangeDate)over(partition by p.BusinessEntityID) rc,
		RateChangeDate r,
		lag(RateChangeDate,1)over(partition by p.BusinessEntityID order by ratechangedate)l
from HumanResources.EmployeePayHistory ph,
Person.Person p
where p.BusinessEntityID = ph.BusinessEntityID)t1
group by fn,ln,rc)t3


--Q33. check if any employee from jobcandidate table is having any payment revisions

select  e.BusinessEntityID,
		p.FirstName,	
		p.LastName,
		count(*) as rev
from HumanResources.JobCandidate jc,
HumanResources.EmployeePayHistory e	,
Person.Person p
where e.BusinessEntityID = jc.BusinessEntityID
and jc.BusinessEntityID = p.BusinessEntityID
group by  e.BusinessEntityID,p.FirstName,p.LastName
having count(*)>0
 
--Q34.check the department having more salary revision
 
select d.Name,
		count(*) rev
from HumanResources.EmployeePayHistory ph,
HumanResources.EmployeeDepartmentHistory dh,
HumanResources.Department d
where dh.BusinessEntityID = ph.BusinessEntityID and
d.DepartmentID = dh.DepartmentID
group by d.Name
order by count(*) desc
 
--Q35.check the employee whose payment is not yet revised

select * 
from Person.Person 
where BusinessEntityID not in 
(select BusinessEntityID 
from HumanResources.EmployeePayHistory
)
 
--Q36. find the job title having more revised payments

select e.JobTitle,
		count(* )
from HumanResources.EmployeePayHistory ph,
HumanResources.Employee e
where e.BusinessEntityID = ph.BusinessEntityID
group by e.JobTitle
having count(*)>1
order by count(*) desc

select e.JobTitle, 
		count(*) cnt
from HumanResources.Employee e
where e.BusinessEntityID in 
(select ep.BusinessEntityID
      from HumanResources.EmployeePayHistory ep
	  group by ep.BusinessEntityID
	  having count(*) > 1)
group by e.JobTitle

--using inline view
select JobTitle,
		count(*)
from
(select e.JobTitle JobTitle, 
		e.BusinessEntityID id,
		count(*) cnt
from HumanResources.Employee e,
HumanResources.EmployeePayHistory ep
where e.BusinessEntityID = ep.BusinessEntityID
group by e.JobTitle,e.BusinessEntityID
having count(*) > 1
) as t
group by JobTitle;


--37.find the employee whose payment is revised in shortest duration (inline view)
select f,ln,rc,DATEDIFF(year,lag,date)duration
from(
select distinct f,ln,rc,max(r)date,max(l)lag 
from (
select  p.FirstName f,
		p.LastName ln,
		count(RateChangeDate)over(partition by p.BusinessEntityID) rc,
		RateChangeDate r,
		lag(RateChangeDate,1)over(partition by p.BusinessEntityID order by ratechangedate)l
from HumanResources.EmployeePayHistory ph,
Person.Person p
where p.BusinessEntityID = ph.BusinessEntityID)t1
group by f,ln,rc)t3
where DATEDIFF(year,lag,date) is not null
order by DATEDIFF(year,lag,date)

 
--Q38. find the colour wise count of the product (tbl: product)
 
select Color,
		count(*) prodt_c
from Production.Product
group by Color
 
--Q39. find out the product who are not in position to sell 
--(hint: check the sell start and end date)

select name,
		SellEndDate
from Production.Product
where SellEndDate is not null
 
--Q40.  find the class wise, style wise average standard cost
 
select class,
		Style ,
		avg(StandardCost) average
from Production.Product 
where Class is not null and Style is not null
group by class,style
 
--Q41.check colour wise standard cost
select Color,
		sum(StandardCost) total
from Production.Product
group by color
 
 
--Q42. find the product line wise standard cost
 
select ProductLine,
		sum(StandardCost)total
from Production.Product
where ProductLine is not null
group by ProductLine
 
--Q43.Find the state wise tax rate 
--(hint: Sales.SalesTaxRate, Person.StateProvince)
 
select * from Sales.SalesTaxRate
select * from Person.StateProvince
 
select sp.StateProvinceID,
		sum(TaxRate)total 
from Sales.SalesTaxRate tr,
Person.StateProvince sp
where sp.StateProvinceID = tr.StateProvinceID
group by sp.StateProvinceID

--44.Find the department wise count of employees

use AdventureWorks2022;

select d.Name,
		count(*)
from HumanResources.Employee e,
HumanResources.Department d,
HumanResources.EmployeeDepartmentHistory dh
where e.BusinessEntityID = dh.BusinessEntityID and
dh.DepartmentID = d.DepartmentID
group by d.Name

--45.Find the department which is having more employees

select d.Name,
		count(*)
from HumanResources.Employee e,
HumanResources.Department d,
HumanResources.EmployeeDepartmentHistory dh
where e.BusinessEntityID = dh.BusinessEntityID and
dh.DepartmentID = d.DepartmentID
group by d.Name
order by count(*) desc

--46.Find the job title having more employees

select jobtitle,
		count(*) 
from HumanResources.Employee
group by JobTitle
order by count(*)desc

--47.Check if there is mass hiring of employees on single day

select top 1 hiredate,
		count(*) 
		from HumanResources.Employee
group by HireDate
order by count(*)desc

--48.Which product is purchased more? (purchase order details)

select top 1 p.name ,
		count(*)
from Purchasing.PurchaseOrderDetail pd,
Production.Product p
where p.ProductID = pd.ProductID
group by p.Name
order by count(*) desc

--49.Find the territory wise customers count   (hint: customer)

select  TerritoryID,
		count(*) from sales.Customer
group by territoryid

--50.Which territory is having more customers (hint: customer)

select top 1 t.name,
			c.TerritoryID,
			count(CustomerID) 
from sales.Customer c, 
Sales.SalesTerritory t
group by c.territoryid,t.name
order by count(*) desc

--51.Which territory is having more stores (hint: customer)

select TerritoryID,
		count(distinct StoreID) 
from Sales.Customer
group by TerritoryID
order by count(distinct StoreID) desc

--52. Is there any person having more than one credit card (hint: PersonCreditCard)

select BusinessEntityID,
		count(distinct CreditCardID) 
from sales.PersonCreditCard
group by BusinessEntityID 
having count(distinct CreditCardID)>1

--53.Find the product wise sale price (sales order details)

select  ProductID,
		avg(UnitPrice*OrderQty)
from Sales.SalesOrderDetail
group by ProductID
order by ProductID


--54.Find the total values for line total product having maximum order

select top 1 ProductID,
			sum(OrderQty)order_qty,
			sum(LineTotal)lintotal 
from Sales.SalesOrderDetail
group by ProductID
order by sum(OrderQty) desc

--Q55. Calculate age of employees

select BusinessEntityID,
		BirthDate,
		DATEDIFF(year, BirthDate, GETDATE()) Age
from HumanResources.Employee;

--Q56.Calculate the year of experience of the employee based on hire date
select BusinessEntityID,
		HireDate,
		DATEDIFF(year, HireDate, GETDATE()) Experience
from HumanResources.Employee;

--Q57.Find the age of employee at the time of joining

select BusinessEntityID,
		BirthDate,
		HireDate,
		DATEDIFF(year, BirthDate, HireDate) age_hiring
from HumanResources.Employee

--Q58.Find the average age of male and female

select
		Gender,
		AVG(DATEDIFF(year,BirthDate,GETDATE())) avg_age
from HumanResources.Employee
group by Gender

--Q59.Which product is the oldest product as on the date (refer  the product sell start date)


select ProductID,
		name , 
		DATEDIFF(YEAR,SellStartDate,GETDATE()) dt
from Production.Product
where SellEndDate is null
order by dt desc

--60. Display the product name, standard cost, and time duration for the same cost. (Product cost history)
select p.Name,
		ch.StandardCost,
		DATEDIFF(MONTH,StartDate,EndDate)
from Production.ProductCostHistory ch,
Production.Product p
where p.ProductID = ch.ProductID
and enddate is not null

--61.Find the purchase id where shipment is done 1 month later of order date  
select PurchaseOrderID,
		OrderDate,ShipDate 
from Purchasing.PurchaseOrderHeader
where DATEDIFF(MONTH,OrderDate,ShipDate) = 1
 
--62.Find the sum of total due where shipment is done 1 month later of order date ( purchase order header)
select sum(TotalDue)totaldue 
from Purchasing.PurchaseOrderHeader
where DATEDIFF(month,OrderDate,ShipDate)=1
 
--63. Find the average difference in due date and ship date based on  online order flag

select * from Purchasing.ShipMethod

--64.Display business entity id, marital status, gender, vacationhr, average vacation based on marital status
select BusinessEntityID,
		MaritalStatus,
		Gender,
		VacationHours,
		avg(VacationHours)over(partition by maritalstatus) 
from HumanResources.Employee

use adventureworks2022;

select BusinessEntityID,
		MaritalStatus,
		Gender,
		VacationHours,
		avg(VacationHours)over(partition by maritalStatus) average
from HumanResources.Employee

--65.Display business entity id, marital status, gender, vacationhr, average vacation based on gender

select BusinessEntityID,
		MaritalStatus,
		Gender,
		VacationHours,
		avg(VacationHours)over(partition by gender) average
from HumanResources.Employee

--66.Display business entity id, marital status, gender, vacationhr, 
-- average vacation based on organizational level
select BusinessEntityID,
		MaritalStatus,Gender,
		VacationHours,	
		OrganizationLevel,
		avg(VacationHours)over(partition by organizationlevel) average
from HumanResources.Employee

--67.Display entity id, hire date, department name and department wise count of employee 
-- and count based on organizational level in each dept

select e.BusinessEntityID,
		e.HireDate,
		d.Name,
		count(e.BusinessEntityID)over(partition by d.name)dept_wise_count,
		count(e.BusinessEntityID)over(partition by e.organizationlevel)org_wise_count
from HumanResources.Employee e,
HumanResources.Department d,
HumanResources.EmployeeDepartmentHistory dh
where e.BusinessEntityID = dh.BusinessEntityID
and d.DepartmentID = dh.DepartmentID
and dh.enddate is null


--68.Display department name, average sick leave and sick leave per department

select distinct d.name,
				(select avg(SickLeaveHours) 
				from HumanResources.Employee)total_avg,
				avg(SickLeaveHours)over(partition by d.name)average
from HumanResources.Employee e,
HumanResources.Department d,
HumanResources.EmployeeDepartmentHistory dh
where e.BusinessEntityID = dh.BusinessEntityID 
and d.DepartmentID = dh.DepartmentID

--69.Display the employee details first name, last name,  
--with total count of various shift done by the person and shifts count per department

select p.FirstName,
		p.LastName,
		d.name,
		count(s.ShiftID)over(partition by dh.BusinessEntityID)shift_wise,
		count(s.ShiftID)over(partition by d.name)dept_wise
from HumanResources.Employee e,
HumanResources.Department d,
HumanResources.EmployeeDepartmentHistory dh,
HumanResources.Shift s,
Person.Person p
where e.BusinessEntityID = dh.BusinessEntityID
and d.DepartmentID = dh.DepartmentID
and s.ShiftID = dh.ShiftID
and p.BusinessEntityID = e.BusinessEntityID
and dh.EndDate is null


--70.Display country region code, group average sales quota based on territory id

select CountryRegionCode,
		st.TerritoryID,
		avg(SalesQuota)
from sales.SalesTerritory st,
Sales.SalesTerritoryHistory th,
Sales.SalesPerson sp
where st.TerritoryID = th.TerritoryID
and sp.BusinessEntityID = th.BusinessEntityID
group by CountryRegionCode,st.TerritoryID


--71.Display special offer description, category and avg(discount pct) per the category

select Description,
		Category,
		avg(DiscountPct)over(partition by category)
from sales.SpecialOffer so,
Sales.SpecialOfferProduct sp
where sp.SpecialOfferID = so.SpecialOfferID
and so.DiscountPct>0

--72.Display special offer description, category and avg(discount pct) per the month

select startdate,
		Description,
		Category,
		avg(DiscountPct)over(partition by month(so.startdate))
from sales.SpecialOffer so,
Sales.SpecialOfferProduct sp
where sp.SpecialOfferID = so.SpecialOfferID
and so.DiscountPct>0

--73.Display special offer description, category and avg(discount pct) per the year

select startdate,
		Description,
		Category,
		avg(DiscountPct)over(partition by year(so.startdate))
from sales.SpecialOffer so,
Sales.SpecialOfferProduct sp
where sp.SpecialOfferID = so.SpecialOfferID
and so.DiscountPct>0

--74.Display special offer description, category and avg(discount pct) per the type

select type,
		Description,
		Category,
		avg(DiscountPct)over(partition by type)
from sales.SpecialOffer so,
Sales.SpecialOfferProduct sp
where sp.SpecialOfferID = so.SpecialOfferID
and so.DiscountPct>0

--75.Using rank and dense rand find territory wise top sales person

select st.TerritoryID,
		sp.BusinessEntityID,
		rank()over(partition by st.territoryid order by sp.salesquota),
		dense_rank()over(partition by st.territoryid order by sp.salesquota)
from Sales.SalesTerritory st,
Sales.SalesTerritoryHistory th,
Sales.SalesPerson sp
where st.TerritoryID = th.TerritoryID
and th.BusinessEntityID = sp.BusinessEntityID