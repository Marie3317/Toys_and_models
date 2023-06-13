#logistique : le stock des 5 pdts les plus commandés
select products.productName, SUM(orderdetails.quantityOrdered) as pdt_sold, products.quantityInStock
FROM products
Join orderdetails USING (productCode)
Join orders USING (orderNumber)
where orders.status = 'Shipped' or orders.status = 'Resolved'
GROUP BY products.productName
Order BY SUM(orderdetails.quantityOrdered) DESC
LIMIT 5
;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));