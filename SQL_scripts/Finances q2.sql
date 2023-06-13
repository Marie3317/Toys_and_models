#finances : CA des cdes des 2 derniers mois/boutiques	1/2
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

create view request as (
select offices.country, employees.employeeNumber, customers.salesRepEmployeeNumber, customers.customerNumber
from offices
left join employees using (officeCode)
join customers on employees.employeeNumber = customers.salesRepEmployeeNumber);

SELECT
countroff, CA_order, YEAR, MONTH
FROM (select request.country as countroff,
	sum(orderdetails.quantityOrdered * orderdetails.priceEach) as CA_order,
	year(orders.orderDate) as YEAR, month(orders.orderDate) as MONTH,
    orders.status as status
	from request
	join orders using (customerNumber)
	join orderdetails using (orderNumber)
	where orders.orderDate >= DATE_ADD(DATE_ADD(CURRENT_DATE, INTERVAL 1 - DAY(CURRENT_DATE) DAY), INTERVAL -2 MONTH)
	group by countroff, Month, year
	order by Month, CA_order desc) as subQ_office
where subQ_office.status = 'Shipped' or subQ_office.status = 'Resolved';