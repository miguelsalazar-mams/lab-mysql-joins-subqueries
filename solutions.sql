-- Add you solution queries below:
USE sakila;

#EXERCISE NUMBER 1
SELECT
f.film_id,
f.title,
COUNT(i.inventory_id) AS total_copies
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
WHERE title = 'Hunchback Impossible'
GROUP BY 1,2;

#EXERCISE NUMBER 2
SELECT
title,
length
FROM film 
WHERE
length > (SELECT avg(length) FROM film);

#EXERCISE NUMBER 3
SELECT
first_name,
last_name,
fi.title
FROM actor ac
INNER JOIN (
SELECT
fac.actor_id,
fac.film_id,
f.title
FROM film_actor fac
INNER JOIN film f ON fac.film_id = f.film_id
WHERE f.title = 'Alone Trip') fi
ON ac.actor_id = fi.actor_id;

#EXERCISE NUMBER 4
SELECT
title,
category
FROM film
INNER JOIN (
SELECT
ca.category_id,
fica.film_id as film,
name as category
FROM category ca
INNER JOIN film_category fica ON ca.category_id = fica.category_id
WHERE name = 'family') categories
ON film.film_id = categories.film;

#EXERCISE NUMBER 5
SELECT
first_name,
last_name,
email,
customer.address_id,
total.country
FROM customer
INNER JOIN (
SELECT
address.address_id,
address.city_id,
country.country 
FROM address
LEFT JOIN city ON address.city_id = city.city_id
LEFT JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada') total ON customer.address_id = total.address_id;

#EXERCISE NUMBER 6 
SELECT
    film.title
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = (
    SELECT
        actor.actor_id
    FROM actor
    JOIN film_actor ON actor.actor_id = film_actor.actor_id
    GROUP BY actor.actor_id
    ORDER BY COUNT(film_actor.film_id) DESC
    LIMIT 1
);

#EXERCISE NUMBER 7

SELECT
customer.customer_id,
customer.first_name,
customer.last_name,
rental.inventory_id,
inventory.film_id,
film.title
FROM customer
INNER JOIN rental ON customer.customer_id = rental.customer_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
WHERE customer.customer_id = (
SELECT
customer_id
FROM payment
GROUP BY 1
ORDER BY sum(amount) DESC
LIMIT 1);

#EXERCISE NUMBER 8

SELECT
customer_id,
SUM(amount) AS total_amount_spent
FROM payment
GROUP BY 1
HAVING SUM(amount) > (
SELECT
AVG(total_amount_spent)
FROM(
SELECT
customer_id,
SUM(amount) AS total_amount_spent
FROM payment
GROUP BY 1
ORDER BY 2) as totals);



