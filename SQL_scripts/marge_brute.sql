select
products.productLine,
products.productName,
products.buyPrice as price_unit,
sum(products.buyPrice * orderdetails.quantityOrdered) as purchase,
sum(orderdetails.quantityOrdered * orderdetails.priceEach) as total,
(sum(orderdetails.quantityOrdered * orderdetails.priceEach) - sum(products.buyPrice * orderdetails.quantityOrdered)) as marge,
orders.orderDate,
orders.status
from orderdetails
join products using (productCode)
join orders using (orderNumber)
where orders.status = 'Shipped' or orders.status = 'Resolved'
group by products.productName
order by products.productLine;