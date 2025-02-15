use AdventureWorks2022;

--Q1.find the average currency rate conversion from USD to Algerian Dinar and Australian Doller 

select * from Sales.Currency where name ='Algerian Dinar'
select * from Sales.CurrencyRate
select * from Sales.CountryRegionCurrency 

select cr.ToCurrencyCode,cr.FromCurrencyCode,AVG(AverageRate)
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

select p.Name,v.Name,count(*) cnt
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

select distinct p.Name,p.ProductID,sm.Name
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

select p.Name,so.taxAmt,SO.OrderDate 
from Sales.SalesOrderDetail s, 
Sales.SalesOrderHeader so,
Production.Product p 
where SO.OrderDate  IN (SELECT SOH.ORDERDATE FROM Sales.SalesOrderHeader SOH
UNION
SELECT OH.ShipDate FROM Sales.SalesOrderHeader OH) 
and s.salesorderid=so.salesorderid 
and s.productid=p.productid  

select  from Sales.SalesOrderHeader so 

--Q7. find the average days required to ship the product based on shipment type.
select sm.Name , avg(datediff(day,h.OrderDate,h.ShipDate))
from Purchasing.PurchaseOrderHeader h,
Purchasing.ShipMethod sm
where h.ShipMethodID = sm.Shipselect *
from Purchasing.ShipMethod

select sm.Name , avg(datediff(day,h.OrderDate,h.ShipDate))
from Sales.salesOrderHeader h,
Purchasing.ShipMethod sm
where h.ShipMethodID = sm.ShipMethodID
group by sm.name
 
 
--Q8. find the name of employees working in day shift
 
select * from Person.Person where BusinessEntityID in (
select BusinessEntityID from HumanResources.EmployeeDepartmentHistory  where ShiftID in(
select ShiftID from HumanResources.Shift where name ='day'))

select count(*)
from HumanResources.Shift s,
HumanResources.EmployeeDepartmentHistory ed
where s.ShiftID = ed.ShiftID
and s.Name = 'Day'
and EndDate is NULL

--Q9.based on product and product cost history find the name , 
--service provider time and average Standardcost

SELECT * from Production.Product

select p.Name,min(pch.StartDate),
max(pch.EndDate),
datediff(day,min(pch.StartDate),max(pch.EndDate)) as dd, 
avg(pch.StandardCost)
from Production.Product p,
Production.ProductCostHistory pch
where pch.ProductID = p.ProductID
group by p.Name

--Q10.find products with average cost more than 500

SELECT Name,avg(StandardCost) average
from Production.Product
group by Name
having avg(StandardCost) > 500
order by avg(StandardCost)

--Q11.find the employee who worked in multiple territory

select * from Sales.SalesTerritory
select * from Sales.SalesTerritoryHistory
select * from Person.Person

select pp.FirstName , count(*) cnt
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

select pm.Name,pd.Description
from Production.ProductModel pm,
Production.ProductDescription pd,
Production.Culture c,
Production.ProductModelProductDescriptionCulture ppd
where pm.ProductModelID = ppd.ProductModelID
and c.CultureID = ppd.CultureID
and ppd.ProductDescriptionID = pd.ProductDescriptionID
and c.Name like '%Arabic'

--Q13.display empname,terriroty name,group,saleslastyear salesquota,bonus

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

--Q14.display EMP name, territory name, saleslastyear salesquota 
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

--Q15.Find all employees who worked in all North America territory
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

--Q16.find all products in the cart

select * from Sales.ShoppingCartItem
select *from Production.Product

select * from Production.Product
where ProductID in
(select ProductID
from Sales.ShoppingCartItem);

--Q17.find the product with special offer
select * from Sales.SpecialOffer;
select * from Sales.SpecialOfferProduct;
select * from Production.Product


select
p.productid,
p.name as prodname,
sop.specialofferid
from production.product p,
Sales.SpecialOfferProduct sop
where p.ProductID = sop.ProductID;

--Q18. find the employee's name,job title,credit card details whose
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

select BusinessEntityID ,count(*) cnt
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
 
select  p.FirstName,p.LastName,a.AddressLine1,att.AddressTypeID
from Person.BusinessEntityAddress bea,
Person.Address a,
Person.Person p,
Person.AddressType att
where a.AddressID = bea.AddressID and
att.AddressTypeID = bea.AddressTypeID 
and p.BusinessEntityID = bea.BusinessEntityID
 
--Q22. Find the name of employees working in group of North America territory

select p.FirstName,
		p.LastName,
		st.Name,
		st.[group] 
from Person.Person p,
Sales.SalesTerritory st,
Sales.SalesTerritoryHistory sth
where st.TerritoryID = sth.TerritoryID and
sth.BusinessEntityID = p.BusinessEntityID
and st.[Group] = 'North America'
 
 
--Q23 & 24.display the personal details of  employee whose payment is revised for more than once.
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


select id,DATEDIFF(day,rim,rm) dy 
from
(select id,max(rid) rm,max(ro) rim 
from
(select BusinessEntityID id, RateChangeDate rid, LAG(ratechangedate,1)
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
 
--Q27.check the department having more salary revision
 
select d.Name,
		count(*) rev
from HumanResources.EmployeePayHistory ph,
HumanResources.EmployeeDepartmentHistory dh,
HumanResources.Department d
where dh.BusinessEntityID = ph.BusinessEntityID and
d.DepartmentID = dh.DepartmentID
group by d.Name
order by count(*) desc
 
--Q28.check the employee whose payment is not yet revised
select * from Person.Person where BusinessEntityID not in 
(select BusinessEntityID from HumanResources.EmployeePayHistory
)
 
--Q29. find the job title having more revised payments

select e.JobTitle,
		count(* )
from HumanResources.EmployeePayHistory ph,
HumanResources.Employee e
where e.BusinessEntityID = ph.BusinessEntityID
group by e.JobTitle
having count(*)>1
order by count(*) desc

select e.JobTitle, count(*) cnt
from HumanResources.Employee e
where e.BusinessEntityID in (select ep.BusinessEntityID
      from HumanResources.EmployeePayHistory ep
	  group by ep.BusinessEntityID
	  having count(*) > 1)
group by e.JobTitle

--using inline view
select JobTitle,count(*)
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



 
--Q31. find the colour wise count of the product (tbl: product)
 
select Color,
		count(*) prodt_c
from Production.Product
group by Color
 
--Q32. find out the product who are not in position to sell 
--(hint: check the sell start and end date)
select name,
		SellEndDate
from Production.Product
where SellEndDate is not null
 
--Q33.  find the class wise, style wise average standard cost
 
select class,
		Style ,
		avg(StandardCost) average
from Production.Product 
where Class is not null and Style is not null
group by class,style
 
--Q34.check colour wise standard cost
select Color,sum(StandardCost) total
from Production.Product
group by color
 
 
--Q35. find the product line wise standard cost
 
select ProductLine,
		sum(StandardCost)total
from Production.Product
where ProductLine is not null
group by ProductLine
 
--Q36.Find the state wise tax rate 
--(hint: Sales.SalesTaxRate, Person.StateProvince)
 
select * from Sales.SalesTaxRate
select * from Person.StateProvince
 
select sp.StateProvinceID,
		sum(TaxRate)total 
from Sales.SalesTaxRate tr,
Person.StateProvince sp
where sp.StateProvinceID = tr.StateProvinceID
group by sp.StateProvinceID

--Q38. Calculate age of employees

select BusinessEntityID,
		BirthDate,
		DATEDIFF(year, BirthDate, GETDATE()) Age
from HumanResources.Employee;

--Q39.Calculate the year of experience of the employee based on hire date
select BusinessEntityID,
		HireDate,
		DATEDIFF(year, HireDate, GETDATE()) Experience
from HumanResources.Employee;

--Q40.Find the age of employee at the time of joining

select BusinessEntityID,
		BirthDate,
		HireDate,
		DATEDIFF(year, BirthDate, HireDate) age_hiring
from HumanResources.Employee

--Q41.Find the average age of male and female

select
		Gender,
		AVG(DATEDIFF(year,BirthDate,GETDATE())) avg_age
from HumanResources.Employee
group by Gender

--Q42.Which product is the oldest product as on the date (refer  the product sell start date)


select ProductID,name , DATEDIFF(YEAR,SellStartDate,GETDATE()) dt
from Production.Product
where SellEndDate is null
order by dt desc