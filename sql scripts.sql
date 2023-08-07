----------------------------------------------------------------------------------------------------------------------------------

#Products currently in inventory.
  
SELECT productCode, productName, quantityInStock
FROM products;

----------------------------------------------------------------------------------------------------------------------------------

#Determine important factors that may influence inventory reorganization/reduction.
  
SELECT p.productCode, p.productName, p.quantityInStock, p.productLine, p.buyPrice, p.MSRP,
       w.warehouseName, w.warehousePctCap,
       COUNT(od.orderNumber) AS totalOrders
FROM products p
JOIN warehouses w ON p.warehouseCode = w.warehouseCode
JOIN productlines pl ON p.productLine = pl.productLine
LEFT JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.quantityInStock, p.productLine, p.buyPrice, p.MSRP,
         w.warehouseName, w.warehousePctCap
ORDER BY totalOrders DESC;

----------------------------------------------------------------------------------------------------------------------------------

#Where are items stored and could a warehouse be eliminated?
  
SELECT w.warehouseName, COUNT(p.productCode) AS ProductCount, SUM(p.quantityInStock) AS TotalQuantity
FROM products p
JOIN warehouses w ON p.warehouseCode = w.warehouseCode
GROUP BY w.warehouseName
ORDER BY ProductCount;

----------------------------------------------------------------------------------------------------------------------------------

#Where are items stored and could a warehouse be eliminated?
  
SELECT w.warehouseName, COUNT(p.productCode) AS ProductCount, SUM(p.quantityInStock) AS TotalQuantity
FROM products p
JOIN warehouses w ON p.warehouseCode = w.warehouseCode
GROUP BY w.warehouseName
ORDER BY ProductCount;

----------------------------------------------------------------------------------------------------------------------------------

#How are inventory numbers related to sales figures? Are inventory counts appropriate?
  
SELECT p.productCode, p.productName, p.quantityInStock, SUM(od.quantityOrdered) AS TotalQuantityOrdered
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
JOIN orders o ON od.orderNumber = o.orderNumber
GROUP BY p.productCode, p.productName, p.quantityInStock
ORDER BY (p.quantityInStock - TotalQuantityOrdered);

----------------------------------------------------------------------------------------------------------------------------------

#Are we storing non-moving items? Are any items candidates for being dropped?
  
SELECT p.productCode, p.productName, p.quantityInStock, SUM(od.quantityOrdered) AS TotalQuantityOrdered
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.quantityInStock
ORDER BY TotalQuantityOrdered, p.quantityInStock DESC;
