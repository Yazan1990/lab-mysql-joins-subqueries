use sakila;
/*How many copies of the film _Hunchback Impossible_ exist in the inventory system?*/

select f.title, count(i.inventory_id) as inventory_count from film f
join inventory i on f.film_id = i.film_id
where title = 'Hunchback Impossible'
group by f.title;

/*List all films whose length is longer than the average of all the films.*/

select title, length, (select avg(length) from film) as avrage from film where length > (select avg(length) from film);

/*Use subqueries to display all actors who appear in the film _Alone Trip_*/ 

select first_name, last_name from actor 
where actor_id in (select actor_id from film_actor 
where film_id = (select film_id from film where title = 'Alone Trip'));

/*Identify all movies categorized as family films*/ 

select title from film 
where film_id in (select film_id from film_category 
where category_id = (select category_id from category where name = 'Family')); 

/*Get name and email from customers from Canada using subquery then joining*/
select first_name, last_name, email from customer 
where address_id in (select address_id from address 
where city_id in (select city_id from city 
where country_id = (select country_id from country where country = 'Canada')));
select c.first_name, c.last_name, c.email from customer c
join address a on a.address_id = c.address_id
join city ci on ci.city_id = a.city_id
join country co on co.country_id = ci.country_id
where co.country = 'Canada';

/*Which are films starred by the most prolific actor?*/

select title from film 
where film_id in (select film_id from film_actor 
where actor_id = (select actor_id from film_actor group by actor_id order by count(film_id) desc limit 1));

/*Films rented by most profitable customer.*/

select title from film 
where film_id in (select film_id from inventory 
where inventory_id in (select inventory_id from rental 
where customer_id = (select customer_id from payment group by customer_id order by sum(amount) desc limit 1)));

/*Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent 
by each client.*/
select customer_id as clint_id, sum(amount) as total_amount_spent 
from payment
group by customer_id  
having SUM(amount) > (
    SELECT AVG(total_per_customer)
    FROM (
        SELECT SUM(amount) AS total_per_customer
        FROM payment
        GROUP BY customer_id
    ) AS sub
); 
