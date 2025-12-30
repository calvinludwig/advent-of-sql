-- my solution
with calendar(day) as ( select generate_series(
                                 '2025-12-15'::date,
                                 '2025-12-31'::date,
                                 interval '1 day'
                               )::date )
select day as unassigned_date, family_name
from families
         inner join calendar on true
         left join deliveries_assigned
                   on deliveries_assigned.gift_date = calendar.day and
                      deliveries_assigned.family_id = families.id
where deliveries_assigned.id is null
order by 1, 2;

-- aaron's solution
with dates as
         ( select generate_series(
                    '2025-12-15'::date,
                    '2025-12-31'::date,
                    interval '1 day'
                  )::date as date ),

     full_matrix as
         ( select date, families.id as family_id, family_name
           from dates
                    cross join families )
select date as unassigned_date, family_name
from full_matrix
         left join deliveries_assigned on full_matrix.date = deliveries_assigned.gift_date and
                                          full_matrix.family_id = deliveries_assigned.family_id
where deliveries_assigned.id is null
order by 1, 2;