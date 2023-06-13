#Les 2 meilleurs vendeurs par CA encaissés
SELECT year(payments.paymentDate) AS year, month(payments.paymentDate) AS month, CONCAT(employees.lastname,' ', employees.firstname) AS employee_name,
SUM(payments.amount) AS CA, employees.employeeNumber as seller_number, 
ROW_NUMBER() OVER (PARTITION BY year(payments.paymentDate), month(payments.paymentDate) ORDER BY SUM(payments.amount) desc) AS ranking
FROM customers
JOIN payments USING (customerNumber)
JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber
GROUP BY year, month, employee_name
order by year desc, month desc, CA desc, employee_name;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));