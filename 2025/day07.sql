-- my solution
with cars as ( select * from cocoa_cars order by total_stock desc limit 3 )
select passenger_name, array_agg(cars.car_id) as car_options
from passengers
         inner join cars on available_mixins && favorite_mixins
group by 1
order by 1;

-- aaron's solution
select passenger_name, array_agg(cocoa_cars.car_id) as valid_cars
from passengers
         inner join cocoa_cars on available_mixins && favorite_mixins
where cocoa_cars.car_id in ( select car_id from cocoa_cars order by total_stock desc limit 3 )
group by passenger_name;

-- I prefer my solution 😼