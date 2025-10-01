USE Papa_Johns;

-- 1) Average Price of Foods at Each Restaurant
SELECT
    restaurants.name,   -- calling the restaurants
    AVG(foods.price)  
FROM restaurants
INNER JOIN serves                         -- using inner join for the ID's for average prices
    ON restaurants.restID = serves.restID
INNER JOIN foods
    ON serves.foodID = foods.foodID
GROUP BY restaurants.restID, restaurants.name;   -- Grouping the resturants of avg food price 


-- 2) Maximum Food Price at Each Restaurant
SELECT
    restaurants.name,      -- calling restaurants 
    MAX(foods.price)
FROM restaurants
INNER JOIN serves
    ON restaurants.restID = serves.restID   -- using inner join to find highest food price 
INNER JOIN foods
    ON serves.foodID = foods.foodID
GROUP BY restaurants.restID, restaurants.name;   -- grouping restuarants by their highest priced item 


-- 3) Count of Different Food Types Served at Each Restaurant
SELECT
    restaurants.name,                 -- show the restaurant name
    COUNT(*) AS type_count            -- count how many different types this restaurant serves
FROM (
    SELECT
        serves.restID,               
        foods.type                   
    FROM serves
    INNER JOIN foods                  -- combine each served item to its food record
        USING (foodID)               
    GROUP BY serves.restID, foods.type -- one row for restaurant and  type
) AS restaurant_type_pairs        
INNER JOIN restaurants       
    ON restaurants.restID = restaurant_type_pairs.restID
GROUP BY restaurants.restID, restaurants.name;  -- group restuarants result 



-- 4) Average Price of Foods Served by Each Chef
SELECT
    chefs.name,                     -- calling upon chefs 
    AVG(foods.price)
FROM chefs
NATURAL JOIN works              -- using natural join to gather everything for chefs and ID's 
INNER JOIN serves                -- using inner join 
    USING (restID)                -- inner join to get the restuarants and the food they served 
INNER JOIN foods                   -- finding price of food to caulculate ag price by each chef 
    USING (foodID)             
GROUP BY chefs.chefID, chefs.name;        -- grouping each chef with their avg 



-- 5) Restaurant with the Highest Average Food Price
SELECT
    restaurants.name,                        -- calling all restuarants 
    AVG(foods.price)      
FROM restaurants         
INNER JOIN serves                                  -- usuing inner join to get every single restaurant and what they serve 
    ON restaurants.restID = serves.restID
INNER JOIN foods                                  -- using inner join to combine the foods to calculate avg 
    ON serves.foodID = foods.foodID             
GROUP BY restaurants.restID, restaurants.name
ORDER BY AVG(foods.price) DESC                     -- only asking for the highest so order by descending and limit to 1 
LIMIT 1;



-- Extra Credit 
SELECT
    appc.name,               -- average price per chef simplified (appc)
    appc.avg_price,          
    restaurant_lists_per_chef.restaurants   -- list of restaurants they work at
FROM
(
    SELECT
        chefs.chefID,                      
        chefs.name,                       
        AVG(foods.price) AS avg_price       -- calculate the average price of foods linked to this chef
    FROM chefs
    NATURAL JOIN works                      -- combine chefs to works using chefID
    INNER JOIN serves
        USING (restID)                      -- connect the restaurants they work at to the foods served
    INNER JOIN foods
        USING (foodID)                      -- show food price
    GROUP BY chefs.chefID, chefs.name       -- group by chef so each one has a single average
) AS appc
INNER JOIN
(
    SELECT
        chefs.chefID,                       
        GROUP_CONCAT(restaurants.name SEPARATOR ', ') AS restaurants -- didnt know what concat was looked it up at "https://www.w3schools.com/sql/func_sqlserver_concat.asp"
                                             -- combine all restaurants for that chef into one string using concat
    FROM chefs
    NATURAL JOIN works                      -- combine chefs to restaurants they work at
    INNER JOIN restaurants
        ON works.restID = restaurants.restID 
    GROUP BY chefs.chefID                   -- one restaurant list per chef
) AS restaurant_lists_per_chef
    ON appc.chefID = restaurant_lists_per_chef.chefID
                                                              -- join the averages
ORDER BY appc.avg_price DESC;
                                                          -- chef with the highest average food price appears first


