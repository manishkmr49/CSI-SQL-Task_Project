use [AdventureWorks2022];

--1. List of all customers
SELECT pp.FirstName + ' ' + ISNULL(pp.MiddleName + ' ', '') + pp.LastName AS Full_Name
FROM Person.Person pp
WHERE pp.BusinessEntityID IN (
    SELECT BusinessEntityID
    FROM Sales.Customer
);

--2.list of all customers where company name ending in N
SELECT 
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS ContactName,
    s.Name AS CompanyName,
    a.City,
    MAX(e.EmailAddress) AS Email
FROM 
    Sales.Customer c
JOIN 
    Sales.Store s ON c.StoreID = s.BusinessEntityID
JOIN 
    Person.BusinessEntityContact bec ON c.StoreID = bec.BusinessEntityID
JOIN 
    Person.Person p ON bec.PersonID = p.BusinessEntityID
JOIN 
    Person.BusinessEntityAddress bea ON c.StoreID = bea.BusinessEntityID
JOIN 
    Person.Address a ON bea.AddressID = a.AddressID
LEFT JOIN 
    Person.EmailAddress e ON p.BusinessEntityID = e.BusinessEntityID
WHERE 
    s.Name LIKE '%N'
GROUP BY 
    c.CustomerID, p.FirstName, p.LastName, s.Name, a.City;

--3. list of all customers who live in Berlin or London
SELECT c.CustomerID,p.FirstName,p.LastName,a.City FROM Sales.Customer c JOIN Person.Person p ON c.PersonID = p.BusinessEntityID JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID 
JOIN Person.Address a ON bea.AddressID = a.AddressID WHERE a.City IN ('Berlin', 'London');


--4. list of all customers who live in UK or USA
SELECT c.CustomerID,p.FirstName,p.LastName,a.City,sp.CountryRegionCode FROM Sales.Customer c JOIN Person.Person p ON c.PersonID =    p.BusinessEntityID JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID WHERE sp.CountryRegionCode IN ('UK', 'US');


--5. list of all products sorted by product name
SELECT  ProductID,Name AS ProductName,ProductNumber,Color,ListPrice FROM Production.Product ORDER BY Name;


--6. list of all products where product name starts with an A
SELECT ProductID,Name AS ProductName,ProductNumber,Color,ListPrice FROM Production.Product WHERE Name LIKE 'A%'ORDER BY Name;

--7. List of customers who ever placed an order
SELECT DISTINCT c.CustomerID,p.FirstName,p.LastName FROM Sales.Customer c JOIN Person.Person p ON c.PersonID = p.BusinessEntityID JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID;


--8. list of Customers who live in London and have bought chai
SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS ContactName,
    a.City AS City,
    MAX(e.EmailAddress) AS Email,
    COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.Customer c
ON 
    soh.CustomerID = c.CustomerID
JOIN 
    Person.Person p
ON 
    c.PersonID = p.BusinessEntityID
JOIN 
    Person.Address a
ON 
    p.BusinessEntityID = a.AddressID
JOIN 
    Sales.SalesOrderDetail sod
ON 
    soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Production.Product pr
ON 
    sod.ProductID = pr.ProductID
JOIN 
    Person.EmailAddress e
ON 
    p.BusinessEntityID = e.BusinessEntityID
WHERE 
    a.City = 'London'
    AND pr.Name = 'Chai'
GROUP BY 
    p.FirstName, p.LastName, a.City
ORDER BY 
    NumberOfOrders DESC;

--9. List of customers who never place an order
SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS ContactName,
    a.City AS City,
    MAX(e.EmailAddress) AS Email
FROM 
    Sales.Customer c
JOIN 
    Person.Person p
ON 
    c.PersonID = p.BusinessEntityID
JOIN 
    Person.Address a
ON 
    p.BusinessEntityID = a.AddressID
LEFT JOIN 
    Sales.SalesOrderHeader soh
ON 
    c.CustomerID = soh.CustomerID
LEFT JOIN 
    Person.EmailAddress e
ON 
    p.BusinessEntityID = e.BusinessEntityID
WHERE 
    soh.CustomerID IS NULL
GROUP BY 
    p.FirstName, p.LastName, a.City;

--10. List of customers who ordered Tofu
SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS ContactName,
    a.City AS City,
    MAX(e.EmailAddress) AS Email
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.Customer c
ON 
    soh.CustomerID = c.CustomerID
JOIN 
    Person.Person p
ON 
    c.PersonID = p.BusinessEntityID
JOIN 
    Person.Address a
ON 
    p.BusinessEntityID = a.AddressID
JOIN 
    Sales.SalesOrderDetail sod
ON 
    soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Production.Product pr
ON 
    sod.ProductID = pr.ProductID
JOIN 
    Person.EmailAddress e
ON 
    p.BusinessEntityID = e.BusinessEntityID
WHERE 
    pr.Name = 'Tofu'
GROUP BY 
    p.FirstName, p.LastName, a.City;


--11. Details of first order of the system
SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    CONCAT(p.FirstName, ' ', p.LastName) AS ContactName,
    a.City AS City,
    MAX(e.EmailAddress) AS Email,
    sod.ProductID,
    pr.Name AS ProductName,
    sod.UnitPrice,
    sod.OrderQty,
    sod.UnitPrice * sod.OrderQty AS TotalPrice
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.SalesOrderDetail sod
ON 
    soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Production.Product pr
ON 
    sod.ProductID = pr.ProductID
JOIN 
    Sales.Customer c
ON 
    soh.CustomerID = c.CustomerID
JOIN 
    Person.Person p
ON 
    c.PersonID = p.BusinessEntityID
JOIN 
    Person.Address a
ON 
    p.BusinessEntityID = a.AddressID
JOIN 
    Person.EmailAddress e
ON 
    p.BusinessEntityID = e.BusinessEntityID
WHERE 
    soh.OrderDate = (
        SELECT 
            MIN(OrderDate)
        FROM 
            Sales.SalesOrderHeader
    )
GROUP BY 
    soh.SalesOrderID, soh.OrderDate, p.FirstName, p.LastName, a.City, sod.ProductID, pr.Name, sod.UnitPrice, sod.OrderQty
ORDER BY 
    soh.OrderDate;







--12.Find the details of most expensive order date.
SELECT OrderDate
FROM [Purchasing].[PurchaseOrderHeader]
WHERE TotalDue = (SELECT MAX(TotalDue) FROM [Purchasing].[PurchaseOrderHeader]);

--13. For each order get the OrderlD and Average quantity of items in that order
SELECT SalesOrderID, AVG(OrderQty) AS AverageQuantity
FROM [Sales].[SalesOrderDetail]
GROUP BY SalesOrderID;

--14. For each order get the orderlD, minimum quantity and maximum quantity for that order
SELECT 
    SalesOrderID, 
    MIN(OrderQty) AS MinimumQuantity, 
    MAX(OrderQty) AS MaximumQuantity
FROM 
    Sales.SalesOrderDetail
GROUP BY 
    SalesOrderID;
--15. Get a list of all managers and total number of employees who report to them.
WITH ManagerEmployeeCTE AS (
    SELECT 
        e.BusinessEntityID AS EmployeeID,
        e.OrganizationNode AS EmployeeNode,
        m.BusinessEntityID AS ManagerID,
        m.OrganizationNode AS ManagerNode
    FROM 
        HumanResources.Employee e
    JOIN 
        HumanResources.Employee m ON m.OrganizationNode = e.OrganizationNode.GetAncestor(1)
)
SELECT 
    me.ManagerID,
    CONCAT(mp.FirstName, ' ', mp.LastName) AS ManagerName,
    COUNT(me.EmployeeID) AS TotalEmployees
FROM 
    ManagerEmployeeCTE me
JOIN 
    Person.Person mp ON me.ManagerID = mp.BusinessEntityID
GROUP BY 
    me.ManagerID, mp.FirstName, mp.LastName
ORDER BY 
    TotalEmployees DESC;

--16.Get the OrderlD and the total quantity for each order that has a total quantity of greater than 300.
SELECT 
    SalesOrderID, 
    SUM(OrderQty) AS TotalQuantity
FROM 
    Sales.SalesOrderDetail
GROUP BY 
    SalesOrderID
HAVING 
    SUM(OrderQty) > 300;

--17. list of all orders placed on or after 1996/12/31
SELECT 
    SalesOrderID AS OrderID, 
    OrderDate
FROM 
    Sales.SalesOrderHeader
WHERE 
    OrderDate >= '1996-12-31';



--18. list of all orders shipped to Canada
SELECT 
    so.SalesOrderID,
    so.OrderDate,
    so.ShipDate,
    a.AddressLine1,
    a.City,
    sp.Name AS StateProvince,
    a.PostalCode,
    cr.Name AS CountryRegion
FROM 
    Sales.SalesOrderHeader AS so
JOIN 
    Person.Address AS a
ON 
    so.ShipToAddressID = a.AddressID
JOIN 
    Person.StateProvince AS sp
ON 
    a.StateProvinceID = sp.StateProvinceID
JOIN 
    Person.CountryRegion AS cr
ON 
    sp.CountryRegionCode = cr.CountryRegionCode
WHERE 
    cr.Name = 'Canada';



--19. list of all orders with order total > 200
SELECT 
    SalesOrderID,
    OrderDate,
    ShipDate,
    TotalDue
FROM 
    Sales.SalesOrderHeader
WHERE 
    TotalDue > 200;


--20. List of countries and sales made in each country
SELECT 
    cr.Name AS Country,
    SUM(soh.TotalDue) AS TotalSales
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Person.Address a
ON 
    soh.ShipToAddressID = a.AddressID
JOIN 
    Person.StateProvince sp
ON 
    a.StateProvinceID = sp.StateProvinceID
JOIN 
    Person.CountryRegion cr
ON 
    sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY 
    cr.Name
ORDER BY 
    TotalSales DESC;

--21. List of Customer ContactName and number of orders they placed
SELECT 
    p.FirstName + ' ' + p.LastName AS ContactName,
    COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.Customer c
ON 
    soh.CustomerID = c.CustomerID
JOIN 
    Person.Person p
ON 
    c.PersonID = p.BusinessEntityID
GROUP BY 
    p.FirstName, p.LastName
ORDER BY 
    NumberOfOrders DESC;

--22. List of customer contactnames who have placed more than 3 orders
SELECT 
    p.FirstName + ' ' + p.LastName AS ContactName,
    COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.Customer c
ON 
    soh.CustomerID = c.CustomerID
JOIN 
    Person.Person p
ON 
    c.PersonID = p.BusinessEntityID
GROUP BY 
    p.FirstName, p.LastName
HAVING 
    COUNT(soh.SalesOrderID) > 3
ORDER BY 
    NumberOfOrders DESC;

-- 23 List of discontinued products which were ordered between 1/1/1997 and 1/1/1998
SELECT p.Name AS ProductName
FROM Production.Product p
JOIN Production.TransactionHistory th ON p.ProductID = th.ProductID
WHERE p.DiscontinuedDate BETWEEN '1997-01-01' AND '1998-01-01'
AND th.TransactionDate BETWEEN '1997-01-01' AND '1998-01-01';


-- 24 List of employee firsname, lastName, superviser FirstName, LastName
select 
	p.FirstName,
	p.LastName
from Person.Person p,HumanResources.Employee e
where e.BusinessEntityID = p.BusinessEntityID;

-- 25 List of Employees id and total sale condcuted by employee
SELECT 
    e.BusinessEntityID AS EmployeeID,
    p.FirstName + ' ' + p.LastName AS EmployeeName,
    SUM(od.OrderQty) AS TotalItemsSold
FROM 
    HumanResources.Employee e
INNER JOIN 
    Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN 
    Sales.SalesOrderHeader oh ON e.BusinessEntityID = oh.SalesPersonID
INNER JOIN 
    Sales.SalesOrderDetail od ON oh.SalesOrderID = od.SalesOrderID
GROUP BY 
    e.BusinessEntityID, p.FirstName, p.LastName
ORDER BY 
    TotalItemsSold DESC;


-- 26 list of employees whose FirstName contains character a
SELECT 
    BusinessEntityID,
    FirstName,
    LastName
FROM 
    Person.Person
WHERE 
    FirstName LIKE '%a%';


--27 Query to list managers with more than four direct reports
WITH EmployeeHierarchy AS (
    SELECT 
        e.BusinessEntityID,
        e.OrganizationNode,
        e.OrganizationLevel,
        p.FirstName,
        p.LastName
    FROM 
        HumanResources.Employee e
    JOIN 
        Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
)
SELECT 
    m.BusinessEntityID AS ManagerID,
    m.FirstName,
    m.LastName,
    COUNT(e.BusinessEntityID) AS NumberOfReports
FROM 
    EmployeeHierarchy e
JOIN 
    EmployeeHierarchy m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
GROUP BY 
    m.BusinessEntityID, m.FirstName, m.LastName
HAVING 
    COUNT(e.BusinessEntityID) > 4;


-- 28 List of Orders and ProductNames
SELECT p.Name, sod.SalesOrderID  

FROM Production.Product AS p  

INNER JOIN Sales.SalesOrderDetail AS sod  
ON p.ProductID = sod.ProductID  

ORDER BY p.Name ;

--29 List of orders place by the best customer
WITH CustomerTotalPurchases AS (
    SELECT 
        c.CustomerID,
        SUM(soh.TotalDue) AS TotalPurchaseAmount
    FROM 
        Sales.SalesOrderHeader soh
    JOIN 
        Sales.Customer c ON soh.CustomerID = c.CustomerID
    GROUP BY 
        c.CustomerID
),
RankedCustomers AS (
    SELECT
        CustomerID,
        TotalPurchaseAmount,
        ROW_NUMBER() OVER (ORDER BY TotalPurchaseAmount DESC) AS Rank
    FROM
        CustomerTotalPurchases
)
SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    soh.TotalDue,
    c.CustomerID,
    p.FirstName,
    p.LastName
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN 
    Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE 
    c.CustomerID IN (
        SELECT CustomerID 
        FROM RankedCustomers 
        WHERE Rank <= 10
    )
ORDER BY 
    c.CustomerID, soh.OrderDate;

--30 List of orders placed by customers with no phone number as a proxy for fax
SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    soh.TotalDue,
    c.CustomerID,
    p.FirstName,
    p.LastName,
    a.PostalCode
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN 
    Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN 
    Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID
JOIN 
    Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE 
    pp.PhoneNumber IS NULL -- Using PhoneNumber as a proxy for missing contact details
ORDER BY 
    c.CustomerID, soh.OrderDate;



--31 List of Postal codes where the product Tofu was shipped
DECLARE @ProductID INT;
SELECT @ProductID = ProductID
FROM Production.Product
WHERE Name = 'Tofu';

SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE p.ProductID = @ProductID;


--32. List of product Names that were shipped to France
SELECT DISTINCT
    p.Name AS ProductName
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
JOIN 
    Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN 
    Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN 
    Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE 
    cr.Name = 'France';



--33. List of ProductNames and Categories for the supplier ‘Specialty Biscuits, Ltd.
SELECT 
    p.Name AS ProductName, 
    pc.Name AS CategoryName
FROM 
    Production.Product p
INNER JOIN 
    Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
INNER JOIN 
    Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
INNER JOIN 
    Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN 
    Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
WHERE 
    v.Name = 'Specialty Biscuits, Ltd'
ORDER BY 
    ProductName;




--34. List of products that were never ordered
SELECT 
    p.ProductID,
    p.Name AS ProductName
FROM 
    Production.Product p
LEFT JOIN 
    Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE 
    sod.ProductID IS NULL
ORDER BY 
    p.ProductID;



--35. List of products where units in stock is less than 10 and units on order are 0.
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    pi.Quantity AS UnitsInStock
FROM 
    Production.Product p
INNER JOIN 
    Production.ProductInventory pi ON p.ProductID = pi.ProductID
LEFT JOIN 
    Purchasing.PurchaseOrderDetail pod ON p.ProductID = pod.ProductID
    AND pod.OrderQty > 0
    AND pod.ReceivedQty = 0
WHERE 
    pi.Quantity < 10
    AND pod.ProductID IS NULL
ORDER BY 
    p.ProductID;


--36. List of top 10 countries by sales
SELECT TOP 10
    sp.Name AS Country,
    SUM(soh.TotalDue) AS TotalSales
FROM
    Sales.SalesOrderHeader soh
INNER JOIN
    Sales.Customer c ON soh.CustomerID = c.CustomerID
INNER JOIN
    Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
INNER JOIN
    Person.Address a ON bea.AddressID = a.AddressID
INNER JOIN
    Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
INNER JOIN
    Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY
    sp.Name
ORDER BY
    TotalSales DESC;






--37. Number of orders each employee has taken for customers with CustomerlDs between A and AO
SELECT 
    e.BusinessEntityID AS EmployeeID, 
    COUNT(o.SalesOrderID) AS OrderCount
FROM 
    Sales.SalesOrderHeader o
INNER JOIN 
    Sales.Customer c ON o.CustomerID = c.CustomerID
INNER JOIN 
    HumanResources.Employee e ON o.SalesPersonID = e.BusinessEntityID
INNER JOIN 
    Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE 
    p.LastName BETWEEN 'A' AND 'AO'
GROUP BY 
    e.BusinessEntityID
ORDER BY 
    e.BusinessEntityID;

--38. Orderdate of most expensive order
SELECT 
    soh.OrderDate
FROM 
    Sales.SalesOrderHeader soh
WHERE 
    soh.TotalDue = (
        SELECT 
            MAX(TotalDue)
        FROM 
            Sales.SalesOrderHeader
    );


--39. Product name and total revenue from that product
SELECT 
    pr.Name AS ProductName,
    SUM(sod.UnitPrice * sod.OrderQty) AS TotalRevenue
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product pr
ON 
    sod.ProductID = pr.ProductID
GROUP BY 
    pr.Name
ORDER BY 
    TotalRevenue DESC;


--40. Supplierid and number of products offered 
SELECT 
    pv.BusinessEntityID AS SupplierID,
    COUNT(pv.ProductID) AS NumberOfProductsOffered
FROM 
    Purchasing.ProductVendor pv
GROUP BY 
    pv.BusinessEntityID
ORDER BY 
    NumberOfProductsOffered DESC;


--41. Top ten customers based on their business
SELECT TOP 10
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    SUM(sod.UnitPrice * sod.OrderQty) AS TotalRevenue
FROM 
    Sales.Customer c
JOIN 
    Person.Person p
ON 
    c.PersonID = p.BusinessEntityID
JOIN 
    Sales.SalesOrderHeader soh
ON 
    c.CustomerID = soh.CustomerID
JOIN 
    Sales.SalesOrderDetail sod
ON 
    soh.SalesOrderID = sod.SalesOrderID
GROUP BY 
    c.CustomerID, p.FirstName, p.LastName
ORDER BY 
    TotalRevenue DESC;


--42. What is the total revenue of the company.
SELECT 
    SUM(sod.UnitPrice * sod.OrderQty) AS TotalRevenue
FROM 
    Sales.SalesOrderDetail sod;
