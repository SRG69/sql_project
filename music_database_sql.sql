# EASY LVL

#1.who is the seneior most employee based on job title

SELECT 
	* 
FROM 
	employee
ORDER BY levels DESC
LIMIT 1;
--------------------------------------------------------------------------------------------------------------------------
# 2.Which country has most invoces
SELECT 
	billing_country,
	COUNT(customer_id) most_invoices
FROM
	invoice
GROUP BY 1
ORDER BY 2 DESC;
--------------------------------------------------------------------------------------------------------------------------

 /* 3.Which city has the best customers? We would like to throw a promotional Music Festival in the 
 city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

SELECT 
	-- billing_country,
	 billing_city,
    ROUND(SUM(total),2)total_invoces
FROM 
	invoice
GROUP BY 1
ORDER BY 2 DESC;
--------------------------------------------------------------------------------------------------------------------------

#Q5: Who is the best customer? Write a query that returns the person who has spent the most money.

SELECT
	c.customer_id,
	CONCAT(c.first_name, " ", c.last_name) customer_name,
    ROUND(SUM(i.total),2)total_spent
FROM 
	customer c
JOIN 
	invoice i
	ON c.customer_id = i.customer_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;
--------------------------------------------------------------------------------------------------------------------------
# MODERATE LVL

/* Q1: Write query to return the email, first name, last name, & Genre of all 
	Rock Music listeners So that we can send updates from there fav singer. 
	Return your list ordered alphabetically by email starting with A. */

SELECT DISTINCT
	c.first_name , 
    c.last_name,
    c.email,
    g.name
FROM 
	customer c
JOIN 
	invoice i
    ON c.customer_id = i.customer_id
JOIN 
	invoice_line il
    ON i.invoice_id = il.invoice_id
JOIN 
	track t
    ON
	t.track_id = il.track_id
JOIN 
	genre g
    ON g.genre_id = t.genre_id
WHERE g.name = "rock"
ORDER BY 3 ;
--------------------------------------------------------------------------------------------------------------------------
/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

SELECT
	a.artist_id,
	a.name,
    COUNT(a.artist_id) no_of_rock_music
FROM 
	artist a
JOIN 
	album2 al
		ON a.artist_id = al.artist_id
JOIN 
	track t
		ON t.album_id = al.album_id
JOIN 
	genre g
    ON g.genre_id = t.genre_id
WHERE g.name = "rock"
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;
--------------------------------------------------------------------------------------------------------------------------
/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Min for each track. Order by the song length with the longest songs listed first. */

SELECT 
    t.name, g.name, min
FROM
    track t
        JOIN
    genre g ON g.genre_id = t.genre_id
WHERE
    min > (SELECT 
            ROUND(AVG(min), 2) AVG_min
        FROM
            track)
AND 
	g.name NOT IN('Science Fiction','TV Shows',
						  'Sci Fi   Fantasy' , 'Drama',
                          'Comedy'
                          )
ORDER BY 3 DESC;
--------------------------------------------------------------------------------------------------------------------------
#ADVANCE

/* Q1: Find how much amount spent by each customer on 
artists? Write a query to return customer name, artist name and total spent */

WITH best_selling_artist AS (
SELECT 
	art.artist_id,
	art.name,
	ROUND(SUM(il.unit_price * il.quantity),2) total_sale
FROM 
	invoice_line il
JOIN 
	track t
		ON t.track_id = il.track_id
JOIN 
	album2 a2
		ON a2.album_id = t.album_id
JOIN 
	artist art
		ON art.artist_id = a2.artist_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1
)
SELECT 
	c.customer_id, 
	c.first_name, 
	c.last_name, 
    bsa.name artist_name, 
    ROUND(SUM(il.unit_price*il.quantity),2)AS amount_spent
FROM 
	invoice i
JOIN 
	customer c 
		ON c.customer_id = i.customer_id
JOIN 
	invoice_line il 
		ON il.invoice_id = i.invoice_id
JOIN 
	track t 
		ON t.track_id = il.track_id
JOIN 
	album2 alb 
		ON alb.album_id = t.album_id
JOIN 
	best_selling_artist bsa 
		ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;
--------------------------------------------------------------------------------------------------------------------------
/* Q2: We want to find out the most popular music Genre for each country.
 We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns 
each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

/*With help of CTE and windows function I'll Find 
what are the top genre that are popular in the country*/

WITH popular_genre AS 
(
    SELECT 
		COUNT(il.quantity) AS  purchases, 
        c.country, 
        g.name, 
        g.genre_id, 
		ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(il.quantity)   DESC) AS RowNo 
    FROM 
		invoice_line il
	JOIN 
		invoice i 
			ON i.invoice_id = il.invoice_id
	JOIN 
		customer c 
			ON c.customer_id = i.customer_id
	JOIN 
		track t 
			ON t.track_id = il.track_id
	JOIN 
		genre g 
			ON g.genre_id = t.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
# next ill filter out all the genre that are not in top_genre

SELECT * 
FROM 
	popular_genre 
WHERE 
	RowNo <= 1;
--------------------------------------------------------------------------------------------------------------------------
/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
	Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

/* WITH will help me find the top customer with most 
spendings according to the country with help of windows function */

WITH top_customer AS(
SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    i.billing_country country,
    ROUND(SUM(i.total),2) total_spndings,
	ROW_NUMBER() OVER(partition by i.billing_country ORDER BY SUM(total) DESC) r 
FROM 
	customer c 
JOIN 
	invoice i
		ON c.customer_id = i.customer_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC
)
# then filtering out the the customers who are not in top_customer list 

SELECT 
	customer_id,
	CONCAT(first_name,' ',last_name) full_name,
    country,
	total_spndings
FROM 
	top_customer 
WHERE  
	r <=1;
--------------------------------------------------------------------------------------------------------------------------





