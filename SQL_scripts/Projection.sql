CREATE VIEW prevision AS (
SELECT productlines.productLine, YEAR(orders.orderDate) AS YEAR,
SUM(orderdetails.quantityOrdered*orderdetails.priceEach) AS CA,
(SUM(orderdetails.quantityOrdered*orderdetails.priceEach) - LAG(SUM(orderdetails.quantityOrdered*orderdetails.priceEach))
OVER (partition by productLine ORDER BY YEAR (orders.orderDate) ASC)) AS revenue_growth,
(sum(orderdetails.quantityOrdered*orderdetails.priceEach) - LAG(sum(orderdetails.quantityOrdered*orderdetails.priceEach))
OVER (partition by productLine ORDER BY YEAR (orders.orderDate) ASC)) / (LAG(sum(orderdetails.quantityOrdered*orderdetails.priceEach))
OVER (partition by productLine ORDER BY YEAR (orders.orderDate) ASC)) as change_rate_percent
from products
join productlines on products.productLine = productlines.productLine
join orderdetails on products.productCode = orderdetails.productCode
join orders on orderdetails.orderNumber = orders.orderNumber
WHERE YEAR(orders.orderDate) IS NOT NULL AND YEAR(orders.orderDate) < 2023
group by productLine, year
ORDER BY productLine, YEAR);

SELECT *, (prevision.CA+(prevision.CA *prevision.change_rate_percent)) AS CA_2023
FROM prevision
WHERE prevision.YEAR = 2022;