#Question 1: Where are items stored and could a warehouse be eliminated?
SELECT w.warehouseName, COUNT(p.productCode) AS ProductCount, SUM(p.quantityInStock) AS TotalQuantity
FROM products p
JOIN warehouses w ON p.warehouseCode = w.warehouseCode
GROUP BY w.warehouseName
ORDER BY ProductCount;


#Question 2: How are inventory numbers related to sales figures? Are inventory counts appropriate?
SELECT p.productCode, p.productName, p.quantityInStock, SUM(od.quantityOrdered) AS TotalQuantityOrdered
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
JOIN orders o ON od.orderNumber = o.orderNumber
GROUP BY p.productCode, p.productName, p.quantityInStock
ORDER BY (p.quantityInStock - TotalQuantityOrdered);


#Question 3: Are we storing non-moving items? Are any items candidates for being dropped?
SELECT p.productCode, p.productName, p.quantityInStock, SUM(od.quantityOrdered) AS TotalQuantityOrdered
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.quantityInStock
ORDER BY TotalQuantityOrdered, p.quantityInStock DESC;