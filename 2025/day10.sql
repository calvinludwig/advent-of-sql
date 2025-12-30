-- my solution
with moved_deliveries as (
    delete
        from deliveries
            where delivery_location
                in ('Volcano Rim',
                    'Drifting Igloo',
                    'Abandoned Lighthouse',
                    'The Vibes')
            returning * )
insert
into misdelivered_presents
select *, now(), 'Invalid delivery location'
from moved_deliveries
returning *;

-- aaron's solution
with bad_locations as (
    delete
        from deliveries
            where delivery_location
                in ('Volcano Rim',
                    'Drifting Igloo',
                    'Abandoned Lighthouse',
                    'The Vibes')
            returning id, child_name, delivery_location, gift_name, scheduled_at )
insert
into misdelivered_presents (id, child_name, delivery_location, gift_name, scheduled_at, flagged_at, reason)
select id, child_name, delivery_location, gift_name, scheduled_at, now(), 'Invalid delivery location'
from bad_locations
returning *;

-- almost the same, but I didn't specify all the columns, just returning *
