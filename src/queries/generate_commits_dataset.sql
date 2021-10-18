drop table if exists general.relevant_enhanced_commits_extraction;

create table
general.relevant_enhanced_commits_extraction
as
select
ec.repo_name
, ec.commit
, ec.message
, general.bq_repo_split(ec.repo_name) as repo_split
, general.bq_commit_split(commit) as commit_split
from
general.relevant_enhanced_commits as ec

;

drop table if exists general.relevant_commits_files_extraction;

create table
general.relevant_commits_files_extraction
as
select
cf.repo_name
, cf.commit
, cf.file
, general.bq_repo_split(cf.repo_name) as repo_split
, general.bq_commit_split(commit) as commit_split
from
general.relevant_commits_files as cf
;
