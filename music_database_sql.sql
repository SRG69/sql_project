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




