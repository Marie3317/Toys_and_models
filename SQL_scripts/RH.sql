#RH : chaque mois, les 2 vendeurs avec le CA le plus élevé

CREATE VIEW employee_rank AS
(SELECT CONCAT(employees.lastname,' ', employees.firstname) AS employee_name, customers.salesRepEmployeeNumber, customers.customerNumber
FROM employees
JOIN customers ON customers.salesRepEmployeeNumber = employees.employeeNumber
GROUP BY employee_name 
ORDER BY employee_name ASC);

SELECT employee_rank.employee_name, SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS CA,
YEAR(orders.shippedDate) AS YEAR, month(orders.shippedDate) AS MONTH, 
RANK() OVER (ORDER BY (SUM(orderdetails.quantityOrdered * orderdetails.priceEach ))DESC) AS ranking
FROM employee_rank
JOIN orders USING (customerNumber)
JOIN orderdetails USING (orderNumber)
GROUP BY employee_name
ORDER BY YEAR, CA DESC
;

SELECT * FROM employee_rank;


SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));