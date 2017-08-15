USE Northwind
--2.1
SELECT CustomerID, CompanyName FROM Customers WHERE City = 'London' AND CustomerID IN 
(SELECT CustomerID FROM Orders GROUP BY CustomerID HAVING COUNT(CustomerID) < 5);
--2.1
SELECT Customers.CustomerID, Customers.CompanyName FROM Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID  WHERE City = 'London'
GROUP BY Customers.CustomerID, Customers.CompanyName HAVING COUNT(Customers.CustomerID) < 5 ORDER BY COUNT(Customers.CustomerID) DESC;
--2.2
SELECT * FROM [Order Details] WHERE ProductID IN (SELECT ProductID FROM Products WHERE ProductName = 'Pavlova') 
AND UnitPrice*Quantity*(1-Discount) >= 800;
--2.3
SELECT RegionDescription FROM Region WHERE RegionID IN
(SELECT RegionID FROM Territories WHERE TerritoryID IN
(SELECT TerritoryID FROM EmployeeTerritories WHERE EmployeeID IN
(SELECT EmployeeID FROM Orders WHERE OrderID IN
(SELECT OrderID FROM [Order Details] WHERE ProductID IN
(SELECT ProductID FROM Products WHERE ProductName = 'Chocolade')))));
--2.4
SELECT OrderID, CompanyName FROM Orders JOIN Customers ON Orders.CustomerID = Customers.CustomerID WHERE Freight BETWEEN 25 AND 50 AND OrderID IN
(SELECT OrderID FROM [Order Details] WHERE ProductID IN
(SELECT ProductID FROM Products WHERE ProductName = 'Tofu'));
--2.5
SELECT City FROM Customers WHERE City IN (SELECT City FROM Employees) GROUP BY City;
--2.6
SELECT TOP 5 Products.ProductID, ProductName, SUM(Quantity) AS Quantity, EmployeeID, LastName, FirstName, Title FROM Products JOIN 
(SELECT ProductID, Quantity, EmployeeID, LastName, FirstName, Title FROM [Order Details] 
JOIN (SELECT OrderID, Employees.EmployeeID, LastName, FirstName, Title
FROM Employees JOIN (SELECT OrderID, EmployeeID FROM Orders WHERE CustomerID IN (SELECT CustomerID FROM Customers WHERE Country='Germany')) AS Temp
ON Employees.EmployeeID=Temp.EmployeeID) AS Temp2 ON [Order Details].OrderID=Temp2.OrderID) AS Temp3 ON Products.ProductID=Temp3.ProductID
GROUP BY Products.ProductID, ProductName, EmployeeID, LastName, FirstName, Title
ORDER BY Quantity DESC;
--2.7
SELECT TOP 5 Products.ProductID, ProductName, SUM(Quantity*Temp3.UnitPrice*(1-Discount)) AS SalesResult, EmployeeID, LastName, FirstName, Title FROM Products JOIN 
(SELECT ProductID, Quantity, UnitPrice, Discount, EmployeeID, LastName, FirstName, Title FROM [Order Details] 
JOIN (SELECT OrderID, Employees.EmployeeID, LastName, FirstName, Title
FROM Employees JOIN (SELECT OrderID, EmployeeID FROM Orders WHERE CustomerID IN (SELECT CustomerID FROM Customers WHERE Country='Germany')) AS Temp
ON Employees.EmployeeID=Temp.EmployeeID) AS Temp2 ON [Order Details].OrderID=Temp2.OrderID) AS Temp3 ON Products.ProductID=Temp3.ProductID
GROUP BY Products.ProductID, ProductName, EmployeeID, LastName, FirstName, Title
ORDER BY SalesResult DESC;
--2.8
SELECT * FROM Products JOIN Suppliers ON Products.SupplierID=Suppliers.SupplierID;
SELECT * FROM Products LEFT JOIN Suppliers ON Products.SupplierID=Suppliers.SupplierID;
SELECT * FROM Products RIGHT JOIN Suppliers ON Products.SupplierID=Suppliers.SupplierID;
SELECT * FROM Products FULL JOIN Suppliers ON Products.SupplierID=Suppliers.SupplierID;
--2.9
SELECT EmployeeID, LastName, FirstName, Title, AVG(UnitPrice*Quantity*(1-Discount)) AS Avarage_SalesResult FROM 
(SELECT UnitPrice, Quantity, Discount, EmployeeID, LastName, FirstName, Title FROM [Order Details] JOIN 
(SELECT Orders.EmployeeID, OrderID, LastName, FirstName, Title FROM Employees JOIN 
Orders ON Orders.EmployeeID=Employees.EmployeeID) AS Temp ON [Order Details].OrderID=Temp.OrderID) AS Temp2
GROUP BY EmployeeID, LastName, FirstName, Title
ORDER BY Avarage_SalesResult DESC;