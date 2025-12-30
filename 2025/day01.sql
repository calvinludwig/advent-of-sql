-- my solution
select wish, count(*) as count
from ( select upper(trim(raw_wish)) as wish from wish_list )
group by wish
order by count desc;

-- aaron's solution
select upper(trim(raw_wish)) as wish, count(*) as count
from wish_list
group by 1
order by 2 desc

-- both solutions have the same Total Cost
