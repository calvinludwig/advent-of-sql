-- my solution
with sorted_orders as
         ( select customer_id,
                  created_at,
                  order_data,
                  row_number() over (partition by customer_id order by created_at desc) as rn
           from orders ),

     recent_orders as
             ( select * from sorted_orders where rn = 1 )

select customer_id,
       created_at,
       order_data -> 'shipping' ->> 'method'      as shipping_method,
       (order_data -> 'gift' ->> 'wrapped')::bool as gift_wrap,
       order_data -> 'risk' ->> 'flag'            as risk_flag
from recent_orders
order by created_at desc;

-- aaron's solution
with partitioned_orders as
         ( select customer_id,
                  created_at,
                  order_data,
                  row_number() over (partition by customer_id order by created_at desc) as row_number
           from orders )

select customer_id,
       created_at,
       order_data -> 'shipping' ->> 'method'         as shipping_method,
       (order_data -> 'gift' ->> 'wrapped')::boolean as gift_wrap,
       order_data -> 'risk' ->> 'flag'               as risk_flag
from partitioned_orders
where row_number = 1
order by created_at desc;

-- my solution was pretty close