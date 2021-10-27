# extract_previous_file_properties.sql
drop table if exists general.previous_file_properties;

create table
general.previous_file_properties
as
SELECT repo_name
, file
, is_test
, commits
, ccp
, corrective_commits
, refactor_mle
, avg_coupling_code_size_cut
, authors
, same_day_duration_avg
, prev_touch_ago
, bug_prev_touch_ago
, one_file_fix_rate
, one_file_refactor_rate
, textual_abstraction_commits_rate
, abs_content_ratio
, size
, performance_rate
, security_rate
FROM general.relevant_file_properties
where
extension = '.go'
;