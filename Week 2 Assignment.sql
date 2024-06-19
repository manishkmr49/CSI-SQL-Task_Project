USE AdventureWorks2019;
GO

-- Create dummy Orders table
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL
    DROP TABLE dbo.Orders;
GO

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);
GO

-- Create dummy OrderDetails table
IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL
    DROP TABLE dbo.OrderDetails;
GO

CREATE TABLE dbo.OrderDetails (
    OrderID INT,
    ProductID INT,
    UnitPrice MONEY,
    Quantity INT,
    Discount DECIMAL(4,2),
    PRIMARY KEY (OrderID, ProductID)
);
GO

-- Create dummy Products table
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
    DROP TABLE dbo.Products;
GO

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    UnitsInStock INT,
    ReorderLevel INT,
    UnitPrice MONEY
);
GO

-- Create dummy Customers table
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL
    DROP TABLE dbo.Customers;
GO

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CompanyName NVARCHAR(100)
);
GO

-- Create dummy Suppliers table
IF OBJECT_ID('dbo.Suppliers', 'U') IS NOT NULL
    DROP TABLE dbo.Suppliers;
GO

CREATE TABLE dbo.Suppliers (
    SupplierID INT PRIMARY KEY,
    CompanyName NVARCHAR(100)
);
GO

-- Create dummy Categories table
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL
    DROP TABLE dbo.Categories;
GO

CREATE TABLE dbo.Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(100)
);
GO
USE AdventureWorks2019;
GO

-- Drop and create InsertOrderDetails procedure
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertOrderDetails')
    DROP PROCEDURE InsertOrderDetails;
GO

CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT,
    @Discount DECIMAL(4,2) = 0
AS
BEGIN
    DECLARE @Stock INT, @ReorderLevel INT, @ProductUnitPrice MONEY;

    -- Get the current stock and reorder level for the product
    SELECT @Stock = UnitsInStock, @ReorderLevel = ReorderLevel, @ProductUnitPrice = UnitPrice
    FROM Products
    WHERE ProductID = @ProductID;

    -- Check if there is enough stock
    IF @Stock < @Quantity
    BEGIN
        PRINT 'Not enough stock available.';
        RETURN;
    END

    -- Use product's unit price if not provided
    IF @UnitPrice IS NULL
    BEGIN
        SET @UnitPrice = @ProductUnitPrice;
    END

    -- Insert order details
    INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
    VALUES (@OrderID, @ProductID, @UnitPrice, @Quantity, @Discount);

    -- Check if the order was inserted successfully
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to place the order. Please try again.';
        RETURN;
    END

    -- Adjust the quantity in stock
    UPDATE Products
    SET UnitsInStock = UnitsInStock - @Quantity
    WHERE ProductID = @ProductID;

    -- Check if the quantity in stock drops below the reorder level
    IF @Stock - @Quantity < @ReorderLevel
    BEGIN
        PRINT 'The quantity in stock of this product has dropped below its reorder level.';
    END
END
GO

-- Drop and create UpdateOrderDetails procedure
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'UpdateOrderDetails')
    DROP PROCEDURE UpdateOrderDetails;
GO

CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT = NULL,
    @Discount DECIMAL(4,2) = NULL
AS
BEGIN
    DECLARE @CurrentQuantity INT, @NewQuantity INT, @Stock INT, @ReorderLevel INT;

    -- Get the current quantity and stock
    SELECT @CurrentQuantity = Quantity
    FROM OrderDetails
    WHERE OrderID = @OrderID AND ProductID = @ProductID;

    SELECT @Stock = UnitsInStock, @ReorderLevel = ReorderLevel
    FROM Products
    WHERE ProductID = @ProductID;

    -- Update the order details
    UPDATE OrderDetails
    SET UnitPrice = ISNULL(@UnitPrice, UnitPrice),
        Quantity = ISNULL(@Quantity, Quantity),
        Discount = ISNULL(@Discount, Discount)
    WHERE OrderID = @OrderID AND ProductID = @ProductID;

    -- Adjust the quantity in stock
    IF @Quantity IS NOT NULL
    BEGIN
        SET @NewQuantity = @Quantity;
        UPDATE Products
        SET UnitsInStock = UnitsInStock - (@NewQuantity - @CurrentQuantity)
        WHERE ProductID = @ProductID;

        -- Check if the quantity in stock drops below the reorder level
        IF @Stock - (@NewQuantity - @CurrentQuantity) < @ReorderLevel
        BEGIN
            PRINT 'The quantity in stock of this product has dropped below its reorder level.';
        END
    END
END
GO

-- Drop and create GetOrderDetails procedure
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'GetOrderDetails')
    DROP PROCEDURE GetOrderDetails;
GO

CREATE PROCEDURE GetOrderDetails
    @OrderID INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM OrderDetails WHERE OrderID = @OrderID)
    BEGIN
        PRINT 'The OrderID ' + CAST(@OrderID AS VARCHAR) + ' does not exist';
        RETURN 1;
    END

    SELECT * FROM OrderDetails WHERE OrderID = @OrderID;
END
GO

-- Drop and create DeleteOrderDetails procedure
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'DeleteOrderDetails')
    DROP PROCEDURE DeleteOrderDetails;
GO

CREATE PROCEDURE DeleteOrderDetails
    @OrderID INT,
    @ProductID INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM OrderDetails WHERE OrderID = @OrderID AND ProductID = @ProductID)
    BEGIN
        PRINT 'Invalid OrderID or ProductID.';
        RETURN -1;
    END

    DELETE FROM OrderDetails
    WHERE OrderID = @OrderID AND ProductID = @ProductID;
END
GO

-- Drop and create FormatDateMMDDYYYY function
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'FormatDateMMDDYYYY')
    DROP FUNCTION FormatDateMMDDYYYY;
GO

CREATE FUNCTION FormatDateMMDDYYYY(@InputDate DATETIME)
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN CONVERT(VARCHAR(10), @InputDate, 101);
END
GO

-- Drop and create FormatDateYYYYMMDD function
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'FormatDateYYYYMMDD')
    DROP FUNCTION FormatDateYYYYMMDD;
GO

CREATE FUNCTION FormatDateYYYYMMDD(@InputDate DATETIME)
RETURNS VARCHAR(8)
AS
BEGIN
    RETURN CONVERT(VARCHAR(8), @InputDate, 112);
END
GO

-- Drop and create vwCustomerOrders view
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vwCustomerOrders')
    DROP VIEW vwCustomerOrders;
GO

CREATE VIEW vwCustomerOrders AS
SELECT c.CompanyName, o.OrderID, o.OrderDate, od.ProductID, p.ProductName, od.Quantity, od.UnitPrice, (od.Quantity * od.UnitPrice) AS TotalPrice
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Customers c ON o.CustomerID = c.CustomerID;
GO

-- Drop and create vwCustomerOrdersYesterday view
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vwCustomerOrdersYesterday')
    DROP VIEW vwCustomerOrdersYesterday;
GO

CREATE VIEW vwCustomerOrdersYesterday AS
SELECT c.CompanyName, o.OrderID, o.OrderDate, od.ProductID, p.ProductName, od.Quantity, od.UnitPrice, (od.Quantity * od.UnitPrice) AS TotalPrice
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate = CAST(GETDATE() - 1 AS DATE);
GO

-- Drop and create MyProducts view
IF EXISTS (SELECT * FROM sys.views WHERE name = 'MyProducts')
    DROP VIEW MyProducts;
GO

CREATE VIEW MyProducts AS
SELECT p.ProductID, p.ProductName, p.UnitsInStock, p.UnitPrice, s.CompanyName, c.CategoryName
FROM Products p
JOIN Suppliers s ON p.ProductID = s.SupplierID -- This join is likely incorrect and should be adjusted
JOIN Categories c ON p.ProductID = c.CategoryID; -- This join is likely incorrect and should be adjusted
GO
