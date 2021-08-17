drop table if exists general.june_aug_2021_java_commits;

create table
general.june_aug_2021_java_commits
as
select
r.repo_name
, ec.commit
, ec.message
, general.bq_repo_split(r.repo_name) as repo_split
, general.bq_commit_split(commit) as commit_split
from
general.enhanced_commits as ec
join
general.repos_split as r
on
ec.repo_name = r.repo_name
where
r.language = 'Java'
and
oss_license_found
and
# END_DATE
(PARSE_DATE('%d/%m/%Y',  '1/8/2021') > date(ec.commit_timestamp))
and
# START_DATE
(PARSE_DATE('%d/%m/%Y',  '1/6/2021') <= date(ec.commit_timestamp))
;

drop table if exists general.june_aug_2021_java_commits_files;

create table
general.june_aug_2021_java_commits_files
as
select
r.repo_name
, cf.commit
, cf.file
, general.bq_repo_split(r.repo_name) as repo_split
, general.bq_commit_split(commit) as commit_split
from
general.commits_files as cf
join
general.repos_split as r
on
cf.repo_name = r.repo_name
where
r.language = 'Java'
and
oss_license_found
and
# END_DATE
(PARSE_DATE('%d/%m/%Y',  '1/8/2021') > date(cf.commit_timestamp))
and
# START_DATE
(PARSE_DATE('%d/%m/%Y',  '1/6/2021') <= date(cf.commit_timestamp))
;
