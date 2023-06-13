#Les 2 meilleurs vendeurs par commandes
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
CREATE VIEW ca_orders AS
(select SUM(d.quantityOrdered * d.priceEach) AS CA,
year(o.orderDate) AS year1, month(o.orderDate) AS month1,
o.customerNumber as cust_nb, d.orderNumber as ord_nb,
o.status
from orderdetails d
join orders o using (orderNumber)
where o.status = 'Shipped' or o.status = 'Resolved'
group by year1, month1, d.orderNumber
order by o.orderDate desc);

CREATE VIEW ca_orders_customer AS
(select ca_orders.year1 as year2, ca_orders.month1 as month2,
ca_orders.cust_nb as cust_nb2, customers.salesRepEmployeeNumber as seller,
sum(ca_orders.CA) as CA2
from ca_orders
join customers on ca_orders.cust_nb = customers.customerNumber
group by year2, month2, ca_orders.cust_nb
order by year2 desc, month2 desc, ca_orders.cust_nb);

select *
from(select ca_orders_customer.year2 as YEAR, ca_orders_customer.month2 as MONTH,
ca_orders_customer.seller as seller_number, ca_orders_customer.CA2 as CA,
CONCAT(employees.lastname,' ', employees.firstname) AS employee_name,
ROW_NUMBER() OVER (PARTITION BY ca_orders_customer.year2, ca_orders_customer.month2 ORDER BY ca_orders_customer.CA2 desc) AS ranking
from ca_orders_customer
join employees on ca_orders_customer.seller = employees.employeeNumber
order by YEAR desc, MONTH desc, CA desc, employee_name) as subQ
;