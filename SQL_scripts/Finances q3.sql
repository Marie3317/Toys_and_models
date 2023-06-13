create view total_order as(
select sum(orderdetails.quantityOrdered * orderdetails.priceEach) as total_order
from orderdetails
join orders using(orderNumber)
where orders.status = 'Shipped' or orders.status = 'Resolved');

create view total_payment as(
select sum(amount) as total_payment
from payments);

select (total_order.total_order - total_payment.total_payment) as diff
from total_payment, total_order;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

create view global_order as(
select orders.customerNumber, customers.customerName,
 sum(orderdetails.quantityOrdered * orderdetails.priceEach) as total_order
from orders
join orderdetails using(orderNumber)
join customers using(customerNumber)
where orders.status = 'Shipped' or orders.status = 'Resolved'
group by customers.customerName
order by total_order desc
);


select
*
from( select
global_order.customerNumber,
global_order.customerName,
global_order.total_order as total_cde,
sum(payments.amount) as total_payment,
(global_order.total_order - sum(payments.amount)) as diff
from global_order
join payments using(customerNumber)
group by global_order.customerName
order by diff desc) as diff_subq
where diff_subq.diff <> 0;