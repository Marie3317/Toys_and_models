#nb de produits vendus par catégorie et par mois et années
SELECT productlines.productLine, SUM(orderdetails.quantityOrdered) AS product_sold,
YEAR(orders.orderDate) AS YEAR, MONTH(orders.orderDate) AS MONTH,
(SUM(orderdetails.quantityOrdered) - LAG(SUM(orderdetails.quantityOrdered)) OVER (partition by productLine ORDER BY month (orders.orderDate) ASC,
year(orders.orderDate) ASC)) AS revenue_growth,
(sum(orderdetails.quantityOrdered) - LAG(sum(orderdetails.quantityOrdered)) OVER (partition by productLine ORDER BY month (orders.orderDate) ASC,
year(orders.orderDate) ASC)) / (LAG(sum(orderdetails.quantityOrdered)) OVER (partition by productLine ORDER BY month (orders.orderDate) ASC,
year(orders.orderDate) ASC)) as change_rate_percent
from products
join productlines on products.productLine = productlines.productLine
join orderdetails on products.productCode = orderdetails.productCode
join orders on orderdetails.orderNumber = orders.orderNumber
WHERE YEAR(orders.orderDate) IS NOT NULL AND orders.status = 'Shipped' or orders.status = 'Resolved'
group by MONTH, YEAR, productLine;