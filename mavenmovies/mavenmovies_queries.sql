-- Q1: Monthly Rental Trends
-- Purpose: Analyze how rentals vary across months to identify seasonality

SELECT 
    DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,
    COUNT(*) AS total_rentals
FROM rental
GROUP BY rental_month
ORDER BY rental_month;

-- Q2: Peak Rental Hours
-- Purpose: Identify the hours of the day with highest rental activity

SELECT 
    HOUR(rental_date) AS rental_hour,
    COUNT(*) AS total_rentals
FROM rental
GROUP BY rental_hour
ORDER BY total_rentals DESC;

-- Q3: Top 10 Most Rented Films
-- Purpose: Identify the most popular films based on rental count

SELECT 
    f.title AS film_title,
    COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 10;

-- Q4: Film Categories with Highest Rentals
-- Purpose: Analyze demand across film categories

SELECT 
    c.name AS category,
    COUNT(r.rental_id) AS total_rentals
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_rentals DESC;

-- Q5: Store with Highest Rental Revenue
-- Purpose: Identify which store generates the most revenue

SELECT 
    s.store_id,
    SUM(p.amount) AS total_revenue
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id
ORDER BY total_revenue DESC;

-- Q6: Rental Distribution by Staff
-- Purpose: Measure staff performance based on rental volume

SELECT 
    st.staff_id,
    CONCAT(st.first_name, ' ', st.last_name) AS staff_name,
    COUNT(r.rental_id) AS total_rentals
FROM staff st
JOIN rental r ON st.staff_id = r.staff_id
GROUP BY st.staff_id, staff_name
ORDER BY total_rentals DESC;

-- Q7: Top Customers by Rental Count
-- Purpose: Identify most loyal customers based on rental frequency

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY rental_count DESC
LIMIT 10;

-- Q8: Films Generating Highest Revenue
-- Purpose: Identify films contributing most to revenue

SELECT 
    f.title AS film_title,
    SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title
ORDER BY total_revenue DESC
LIMIT 10;
