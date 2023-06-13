#finances : CA des cdes des 2 derniers mois/pays	1/2
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
select
country, CA, YEAR, MONTH
from(select customers.country as country,
	sum(orderdetails.quantityOrdered * orderdetails.priceEach) as CA,
	year(orders.shippedDate) as YEAR, month(orders.shippedDate) as MONTH,
    orders.status as status
from customers
join orders on orders.customerNumber = customers.customerNumber
join orderdetails on orderdetails.orderNumber = orders.orderNumber
where orders.shippedDate >= DATE_ADD(DATE_ADD(CURRENT_DATE, INTERVAL 1 - DAY(CURRENT_DATE) DAY), INTERVAL -2 MONTH)
group by country, Month, year) as CA_glob
where CA_glob.status = 'Shipped' or CA_glob.status = 'Resolved';