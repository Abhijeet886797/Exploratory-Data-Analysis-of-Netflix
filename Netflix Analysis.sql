
CREATE TABLE titles_NNNN (
    id TEXT PRIMARY KEY,
    title TEXT,
    type TEXT,
    description TEXT,
    release_year INT,
    age_certification TEXT,
    runtime INT,
    genres TEXT,
    production_countries TEXT,
    seasons INT,
    imdb_id TEXT,
    imdb_score NUMERIC,          
    imdb_votes NUMERIC,          
    tmdb_popularity NUMERIC(8,2), 
    tmdb_score NUMERIC           
);

COPY titles_nnnn FROM 'C:\Program Files\PostgreSQL\17\Abhijeet.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    NULL ''
);

SELECT*FROM titles_nnnn






CREATE TABLE cast_crewA (
    person_id INT,
    id VARCHAR, 
    name TEXT,
    character TEXT,
    role VARCHAR
);

COPY cast_crewA FROM 'C:\Program Files\PostgreSQL\17\AbhijeetA.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    NULL ''
);

Select*from cast_crewA

-----------------------------------
--- Which movies and shows on Netflix ranked in the top 10 their IMDB scores >= 8 
-- Abhijeet

--- Top 10 Movies
SELECT title, type, imdb_score
FROM titles_NNNN
WHERE type ILIKE 'movie'
  AND imdb_score >= 8.0
ORDER BY imdb_score DESC
LIMIT 10;

---- Top 10 Shows

SELECT title, type, imdb_score
FROM titles_NNNN
WHERE type ILIKE 'show'
  AND imdb_score >= 8.0
ORDER BY imdb_score DESC
LIMIT 10;


----------------------- 
------ Which movies and shows on Netflix ranked in the top 20 based on their IMDB scores >= 7 


--- Top 20 Movies
SELECT title, type, imdb_score
FROM titles_NNNN
WHERE type ILIKE 'movie'
  AND imdb_score >= 7.0
ORDER BY imdb_score DESC
LIMIT 20;

---- Top 20 Shows

SELECT title, type, imdb_score
FROM titles_NNNN
WHERE type ILIKE 'show'
  AND imdb_score >= 7.0
ORDER BY imdb_score DESC
LIMIT 20;



---- bottom 10 Movie & Show With imdb score >= 6 
----- movie 
SELECT title, type, imdb_score
FROM titles_NNNN
WHERE type ILIKE 'movie'
  AND imdb_score >= 6.0
ORDER BY imdb_score ASC
LIMIT 10;

---- show 
SELECT title,type,imdb_score
FROM titles_NNNN 
WHERE type ILIKE 'show'
  AND imdb_score >= 6.0
    ORDER BY imdb_score ASC
	LIMIT 10;


-- What were the average IMDB and TMDB scores for shows and movies? 


SELECT 
  type, 
  ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
  ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM titles_NNNN
WHERE imdb_score IS NOT NULL AND tmdb_score IS NOT NULL
GROUP BY type;


---- Count of movies and shows in each decade

SELECT 
  CONCAT(FLOOR(release_year / 10) * 10, 's') AS decade,
  COUNT(*) AS movies_shows_count
FROM titles_NNNN
WHERE release_year >= 1940
GROUP BY CONCAT(FLOOR(release_year / 10) * 10, 's')
ORDER BY decade;


-- What were the average IMDB and TMDB scores for each production country?
  SELECT 
  production_countries,
  ROUND(AVG(imdb_score),2) AS avg_imdb_score,
  ROUND(AVG(tmdb_score),2) AS avg_tmdb_score
FROM titles_NNNN
GROUP BY production_countries
ORDER BY avg_imdb_score DESC;


-- What were the 10 most common age certifications for movies?

SELECT age_certification, 
       COUNT(*) AS certification_count
FROM titles_NNNN
WHERE type ILIKE 'movie'
  AND age_certification IS NOT NULL
  AND age_certification != ''
  AND age_certification != 'N/A'
GROUP BY age_certification
ORDER BY certification_count DESC
LIMIT 10;

-- Who were the top 30 actors that appeared the most in movies/shows? 
SELECT DISTINCT name AS actor,              
       COUNT(*) AS number_of_appearances    
FROM cast_crewA
WHERE role ILIKE 'actor'                    
GROUP BY name                                
ORDER BY number_of_appearances DESC         
LIMIT 30;       


-- Who were the top 30 directors that directed the most movies/shows?

SELECT DISTINCT name AS director,
      COUNT(*) AS number_of_appearances
	  FROM cast_crewA
	  WHERE role ILIKE 'director'
	  GROUP BY name
	  ORDER BY  number_of_appearances DESC
	  LIMIT 30;

-- Calculating the average runtime of movies and TV shows separately??

--- Movie

SELECT 
'Movies' AS content_type,
ROUND(AVG(runtime),2) AS avg_runtime_min
FROM titles_NNNN
WHERE type ILIKE 'Movie';

---- TV Show 
SELECT
'show'AS content_type,
ROUND(AVG(runtime),2) AS avg_runtime_min
FROM titles_NNNN
WHERE type ILIKE 'show';
-------------------------------------------------------------------------------------
---- UNION ALL
SELECT 
'Movies' AS content_type,
ROUND(AVG(runtime),2) AS avg_runtime_min
FROM titles_NNNN
WHERE type ILIKE 'Movie'
UNION ALL
SELECT
'show'AS content_type,
ROUND(AVG(runtime),2) AS avg_runtime_min
FROM titles_NNNN
WHERE type ILIKE  'show';
-----------------------------------------------------------------------------------------------------


-- Finding the titles and  directors of movies released on or after 2022

SELECT DISTINCT 
    t.title, 
    c.name AS director, 
    t.release_year
FROM titles_NNNN AS t
JOIN cast_crewA AS c 
    ON t.id = c.id
WHERE t.type ILIKE 'movie' 
  AND t.release_year >= 2022 
  AND c.role ILIKE 'director'
ORDER BY t.release_year DESC;

----------------------------------------------------------------
-- Which shows on Netflix have the most seasons?

SELECT t.title,
SUM(t.seasons) AS total_seasons
FROM titles_NNNN AS t
WHERE t.type ILIKE 'show' 
GROUP BY title
ORDER BY total_seasons DESC
LIMIT 5;

-----------------------------------------------------------------------

-- Which genres had the most movies? 
SELECT genres,
SUM(t.seasons) AS total_seasons
FROM titles_NNNN AS t
WHERE t.type ILIKE 'show' 
GROUP BY genres
ORDER BY total_seasons DESC
LIMIT 5;
--------------------------------------------------------

-- What were the total number of titles for each year?
SELECT release_year, 
COUNT(*) AS title_count
FROM titles_NNNN 
GROUP BY release_year
ORDER BY release_year DESC;
----------------------------------------------------------------------

-- What were the top 15 most common genres?

SELECT genres,
SUM(t.seasons) AS total_seasons
FROM titles_NNNN AS t
WHERE t.type ILIKE 'show' 
GROUP BY genres
ORDER BY total_seasons DESC
LIMIT 15;
----------------------------------------------------------

------ Which movies have an IMDB score greater than 8.0 
----and a TMDB popularity score greater than 60? 
-----Display their titles along with their IMDB score 
-----and TMDB popularity in descending order of popularity.
------------ (Below q desc )
------------ "Which highly rated movies (IMDB > 8.0) also have high TMDB popularity (above 60)?"

SELECT title, imdb_score, tmdb_popularity
FROM titles_NNNN
WHERE imdb_score > 8.0 
AND tmdb_popularity > 60
AND type ILIKE 'movie'
ORDER BY tmdb_popularity DESC;



-- Titles and Directors of movies with high IMDB scores (>7.5) and 
 ------ Titles  high TMDB popularity scores (>80) 

SELECT t.title, 
c.name AS director
FROM titles_NNNN AS t
JOIN cast_crewA AS c 
ON t.id = c.id
WHERE t.type ILIKE 'movie'
AND t.imdb_score > 7.5 
AND t.tmdb_popularity > 80 
AND c.role ILIKE  'director';




--------  Top repeated character-actor pairs based on total appearances:

SELECT name, character, COUNT(*) AS appearances
FROM cast_crewA
WHERE character IS NOT NULL
GROUP BY name, character
HAVING COUNT(*) > 1
ORDER BY appearances DESC;








----- Fetching Movie Titles and IMDB Scores


SELECT title, imdb_score
FROM titles_NNNN
WHERE imdb_score > 8.0
ORDER BY imdb_score DESC;

------ Fetching Movie Titles and Directors


SELECT t.title, c.name AS director
FROM titles_NNNN AS t
JOIN cast_crewA AS c
ON t.id = c.id
WHERE t.type ILIKE 'movie' AND c.role ILIKE 'director';



-- Which movies have an IMDB score greater than 8.0, and who are the directors of these movies?


SELECT t.title, c.name AS director, t.imdb_score
FROM titles_NNNN AS t
JOIN cast_crewA AS c
ON t.id = c.id
WHERE t.type ILIKE 'movie' AND c.role ILIKE 'director' AND t.imdb_score > 8.0
ORDER BY t.imdb_score DESC;
