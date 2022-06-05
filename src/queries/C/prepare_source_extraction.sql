# C/prepare_source_extraction.sql

drop view if exists general.relevant_content;

create view
general.relevant_content
as
select
*
from
general.contents_1_june_2022
;

drop table if exists general.relevant_repos;


create table
general.relevant_repos
as
select
repo_name
from
general.repos as r
where
r.language in ('C', 'C++')
;

# Finding relevant extensions
select
extension
, count(*)
from
general.relevant_content as cnt
join
general.repos as r
on
cnt.repo_name = r.repo_name
where
r.language in ('C', 'C++')
#and
#oss_license_found
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
general.repos as r
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
;
