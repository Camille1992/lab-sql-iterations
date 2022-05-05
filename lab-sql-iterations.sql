# Lab | SQL Iterations
# In this lab, we will continue working on the Sakila database of movie rentals.

# Instructions
# Write queries to answer the following questions:
# Write a query to find what is the total business done by each store.
SELECT 
	s.store_id, st.staff_id, sum(p.amount) AS total_business
FROM
	store s
JOIN
	staff st ON st.store_id = s.store_id
JOIN
	payment p ON p.staff_id = st.staff_id
GROUP BY
	st.staff_id, s.store_id;

# Convert the previous query into a stored procedure.
DELIMITER //
CREATE PROCEDURE total_business ()
BEGIN
   SELECT 
	s.store_id, st.staff_id, sum(p.amount) AS total_business
FROM
	store s
JOIN
	staff st ON st.store_id = s.store_id
JOIN
	payment p ON p.staff_id = st.staff_id
GROUP BY
	st.staff_id, s.store_id;
END;
//
delimiter ;

CALL total_business;

# Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
DELIMITER //
CREATE PROCEDURE total_business2 (in id int)
BEGIN
   SELECT 
	s.store_id, sum(p.amount) AS total_business
FROM
	store s
JOIN
	staff st ON st.store_id = s.store_id
JOIN
	payment p ON p.staff_id = st.staff_id
GROUP BY
	st.staff_id, s.store_id
HAVING
	s.store_id = id;
END;
//
delimiter ;

CALL total_business2(1);

# Update the previous query. Declare a variable total_sales_value of float type, 
# that will store the returned result (of the total sales amount for the store). 
# # Call the stored procedure and print the results.
DELIMITER //
CREATE PROCEDURE total_business3 (in id int)
BEGIN
DECLARE total_sales_value float default 0.0;
   SELECT 
	sum(p.amount) into total_sales_value
FROM
	store s
JOIN
	staff st ON st.store_id = s.store_id
JOIN
	payment p ON p.staff_id = st.staff_id
GROUP BY
	st.staff_id, s.store_id
HAVING
	s.store_id = id;
SELECT total_sales_value;
END;
//
delimiter ;

CALL total_business3(1);

# In the previous query, add another variable flag. 
#If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
DELIMITER //
CREATE PROCEDURE total_business4 (in id int, out flag varchar(20))
BEGIN
DECLARE total_sales_value float default 0.0;
DECLARE colour VARCHAR(20) DEFAULT "";
   SELECT 
	round(sum(p.amount),2) into total_sales_value
FROM
	store s
JOIN
	staff st ON st.store_id = s.store_id
JOIN
	payment p ON p.staff_id = st.staff_id
GROUP BY
	st.staff_id, s.store_id
HAVING
	s.store_id = id;
SELECT total_sales_value;
IF total_sales_value > 30000 THEN
	SET colour = 'Green Flag';
ELSE
	SET colour = 'Red Flag';
END IF;
SELECT colour INTO flag;
END;
//
delimiter ;

CALL total_business4(2, @flag);
SELECT @flag;

DROP PROCEDURE total_business4;


# Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.
DELIMITER //
CREATE PROCEDURE total_business5 (in id int, out sales float4, out flag varchar(20))
BEGIN
DECLARE colour VARCHAR(20) DEFAULT "";
   SELECT 
	round(sum(p.amount),2) into sales
FROM
	store s
JOIN
	staff st ON st.store_id = s.store_id
JOIN
	payment p ON p.staff_id = st.staff_id
GROUP BY
	st.staff_id, s.store_id
HAVING
	s.store_id = id;
IF sales > 30000 THEN
	SET colour = 'Green Flag';
ELSE
	SET colour = 'Red Flag';
END IF;
SELECT colour INTO flag;
END;
//
delimiter ;

CALL total_business5(1, @sales, @flag);
SELECT @sales, @flag;

DROP PROCEDURE total_business5;