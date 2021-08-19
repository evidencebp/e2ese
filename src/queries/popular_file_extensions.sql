# into popular_file_extensions.csv
select
extension as f
, count(*) as files
from
general.contents_1_june_2021
group by
f
having
count(*) >= 500
order by
count(*) desc
;