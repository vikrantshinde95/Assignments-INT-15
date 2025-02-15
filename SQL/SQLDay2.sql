use AdventureWorks2022

--Q9)based on product and product cost history find the name , 
-- service provider time and average Standardcost

SELECT p.Name AS product_name, pch.ModifiedDate AS service_provider_time, AVG(pch.StandardCost) AS average_standard_cost
FROM Production.Product p
JOIN Production.ProductCostHistory pch ON p.ProductID = pch.ProductID
GROUP BY p.Name, pch.ModifiedDate;


--Q10.find products with average cost more than 500

SELECT Name, AVG(StandardCost) AS average_cost
FROM Production.Product
GROUP BY name
HAVING AVG(StandardCost) > 500;


--Q11. find the employee who worked in multiple territory

select * from sales.SalesPerson;
 
select *from sales.SalesTerritory
 
select SalesLastYear , SalesQuota,bonus,
(select FirstName from Person.Person p where p.BusinessEntityID=sp.BusinessEntityID)emp_name,
(select name from sales.SalesTerritory st where st.TerritoryID=sp.TerritoryID)Tname,
(select [Group] from sales.SalesTerritory st where st.TerritoryID=sp.TerritoryID)grp
from sales.SalesPerson sp

--Q13&14. display EMP name, territory name, saleslastyear salesquota and bonus from Germany and United Kingdom

select SalesLastYear, SalesQuota,bonus,
(select FirstName from Person.Person p where p.BusinessEntityID=sp.BusinessEntityID)emp_name,
(select name from sales.SalesTerritory st where st.TerritoryID=sp.TerritoryID)Tname
from sales.SalesPerson sp
where TerritoryID in 
(select TerritoryID from Sales.SalesTerritory 
where name='Germany' or name='United Kingdom')


-- Q15. Find all employees who worked in all North America territory

select (select FirstName from Person.Person p where p.BusinessEntityID=sp.BusinessEntityID)
from sales.SalesPerson sp
where TerritoryID in (select TerritoryID from sales.SalesTerritory where [Group]='North America')

--Q16. find all products in the cart
select (select Name from Production.Product p where p.ProductID=sci.ProductID)p_name
from sales.ShoppingCartItem sci

--Q17. find all the products with special offer
select (select * from sales.SpecialOffer so where so.)
from Sales.SpecialOfferProduct sop

select * 
from Sales.CreditCard