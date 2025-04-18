USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT count(*) AS Total_Record_director_mapping FROM director_mapping;
-- Total records : 3867

SELECT count(*) AS Total_Record_genre FROM genre;
-- Total records : 14662

SELECT count(*) AS Total_Record_movie FROM movie;
-- Total records : 7997

SELECT count(*) AS Total_Record_names FROM names;
-- Total records : 25753

SELECT count(*) AS Total_Record_ratings FROM ratings;
-- Total records : 7997

SELECT count(*) AS Total_Record_role_mapping FROM role_mapping;
-- Total records : 15615




-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS id_Null_Count,
		SUM(CASE
			WHEN title IS NULL THEN 1
            ELSE 0
            END) AS title_Null_Count,
		SUM(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
             END) AS year_Null_Count,
		SUM(CASE
			WHEN date_published IS NULL THEN 1
            ELSE 0
            END) AS date_published_Null_Count,
		SUM(CASE
			WHEN duration IS NULL THEN 1
            ELSE 0
            END) AS duration_Null_Count,
		SUM(CASE
			WHEN country IS NULL THEN 1
            ELSE 0
            END) AS country_Null_Count,
		SUM(CASE
			WHEN worlwide_gross_income IS NULL THEN 1
            ELSE 0
            END) AS worlwide_gross_income_Null_Count,
		SUM(CASE
			WHEN languages IS NULL THEN 1
            ELSE 0
            END) AS languages_Null_Count,
		SUM(CASE
			WHEN production_company IS NULL THEN 1
            ELSE 0
            END) AS production_company_Null_Count
FROM movie;
/*

in my movie table 4 columns have null vlaues
1) country
2) worlwide_gross_income
3) languages
4) production_company

*/
			



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Total number of movies released each year

SELECT		year,
			COUNT(title)	AS Number_of_movies
FROM		movie
GROUP BY	year;

-- in the year 2017 highest number of movies released - 3052 also, An observable decline is noted in the annual release of movies over time.


-- Total number of movies released each month

SELECT		MONTH(date_published)	AS Month_Number,
			COUNT(*)				AS Total_Number_Of_Movies
FROM 		movie
GROUP BY 	Month_Number
ORDER BY 	Month_Number;

-- In the month of MARCH highest movies were released
-- So, according to the trend, MARCH 2017 highest movies were released.




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 	COUNT(DISTINCT id)	 AS Number_of_Movies,
		year
FROM 	movie
WHERE  ( country LIKE '%INDIA%' OR country LIKE '%USA%' )
       AND year = 2019; 
       
-- 1059 movies were produced in the USA or India in the year 2019






/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM   genre; 

-- Total 13 unique genre are listed for the given dataset.





/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 		genre,
			COUNT( m.id)	AS TOTAL_NUM_MOVIE
FROM 		movie			AS m
INNER JOIN 	genre 			AS g
WHERE 		g.movie_id = m.id
GROUP BY 	genre
ORDER BY 	TOTAL_NUM_MOVIE DESC
LIMIT 1;

-- A total of 4285 movies belonging to the Drama genre were produced, establishing it as the most prolific genre among all categories.









/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movie_of_one_genre AS 
(
    SELECT		movie_id
	FROM 		genre
	GROUP BY 	movie_id
	HAVING 		COUNT(DISTINCT genre) = 1
)
SELECT 	COUNT(*) 	AS movie_of_one_genre
FROM 	movie_of_one_genre;

-- Total 3289 movie belongs to one genre only.




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 		genre,
			ROUND( AVG(duration),2 ) 	AS avg_movie_duration
FROM 		movie	AS m
INNER JOIN 	genre 	AS g
ON 			g.movie_id = m.id
GROUP BY 	genre
ORDER BY 	avg_movie_duration DESC ;

-- As per the result, Action genre has the highest average movie duration of 112.88 seconds followed by Romance genre at second highest place.


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_info AS 
(
	SELECT 		genre,
				COUNT( movie_id ) 	AS total_num_movie,
	RANK() OVER( ORDER BY COUNT( movie_id ) DESC )	AS genre_rank
	FROM 		genre
    GROUP BY 	genre
)
SELECT *
FROM 			genre_info
WHERE 			genre = 'Thriller' ;

-- so, 1484 is the total number of movie with Thriller genre at 3rd rank.



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN( avg_rating ) 	AS min_avg_rating,
	   MAX( avg_rating ) 	AS max_avg_rating,
       MIN( total_votes ) 	AS min_total_votes,
       MAX( total_votes ) 	AS max_total_votes,
       MIN( median_rating ) AS min_median_rating,
       MAX( median_rating ) AS max_median_rating
FROM ratings;




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT 		title,
			avg_rating,
			RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM 		ratings AS r
INNER JOIN 	movie AS m
ON 			m.id = r. movie_id
limit 		10;

-- So, at rank 1, two movies are holding average rating of 10.




/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 		median_rating,
			COUNT( movie_id ) AS total_num_movie
FROM 		ratings
GROUP BY 	median_rating
ORDER BY 	total_num_movie DESC ;

-- So, 2257 is the total number of movies having median rating of 7 at highest.



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH produced_most_num_of_hit_movies	AS
( 
	SELECT 		production_company,
				COUNT(movie_id) 	AS total_num_movie,
				DENSE_RANK() OVER ( ORDER BY COUNT(movie_id) DESC)	 AS production_company_rank
	FROM 		ratings	 	AS r
	INNER JOIN	movie 		AS m
	ON	 		m.id = r.movie_id
	WHERE		avg_rating > 8 AND production_company IS NOT NULL
	GROUP BY 	production_company
)
SELECT 		* 
FROM 		produced_most_num_of_hit_movies
WHERE 		production_company_rank = 1 ;

-- Dream Warrior Pictures and National Theatre Live production houses has produced the most number of hit movies (average rating > 8)
-- They have rank=1 and movie count =3 




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT			genre,
				COUNT( m.id ) 	AS total_num_movie
FROM 			movie 			AS m
INNER JOIN		genre 			AS g
ON 				g.movie_id = m.id
INNER JOIN 		ratings			AS r
ON 				r.movie_id = m.id
WHERE 			year = 2017
AND 			Month(date_published) = 3
AND 			country LIKE '%USA%'
AND 			total_votes > 1000
GROUP BY 		genre
ORDER BY 		total_num_movie DESC;

-- So, in total 24 Drama movies were released during March 2017 in the USA and had more than 1,000 votes
-- Top 3 genres are drama, comedy and action during March 2017 in the USA and had more than 1,000 votes




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT  		title,
				avg_rating,
				genre
FROM   			movie		AS m
INNER JOIN 		genre 		AS g
ON 				g.movie_id = m.id
INNER JOIN 		ratings 	AS r
ON 				r.movie_id = m.id
WHERE  			avg_rating > 8	AND title LIKE 'THE%'
ORDER BY 		avg_rating DESC;


-- So, In all there are 8 movie titles that starts from 'The' in their title
-- And The Brighton Miracle movie has the highest averrage rating of 9.5 of genre drama.




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT			median_rating,
				COUNT(*) 	As total_num_movie
FROM			movie 		AS m
INNER JOIN 		ratings 	AS r
ON		 		r.movie_id = m.id
WHERE 			median_rating = 8 
AND 			date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY 		median_rating; 
		

-- So, Total number of movies released between 1st April 2018 to 1st April 2019 is 361 





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 			country,
				SUM( total_votes ) 	AS total_votes
FROM			movie 				AS m
INNER JOIN 		ratings 			AS r
ON 				r.movie_id = m.id
WHERE 			country = 'Germany' OR country = 'Italy'
GROUP BY 		country;

-- From the result, We can clearly see that Germany has the highest number votes than Italy.


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT SUM(CASE 
			WHEN name IS NULL THEN 1
            ELSE 0
            END
		   )	AS name_nulls,
		SUM(CASE 
			WHEN height IS NULL THEN 1
            ELSE 0
            END
		   )	AS height_nulls,
		SUM(CASE 
			WHEN date_of_birth IS NULL THEN 1
            ELSE 0
            END
		   )	AS date_of_birth_nulls,
		SUM(CASE 
			WHEN known_for_movies IS NULL THEN 1
            ELSE 0
            END
		   )	AS known_for_movies_nulls
FROM names;


-- So, height,date_of_birth and known_for_movies are the 4 columns from the names table having null values.


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH genre_top3 AS
(
	SELECT			genre,
					COUNT( m.id )		AS total_movie_count,
					RANK() OVER ( ORDER BY ( m.id ) DESC )		AS genre_rank
	FROM			movie 				AS m
	INNER JOIN 		genre 				AS g
    ON 				g.movie_id = m.id
    INNER JOIN 		ratings 			AS r
    ON 				r.movie_id = m.id
	WHERE			avg_rating > 8
    GROUP BY 		genre
    limit 3
)
SELECT				n.name				AS director_name,
					COUNT( d.movie_id )	AS movie_count
FROM				director_mapping 	AS d
INNER JOIN 			genre 				AS g
USING 				( movie_id )
INNER JOIN 			names 				AS n
ON 					n.id = d.name_id
INNER JOIN 			ratings
USING 				( movie_id )
WHERE 				avg_rating > 8
GROUP BY 			name
ORDER BY 			movie_count DESC 
limit 				3 ;
        
-- SO, Joe Russo, Anthony Russo and James Mangold are the top 3 director in the top 3 genre having movie rating > 8.




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT				n.name				AS actor_name,
					COUNT( movie_id )	AS total_movie_count
FROM				role_mapping		AS rm
INNER JOIN			 movie 				AS m
ON 					m.id = rm.movie_id
INNER JOIN 			ratings 			AS r
using 				( movie_id )
INNER JOIN 			names 				AS n
ON 					n.id = rm.name_id
WHERE				r.median_rating >= 8
AND					category = 'ACTOR'
GROUP BY 			actor_name
ORDER BY 			total_movie_count DESC
limit 				2;

-- So, Mammootty and Mohanlal are the top 2 actors.




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT				production_company,
					SUM( total_votes )	AS vote_count,
					RANK() OVER( ORDER BY SUM( total_votes ) DESC )	 AS prod_comp_rank
FROM				movie		AS m
INNER JOIN 			ratings		AS r
on 					r.movie_id = m.id
GROUP BY 			production_company 
limit				3;


-- So, Marvel Studios, Twentieth Century Fox and Warner Bros. are the top 3 production house based on votes.




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_info AS
(
SELECT		name	AS actor_name,
			COUNT( title )	AS movie_count,
            ROUND( SUM( avg_rating * total_votes ) / SUM( total_votes ) , 2 )	AS actor_avg_rating,
            DENSE_RANK() OVER( ORDER BY ROUND( SUM( avg_rating * total_votes ) / SUM( total_votes ) , 2 ) DESC, SUM( total_votes ) DESC)	AS actor_rank
FROM		movie	AS m
INNER JOIN 	ratings	AS r
ON 			r.movie_id = m.id
INNER JOIN 	role_mapping	AS rm
ON 			m.id = rm.movie_id
INNER JOIN 	names	AS n
ON			 rm.name_id = n.id
WHERE		category = 'ACTOR'
AND			country = 'India'
GROUP BY	actor_name
HAVING		movie_count >= 5
)
SELECT 		*
FROM		actor_info
ORDER BY 	actor_rank
limit 		3;


-- Top actor is Vijay Sethupathi followed by Fahadh Faasil and Yogi Babu.





-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_info AS
(
SELECT			name AS actress_name,
				COUNT( title )		AS movie_count,
				Round( Sum( avg_rating*total_votes ) / Sum( total_votes ), 2 ) AS actress_avg_rating,
				DENSE_RANK() OVER( ORDER BY ROUND( SUM( avg_rating * total_votes ) / SUM( total_votes ) , 2 ) DESC, SUM( total_votes ) DESC)	AS actorress_rank
FROM			movie		AS m
INNER JOIN 		ratings	 AS r                                              
ON        		m.id=r.movie_id
INNER JOIN 		role_mapping	AS rm
ON        		m.id = rm.movie_id
INNER JOIN 		names	AS n
ON         		rm.name_id = n.id
WHERE      		category = 'ACTRESS'
AND        		country = "INDIA"
AND        		languages LIKE '%HINDI%'
GROUP BY   		NAME
HAVING     		movie_count>=3
)
SELECT   		*
FROM     		actress_info
LIMIT 			5;

-- Top five actresses in Hindi movies released in India based on their average ratings are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda





/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_movies	AS
(
SELECT 		DISTINCT title,
			avg_rating
FROM   		movie 		AS M
INNER JOIN 	ratings 	AS R
ON 			R.movie_id = M.id
INNER JOIN	genre 	AS G 
using		(movie_id)
WHERE  		genre LIKE 'THRILLER'
)
SELECT 		*,
			CASE
				WHEN avg_rating > 8 THEN 'Superhit movies'
				WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
				WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
				ELSE 'Flop movies'
			END AS avg_rating_category
FROM   		thriller_movies; 





/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT		genre,
			ROUND(AVG(duration),2)		AS avg_duration,
			SUM(ROUND(AVG(duration),2)) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING)		AS running_total_duration,
			AVG(ROUND(AVG(duration),2)) OVER (ORDER BY genre ROWS 10 PRECEDING)				AS moving_avg_duration
FROM		movie	 AS m
INNER JOIN	genre	 AS g
ON 			m.id = g.movie_id
GROUP BY 	genre
ORDER BY 	genre;





-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_gen AS
(
SELECT     	genre,
			Count(title)                                  AS movie_count,
			Dense_rank() OVER(ORDER BY Count(title) DESC) AS rk
FROM       	movie m
INNER JOIN 	genre g
ON         	m.id =g.movie_id
GROUP BY   	genre 
limit 		3
),
top_5 AS
(
SELECT     	genre,
			year,
			title	 AS movie_name ,
			worlwide_gross_income,
			Dense_rank() OVER( partition BY year ORDER BY worlwide_gross_income DESC) 	AS movie_rank
FROM       	movie AS m
INNER JOIN 	genre AS g
ON         	m.id =g.movie_id
WHERE      	genre IN
			(
				SELECT genre
				FROM   top_gen
			)
)
SELECT 		*
FROM   		top_5
WHERE  		movie_rank<=5
ORDER BY 	YEAR;






-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_summary	AS
(
SELECT 			production_company,
                Count(*) 	AS movie_count
FROM   			movie 		AS m
inner join 		ratings 	AS r
ON 				r.movie_id = m.id
WHERE  			median_rating >= 8
AND 			production_company IS NOT NULL
AND 			Position(',' IN languages) > 0
GROUP  BY 		production_company
ORDER  BY 		movie_count DESC
)
SELECT 			*,
				Rank() OVER( ORDER BY movie_count DESC )	 AS prod_comp_rank
FROM   			production_company_summary
LIMIT 			2; 


-- SO, Star Cinema and Twentieth Century Fox are the top 2 production house which has produced the highest number of hits among multilingual movies.




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary AS
(
SELECT     			n.NAME 													AS actress_name,
                    SUM(total_votes) 										AS total_votes,
                    Count(r.movie_id)                                    	AS movie_count,
                    Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) 	AS actress_avg_rating
FROM       			movie               AS m
INNER JOIN 			ratings             AS r
ON        			m.id=r.movie_id
INNER JOIN 			role_mapping 		AS rm
ON         			m.id = rm.movie_id
INNER JOIN 			names 				AS n
ON         			rm.name_id = n.id
INNER JOIN			GENRE 				AS g
ON 					g.movie_id = m.id
WHERE      			category = 'ACTRESS'
AND        			avg_rating>8
AND 				genre = "Drama"
GROUP BY   			NAME 
)
SELECT   			*,
					Rank() OVER(ORDER BY movie_count DESC) 	AS actress_rank
FROM     			actress_summary 
LIMIT 				3;


-- SO, Top 3 actresses based on number of Super Hit movies are Parvathy Thiruvothu, Susan Brown and Amanda Lawrence



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_summary AS
(
SELECT    			d.name_id,
                    NAME,
                    d.movie_id,
                    duration,
                    r.avg_rating,
                    total_votes,
					m.date_published,
                    Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
FROM       			director_mapping		AS d
INNER JOIN 			names                   AS n                                                         
ON         			n.id = d.name_id
INNER JOIN 			movie 					AS m
ON         			m.id = d.movie_id
INNER JOIN 			ratings 				AS r
ON         			r.movie_id = m.id 
), 
top_director_summary AS
(
SELECT 		*,
			Datediff(next_date_published, date_published) AS date_difference
FROM   		next_date_published_summary )
SELECT   	name_id                       AS director_id,
			NAME                          AS director_name,
			Count(movie_id)               AS number_of_movies,
			Round(Avg(date_difference),2) AS avg_inter_movie_days,
			Round(Avg(avg_rating),2)               AS avg_rating,
			Sum(total_votes)              AS total_votes,
			Min(avg_rating)               AS min_rating,
			Max(avg_rating)               AS max_rating,
			Sum(duration)                 AS total_duration
FROM     	top_director_summary
GROUP BY 	director_id
ORDER BY 	Count(movie_id) DESC 
limit 		9;





