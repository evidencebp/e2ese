# Go/prepare_source_extraction.sql


drop view if exists general.relevant_content;

create view
general.relevant_content
as
select
*
from
# Note - set proper content version
general.contents_1_october_2022
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
# Note - set language when porting to a new language
r.language = 'Go'
#and
#oss_license_found
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
# Note - set language when porting to a new language
r.language = 'Go'
and
extension = '.go'
#and
#oss_license_found
;
