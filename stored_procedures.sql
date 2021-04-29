# Lab | Stored procedures
# In this lab, we will continue working on the Sakila database of movie rentals.

use sakila;

# Instructions
# Write queries, stored procedures to answer the following questions:

# In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
# Convert the query into a simple stored procedure. Use the following query:

  #select first_name, last_name, email
  #from customer
  #join rental on customer.customer_id = rental.customer_id
  #join inventory on rental.inventory_id = inventory.inventory_id
  #join film on film.film_id = inventory.film_id
  #join film_category on film_category.film_id = film.film_id
  #join category on category.category_id = film_category.category_id
  #where category.name = "Action"
  #group by first_name, last_name, email;

drop procedure if exists proc_action;

delimiter //
create Procedure proc_action()
begin
 select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
end;
//
delimiter ;

call proc_action();

# Now keep working on the previous stored procedure to make it more dynamic. 
# Update the stored procedure in a such manner that it can take a string argument for the category name and return the results 
# for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.

drop procedure if exists proc_action2;

delimiter //
create Procedure proc_action2(in param varchar(50))
begin
 select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name COLLATE utf8mb4_general_ci = param
  group by first_name, last_name, email;
end;
//
delimiter ;

call proc_action2("Action");

call proc_action2("Travel");

# Write a query to check the number of movies released in each movie category. 
# Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
# Pass that number as an argument in the stored procedure.

drop procedure if exists num_movie;

delimiter ++
create procedure num_movie (in param2 int)
begin
  select name as category_name, count(film_category.film_id) as number_movie
from category, film_category 
where category.category_id=film_category.category_id
group by category_name
having count(film_category.film_id) COLLATE utf8mb4_general_ci > param2;
end ++
delimiter ;

call num_movie(50);


delimiter $$
create procedure num_movies (in param2 int)
begin
  select name as category_name, count(f.film_id) as number_movie
from category c
join film_category f on c.category_id = f.category_id
group by category_name
having count(f.film_id) COLLATE utf8mb4_general_ci > param2;
end $$
delimiter ;

call num_movies(52);
