-- Total yearly revenue per location
SELECT gl.location, ROUND(12*sp.price_per_month*COUNT(ud.user_id)) AS yearly_revenue
FROM users_data ud 
	JOIN subscription_plans sp USING (subscription_plan)
	JOIN checkin_checkout_history_updated cchu ON ud.user_id = cchu.user_id 
	JOIN gym_locations gl ON cchu.gym_id = gl.gym_id 
GROUP BY location
ORDER BY yearly_revenue DESC;

-- Distribution of gym members by age group and gender
SELECT gender, CASE
		WHEN age <= 25 THEN '18-25'
		WHEN age <= 35 THEN '26-35'
		WHEN age <= 45 THEN '36-45'
		ELSE '45+'
	END AS age_group, 
	COUNT(user_id) AS member_count
FROM users_data ud 
GROUP BY gender, age_group
ORDER BY age_group;

-- Top locations (gyms with members that on average burn more calories than the mean calories burnt between all locations)
SELECT gl.location , ROUND(AVG(cchu.calories_burned)) AS avg_calories
FROM checkin_checkout_history_updated cchu JOIN gym_locations gl USING (gym_id)
GROUP BY gl.location 
HAVING avg_calories > (SELECT ROUND(AVG(calories_burned)) FROM checkin_checkout_history_updated cchu)
ORDER BY avg_calories DESC; 

-- Average workout duration in minutes per workout type
SELECT workout_type, ROUND((JULIANDAY(checkout_time)-JULIANDAY(checkin_time)) * 1440) AS avg_duration_min
FROM checkin_checkout_history_updated cchu 
GROUP BY workout_type;

-- Engagement per subscription plan
SELECT ud.subscription_plan, COUNT(cchu.checkin_time) AS checkins 
FROM checkin_checkout_history_updated cchu JOIN users_data ud USING (user_id)
GROUP BY ud.subscription_plan;