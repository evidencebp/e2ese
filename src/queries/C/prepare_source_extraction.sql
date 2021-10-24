drop view if exists general.relevant_content;

create view
general.relevant_content
as
select
*
from
general.contents_1_august_2021
;

# Finding relevant extensions
select
extension
, count(*)
from
general.relevant_content as cnt
join
general.repos_split as r
on
cnt.repo_name = r.repo_name
where
r.language in ('C', 'C++')
and
oss_license_found
group by
extension
having
count(*) >= 1000
order by
count(*) desc
;


drop table if exists general.lang_relevant_content;

create table
general.lang_relevant_content
as
select
id
, cnt.repo_name
, path as file
, content
, general.bq_repo_split(cnt.repo_name) as repo_split
, general.bq_file_split(cnt.repo_name, path) as file_split
from
general.relevant_content as cnt
join
general.repos_split as r
on
cnt.repo_name = r.repo_name
where
r.language in ('C', 'C++')
and
extension in ('.h'
, '.cpp'
, '.c'
, '.hpp'
, '.cc'
, '.cxx'
, '.hh'
, '.hxx')
and
oss_license_found
;
