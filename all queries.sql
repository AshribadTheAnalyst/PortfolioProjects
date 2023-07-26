----Created Temp Table for reference

WITH hotels AS (
SELECT * FROM hotel2018
UNION
SELECT * FROM hotel2019
UNION
SELECT * FROM hotel2020)

SELECT (stays_in_week_nights+stays_in_weekend_nights)*adr from hotels;

---Created View combining three tables

create view hotel_revenue as

SELECT * FROM hotel2018
UNION
SELECT * FROM hotel2019
UNION
SELECT * FROM hotel2020;

---Revenue Year on Year

SELECT
arrival_date_year,
hotel,
ROUND(SUM((stays_in_week_nights+stays_in_weekend_nights)*adr),2) AS Revenue
from hotel_revenue
GROUP BY arrival_date_year,hotel;

SELECT * FROM market_segment$;

--Join two tables

SELECT * from hotel_revenue ht
LEFT JOIN market_segment$ ms
ON ht.market_segment = ms.market_segment
LEFT JOIN meal_cost$ mc
ON mc.meal = ht.meal


