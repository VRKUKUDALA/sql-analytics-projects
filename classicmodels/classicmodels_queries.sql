-- Q1: Payments on the Latest Payment Date
-- Purpose: Retrieve all payments made on the most recent payment date

SELECT *
FROM payments
WHERE paymentDate = (
    SELECT MAX(paymentDate)
    FROM payments
);

-- Q2: Latest Order Date per Customer
-- Purpose: Show each customer with their most recent order date

SELECT 
    customerNumber,
    MAX(orderDate) AS latest_order_date
FROM orders
GROUP BY customerNumber;

-- Q3: Products with Below-Average Stock
-- Purpose: Identify products whose stock is below their product line average

SELECT 
    productCode,
    productName,
    productLine,
    quantityInStock
FROM products p
WHERE quantityInStock < (
    SELECT AVG(quantityInStock)
    FROM products
    );
    
-- Q4: Customers Whose First Order Was in 2004
-- Purpose: Identify customers whose earliest order occurred in 2004

SELECT 
    customerNumber,
    MIN(orderDate) AS first_order_date
FROM orders
GROUP BY customerNumber
HAVING YEAR(first_order_date) = 2004;

-- Q5: Products Where MSRP Exceeds All Sale Prices
-- Purpose: Find products priced higher than any price they were ever sold at

SELECT 
    p.productCode,
    p.productName,
    p.MSRP
FROM products p
WHERE p.MSRP > ALL (
    SELECT od.priceEach
    FROM orderdetails od
    WHERE od.productCode = p.productCode
);

-- Q6: First Order Date per Customer (CTE)
-- Purpose: Use CTE to identify customers whose first order was in 2004

WITH first_orders AS (
    SELECT 
        customerNumber,
        MIN(orderDate) AS first_order_date
    FROM orders
    GROUP BY customerNumber
)
SELECT *
FROM first_orders
WHERE YEAR(first_order_date) = 2004;

-- Q7: Order Share of Customer Spend
-- Purpose: Calculate each order's contribution to the customer's total spend

WITH order_totals AS (
    SELECT 
        o.orderNumber,
        o.customerNumber,
        SUM(od.quantityOrdered * od.priceEach) AS order_total
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY o.orderNumber, o.customerNumber
),
customer_totals AS (
    SELECT 
        customerNumber,
        SUM(order_total) AS customer_total
    FROM order_totals
    GROUP BY customerNumber
)
SELECT 
    ot.customerNumber,
    ot.orderNumber,
    ot.order_total,
    ct.customer_total,
    ROUND((ot.order_total / ct.customer_total) * 100, 2) AS order_percentage_of_total
FROM order_totals ot
JOIN customer_totals ct ON ot.customerNumber = ct.customerNumber
ORDER BY ot.customerNumber, ot.orderNumber;

-- Q8: 3-Order Moving Average per Customer
-- Purpose: Compute moving average of order totals over current and previous 2 orders

WITH order_totals AS (
    SELECT 
        o.orderNumber,
        o.customerNumber,
        o.orderDate,
        SUM(od.quantityOrdered * od.priceEach) AS order_total
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY o.orderNumber
)
SELECT 
    customerNumber,
    orderNumber,
    orderDate,
    order_total,
    ROUND(AVG(order_total) OVER (
            PARTITION BY customerNumber
            ORDER BY orderDate
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2) AS moving_avg_3_orders
FROM order_totals
ORDER BY customerNumber, orderDate;

