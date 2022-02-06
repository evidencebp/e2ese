# prepare_after_extraction.sql

# NOTE - Set source_date to proper value
DECLARE source_date DATE DEFAULT PARSE_DATE('%d/%m/%Y',  '1/12/2021');
DECLARE prediction_date DATE DEFAULT DATE_ADD(source_date, INTERVAL 2 month) ;

SELECT source_date, prediction_date;


drop table if exists general.relevant_enhanced_commits;


create table
general.relevant_enhanced_commits
partition by
commit_month
cluster by
repo_name, commit
as
select
ec.*
from
general.relevant_repos as r
join
general.enhanced_commits as ec
on
r.repo_name = ec.repo_name
where
date(ec.commit_timestamp) > source_date
and
date(ec.commit_timestamp) <= prediction_date
;


drop table if exists general.relevant_commits_files;


create table
general.relevant_commits_files
partition by
commit_month
cluster by
repo_name, commit, file
as
select
cf.*
from
general.commits_files as cf
join
general.relevant_enhanced_commits as rec
on
cf.repo_name = rec.repo_name
and
cf.commit = rec.commit
;