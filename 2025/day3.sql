update hotline_messages
set status = 'approved'
where lower(transcript) like '%sorry%'
  and status is null;

delete
from hotline_messages
where tag in ('penguin prank', 'time-loop advisory', 'possible dragon', 'nonsense alert')
   or caller_name = 'Test Caller';

-- my solution
select status, count(*)
from hotline_messages
where status = 'approved'
   or status is null
group by 1
order by 2 desc;

-- way better aaron's solution
select sum(case when status = 'approved' then 1 else 0 end) approved_count,
       sum(case when status is null then 1 else 0 end) as   needs_review
from hotline_messages;
-- even better, but postgres exclusive
select count(*) filter (where status = 'approved') as approved_count,
       count(*) filter (where status is null)      as needs_review
from hotline_messages;