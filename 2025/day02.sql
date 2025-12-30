-- my solution
explain (analyze, buffers )
select category_name as category, sum(quantity) as total_snowballs
from snowball_inventory
         inner join snowball_categories on category_name = official_category
where quantity > 0
group by 1
order by 2 asc;
-- Total Cost: 22,219

-- aaron's solution
explain (analyze, buffers )
select official_category as category, sum(quantity) as total_snowballs
from snowball_categories
         left join snowball_inventory
                   on snowball_categories.official_category = snowball_inventory.category_name and quantity > 0
group by 1
order by 2 asc;
-- Total Cost: 37,648
