# generate_labels.sql

drop table if exists general.file_labels;


create table
general.file_labels
as
select
f.*
, -1 as ccp_level
, -1 as duration_level
#, -1 as prev_touch_level # Not updated now
, -1 as coupling_level
, -1 as one_file_fix_rate_label
, if(corrective_commits > 0, 1 ,0) as has_bug
, general.bq_repo_split(f.repo_name) as repo_split
, general.bq_file_split(f.repo_name, f.file) as file_split
from
general.after_file_properties as f
;


#drop table if exists general.file_labels_thresholds;


#create table
#general.file_labels_thresholds
#as
#select
#distinct
#PERCENTILE_DISC(ccp, 0.25) OVER() AS ccp_q1
#, PERCENTILE_DISC(ccp, 0.75) OVER() AS ccp_q4

#, PERCENTILE_DISC(same_day_duration_avg, 0.25) OVER() AS same_day_duration_avg_q1
#, PERCENTILE_DISC(same_day_duration_avg, 0.75) OVER() AS same_day_duration_avg_q4

#, PERCENTILE_DISC(bug_prev_touch_ago, 0.25) OVER() AS bug_prev_touch_ago_q1
#, PERCENTILE_DISC(bug_prev_touch_ago, 0.75) OVER() AS bug_prev_touch_ago_q4

#, PERCENTILE_DISC(avg_coupling_code_size_cut, 0.25) OVER() AS avg_coupling_code_size_cut_q1
#, PERCENTILE_DISC(avg_coupling_code_size_cut, 0.75) OVER() AS avg_coupling_code_size_cut_q4

#, PERCENTILE_DISC(one_file_fix_rate, 0.25) OVER() AS one_file_fix_rate_q1
#, PERCENTILE_DISC(one_file_fix_rate, 0.75) OVER() AS one_file_fix_rate_q4

#from
#general.after_file_properties # Thresholds were computed once and kept the same for all data sets
#where
#commits >= 10
#;


update general.file_labels as fp
set
ccp_level = if(ccp <= ccp_q1, 1, if(ccp >= ccp_q4, 4, 2))
, duration_level = if(same_day_duration_avg <= same_day_duration_avg_q1, 1, if(same_day_duration_avg >= same_day_duration_avg_q4, 4, 2))
#, prev_touch_level = if(bug_prev_touch_ago <= bug_prev_touch_ago_q1, 1, if(bug_prev_touch_ago >= bug_prev_touch_ago_q4, 4, 2))
, coupling_level = if(avg_coupling_code_size_cut <= avg_coupling_code_size_cut_q1, 1, if(avg_coupling_code_size_cut >= avg_coupling_code_size_cut_q4, 4, 2))
, one_file_fix_rate_label = if(corrective_commits > 0
    , if(one_file_fix_rate <= one_file_fix_rate_q1, 1, if(one_file_fix_rate >= one_file_fix_rate_q4, 4, 2))
    , null)
from
general.file_labels_thresholds 
where 
true
;

# into file_labels_stats.csv - also computed once
#select
#count(*) as files
#, sum(if(commits >= 10,1,0)) as files_with_10_commits
#, avg(has_bug) as has_bug
#, sum(if(commits >= 10,has_bug,0)) as has_bug_with_10_commits
#, sum(if(ccp_level=1,1,0)) as ccp_q1
#, sum(if(ccp_level=4,1,0)) as ccp_q4
#, sum(if(performance_fix_rate> 0, 1,0)) as performance_fixs
#, sum(if(security_fix_rate> 0, 1,0)) as security_fixs
#from
#general.file_labels
#;
