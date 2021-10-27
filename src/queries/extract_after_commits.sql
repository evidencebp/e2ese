# extract_after_commits.sql
drop table if exists general.after_commits;

create table
general.after_commits
as
select
*
from
general.relevant_enhanced_commits_extraction

;

drop table if exists general.after_commits_files;

create table
general.after_commits_files
as
select
*
from
general.relevant_commits_files_extraction
;
