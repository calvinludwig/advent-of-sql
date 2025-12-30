-- my solution
select *
from ( select play_counts.*,
              row_number() over (
                  partition by user_name
                  order by play_count desc
                  ) as rank
       from ( select user_name, artist, count(*) as play_count
              from listening_logs
              group by 1, 2
              order by 1, 3 desc ) as play_counts ) as ranking
where rank <= 3;

-- aaron's solution with subquery
select *
from ( select user_name,
              artist,
              count(*) as play_count,
              row_number() over (
                  partition by user_name
                  order by count(*) desc, artist asc
                  )    as rank
       from listening_logs
       group by 1, 2
       order by 1, 3 desc ) as ranked
where rank <= 3;
-- my solution was pretty close to aaron's,
-- but I didn't know that I could order by count(*) inside row number partition

-- aaron's solution with cte, more readable
with ranked as
         ( select user_name,
                  artist,
                  count(*) as play_count,
                  row_number() over (
                      partition by user_name
                      order by count(*) desc, artist asc
                      )    as rank
           from listening_logs
           group by 1, 2
           order by 1, 3 desc )
select *
from ranked
where rank <= 3;
