/* Lab | SQL Iterations
In this lab, we will continue working on the Sakila database of movie rentals.

Instructions
Write queries to answer the following questions:

Write a query to find what is the total business done by each store.
Convert the previous query into a stored procedure.
Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 
Call the stored procedure and print the results.
In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.*/

-- 1. Write a query to find what is the total business done by each store.
use sakila;
select s.store_id, round(sum(p.amount),0) as 'sales_amount'
from store s
join inventory i on i.store_id = s.store_id
join rental r on r.inventory_id = i.inventory_id
join payment p on  p.rental_id = r.rental_id
group by s.store_id;

-- 2. Convert the previous query into a stored procedure.

drop procedure if exists pro_sales_store;

delimiter //
create procedure pro_sales_store()
begin 
  	select s.store_id, round(sum(p.amount),0) as 'sales_amount'
	from store s
	join inventory i on i.store_id = s.store_id
	join rental r on r.inventory_id = i.inventory_id
	join payment p on  p.rental_id = r.rental_id
	group by s.store_id;
end;
// delimiter ;
call pro_sales_store();

-- 3. Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

drop procedure if exists pro_sales_store;

delimiter //
create procedure pro_sales_store(In param_store int (1))
begin 
  	select s.store_id, round(sum(p.amount),0) as 'sales_amount'
	from store s
	join inventory i on i.store_id = s.store_id
	join rental r on r.inventory_id = i.inventory_id
	join payment p on  p.rental_id = r.rental_id
	where s.store_id = param_store
	group by s.store_id;
end;
// delimiter ;

call pro_sales_store(1);

-- 4. Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 

drop procedure if exists pro_sales_store;

delimiter //
create procedure pro_sales_store(In param_store int)
begin 
	declare total_sales_value float default 0.0;
  	select (sum(p.amount)) into total_sales_value
	from payment
	join inventory i on i.store_id = s.store_id
	join rental r on r.inventory_id = i.inventory_id
	join payment p on  p.rental_id = r.rental_id
	where s.store_id = param_store
	group by s.store_id;

select total_sales_value;
end;
// delimiter ;

call pro_sales_store(2);

-- 5. In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
-- Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value

drop procedure if exists pro_sales_store;

delimiter //
create procedure pro_sales_store(In param_store int)
begin
  	select s.store_id, round(sum(p.amount),0) as 'sales_amount',
  	case
    when sum(p.amount) > 30000 then "green flag"
  	when sum(p.amount) < 30000 then "red_flag"
  	end as sales_flag
	from store s
	join inventory i on i.store_id = s.store_id
	join rental r on r.inventory_id = i.inventory_id
	join payment p on  p.rental_id = r.rental_id
	where s.store_id = param_store
	group by s.store_id;
end;
// delimiter ;

call pro_sales_store(2);

