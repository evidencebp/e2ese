

# TODO - properties prior to June
# TODO - properties from june to August
drop table if exists general.june_2020_go_file_properties;

create table
general.june_2020_go_file_properties
as
select
id
, fp.*
, general.bq_repo_split(cnt.repo_name) as repo_split
, general.bq_file_split(cnt.repo_name, cnt.file) as file_split
from
general.june_2021_go_file_content as cnt
join
general.file_properties as fp
on
cnt.repo_name = fp.repo_name
and
cnt.file = fp.file
;
