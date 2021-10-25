# commit_file_prev_touch.sql
# Based on general/commit_file_prev_touch.sql (for file properties)
# Should be modified accordingly when the source is modified.

drop table if exists general.relevant_commits_files_prev_timestamp;

create table
general.relevant_commits_files_prev_timestamp
as
select
cur.repo_name as repo_name
, cur.commit as commit
, cur.file as file
, max(cur.author_email) as author_email
, count(distinct cur.author_email) as authors
, max(cur.is_corrective) as is_corrective
, max(cur.commit_timestamp) as commit_timestamp
, max(prev.commit_timestamp) as prev_timestamp
from
general.relevant_commits_files as cur
left join
general.commits_files as prev
on
cur.repo_name = prev.repo_name
and
cur.file = prev.file
and
cur.commit_timestamp > prev.commit_timestamp
and not cur.is_test
and cur.code_extension #Running only on functional code
group by
cur.repo_name
, cur.commit
, cur.file
;


drop table if exists general.relevant_commits_files_with_prev;

create table
general.relevant_commits_files_with_prev
as
select
cur.repo_name as repo_name
, cur.commit as commit
, cur.file as file
, max(cur.author_email) as author_email
, count(distinct cur.author_email) as authors
, max(cur.is_corrective) as is_corrective
, max(cur.commit_timestamp) as commit_timestamp
, max(cur.prev_timestamp) as prev_timestamp
, max(prev.commit) as prev_commit # The max is extra safety for the case of two commits in the same time
from
general.relevant_commits_files_prev_timestamp as cur
left join
general.relevant_commits_files_prev_timestamp as prev
on
cur.repo_name = prev.repo_name
and
cur.file = prev.file
and
cur.prev_timestamp = prev.commit_timestamp
group by
cur.repo_name
, cur.commit
, cur.file
;


drop table if exists general.relevant_commits_files_with_prev_touch;

create table
general.relevant_commits_files_with_prev_touch
as
select
main.*
, TIMESTAMP_DIFF(commit_timestamp, prev_timestamp, minute) as prev_touch_ago
, date(commit_timestamp) = date(prev_timestamp) as same_date_as_prev
from
general.relevant_commits_files_with_prev as main
;


drop table if exists general.relevant_file_prev_touch_stats;

create table
general.relevant_file_prev_touch_stats
as
select
repo_name
, file
, avg(prev_touch_ago) as prev_touch_ago
, avg(if(is_corrective, prev_touch_ago, null)) as bug_prev_touch_ago
from
general.relevant_commits_files_with_prev_touch
group by
repo_name
, file
;

update general.relevant_file_properties as rp
set
prev_touch_ago = aux.prev_touch_ago
, bug_prev_touch_ago = aux.bug_prev_touch_ago
from
general.relevant_file_prev_touch_stats as aux
where
rp.repo_name = aux.repo_name
and
rp.file = aux.file
;





drop table if exists general.relevant_file_prev_touch_stats;
drop table if exists general.relevant_commits_files_prev_timestamp;
drop table if exists general.relevant_commits_files_with_prev;
drop table if exists general.relevant_commits_files_with_prev_touch;
