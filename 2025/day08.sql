-- my solution
with latest_changes as ( select distinct product_id,
                                         first_value(price) over (
                                             partition by product_id
                                             order by effective_timestamp desc
                                             rows between unbounded preceding and unbounded following
                                             ) as current_price,
                                         nth_value(price, 2) over (
                                             partition by product_id
                                             order by effective_timestamp desc
                                             rows between unbounded preceding and unbounded following
                                             ) as previous_price
                         from price_changes
                         order by product_id )
select products.product_id,
       products.product_name,
       current_price,
       previous_price,
       current_price - previous_price as price_change
from products
         inner join latest_changes using (product_id);

-- aaron's solution
with price_history as
         ( select product_id,
                  price               as current_price,
                  lead(price) over w  as previous_price,
                  row_number() over w as row_number
           from price_changes
           window w as (partition by product_id order by effective_timestamp desc) )
select product_name,
       current_price,
       previous_price,
       current_price - previous_price as price_change
from price_history
         inner join products using (product_id)
where row_number = 1;

