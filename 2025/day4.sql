-- my solution
create extension if not exists pg_trgm;

select last_minute_signups.volunteer_name,
       ( select val
         from unnest(array [ 'Stage Setup', 'Cocoa Station', 'Parking Support', 'Choir Assistant', 'Snow Shoveling', 'Handwarmer Handout']) as val
         order by assigned_task <-> val
         limit 1 )                                        as role,
       case when time_slot = 'noon' then '12:00 PM'
            when time_slot like '2%' then '2:00 PM'
            when time_slot like '10%' then '10:00 AM' end as shift_time
from last_minute_signups
union
select volunteer_name,
       ( select val
         from unnest(array [ 'Stage Setup', 'Cocoa Station', 'Parking Support', 'Choir Assistant', 'Snow Shoveling', 'Handwarmer Handout']) as val
         order by role <-> val
         limit 1 ) as role,
       shift_time
from official_shifts
order by 1 asc;

-- a better solution that I came up after day 5 learnings
with roles(r) as
         ( values ('Stage Setup'),
                  ('Cocoa Station'),
                  ('Parking Support'),
                  ('Choir Assistant'),
                  ('Snow Shoveling'),
                  ('Handwarmer Handout') )
select last_minute_signups.volunteer_name,
       ( select r from roles order by assigned_task <-> r limit 1 ) as role,
       case when time_slot = 'noon' then '12:00 PM'
            when time_slot like '2%' then '2:00 PM'
            when time_slot like '10%' then '10:00 AM' end           as shift_time
from last_minute_signups
union
select volunteer_name,
       ( select r from roles order by role <-> r limit 1 ) as role,
       shift_time
from official_shifts
order by 1 asc;
