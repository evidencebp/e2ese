# file_properties_per_period.sql

# NOTE - Set START_DATE, END_DATE to proper values

drop table if exists general.file_properties_per_period;


create table
general.file_properties_per_period
as
select
cf.repo_name as repo_name
, file
#, '' as creator_name # Note - these are the first commiter in the period, possibly not the creator
, '' as creator_email
, min(cf.commit_timestamp) as min_commit_time
, max(cf.commit_timestamp) as max_commit_time
, min(cf.commit) as min_commit
, max(extension) as extension
, max(code_extension) as code_extension
, max(is_test) as is_test
, count(distinct cf.commit) as commits
, count(distinct if(parents = 1, cf.commit, null)) as non_merge_commits
, count(distinct case when cf.is_corrective  then cf.commit else null end) as corrective_commits
, 1.0*count(distinct if(cf.is_corrective, cf.commit, null))/count(distinct cf.commit) as corrective_rate
, general.bq_ccp_mle(1.0*count(distinct if(cf.is_corrective, cf.commit, null))/count(distinct cf.commit)) as ccp
, general.bq_refactor_mle(1.0*count(distinct case when cf.is_refactor  then cf.commit else null end)/count(distinct cf.commit))
        as refactor_mle
, avg(if(not cf.is_corrective, non_test_files, null)) as avg_coupling_size
, avg(if(not cf.is_corrective, code_non_test_files, null)) as avg_coupling_code_size
, avg(if(not cf.is_corrective, if(non_test_files > 103 , 103 , non_test_files), null)) as avg_coupling_size_capped
, avg(if(not cf.is_corrective, if(code_non_test_files> 103 , 103 ,code_non_test_files), null)) as avg_coupling_code_size_capped
, avg(if(not cf.is_corrective, if(non_test_files > 103 , null , non_test_files), null)) as avg_coupling_size_cut
, avg(if(not cf.is_corrective, if(code_non_test_files> 10 , null ,code_non_test_files), null)) as avg_coupling_code_size_cut
#, avg(if(not cf.is_corrective, if(code_non_test_files> 10 , null ,code_non_test_files), null)) as avg_coupling_code_size_cut10

, if(sum(if(files <= 10, files, null)) > 0
    , sum(if(files <= 10, files - non_test_files, null))/ sum(if(files <= 103, files, null))
    , null) as test_file_ratio_cut
, if(sum(if(code_files <= 10, code_files, null)) > 0
    , sum(if(code_files <= 10, code_files - code_non_test_files, null))/ sum(if(code_files <= 10, code_files, null))
    , null) as test_code_file_ratio_cut

, count(distinct cf.Author_email) as authors
, max(cf.Author_email) as Author_email # Meaningful only when authors=1
, min(ec.commit_month) as commit_month

, count(distinct if(same_date_as_prev, ec.commit, null)) as same_day_commits
, avg(if(same_date_as_prev, duration, null)) as same_day_duration_avg

, 0.0 as prev_touch_ago # Not updated now
, 0.0 as bug_prev_touch_ago

# Abstraction
, if (sum(if(ec.is_corrective, 1,0 )) > 0
, 1.0*sum(if( code_non_test_files = 1 and ec.is_corrective, 1,0 ))/sum(if(ec.is_corrective, 1,0 ))
, null)
as one_file_fix_rate
, if (sum(if(ec.is_refactor, 1,0 )) > 0
, 1.0*sum(if( code_non_test_files = 1 and ec.is_refactor, 1,0 ))/sum(if(ec.is_refactor, 1,0 ))
, null)
as one_file_refactor_rate

, if(sum(if((code_non_test_files = 1 and code_files = 2 ) or code_files=1, 1,0 )) > 0
    , 1.0*sum(if(code_files=1, 1,0 ))/sum(if((code_non_test_files = 1 and code_files = 2 ) or code_files=1, 1,0 ))
    , null)
as test_usage_rate

, if(sum(if(ec.is_refactor and ((code_non_test_files = 1 and code_files = 2 ) or code_files=1), 1,0 )) > 0
    , 1.0*sum(if(ec.is_refactor and code_files=1, 1,0 ))
        /sum(if(ec.is_refactor and ((code_non_test_files = 1 and code_files = 2 ) or code_files=1), 1,0 ))
    , null)
as test_usage_in_refactor_rate

, if(sum(if(ec.is_refactor, 1,0 )) > 0
    , 1.0*sum(if( code_non_test_files = code_files and ec.is_refactor, 1,0 ))/sum(if(ec.is_refactor, 1,0 ))
    , null )
as no_test_refactor_rate
, sum(if(general.bq_abstraction(lower(message)) > 0, 1, 0)) as textual_abstraction_commits
, 1.0*sum(if(general.bq_abstraction(lower(message)) > 0, 1, 0))/count(*) as textual_abstraction_commits_rate

, -1.0 as testing_involved_prob
, -1.0 as corrective_testing_involved_prob
, -1.0 as refactor_testing_involved_prob
, 0.0 as abs_content_ratio # By the end of the period

, -1.0 as size

, count(distinct if(ec.is_performance, ec.commit, null))/count(distinct ec.commit) as performance_rate
, count(distinct if(ec.is_performance and ec.is_corrective, ec.commit, null))/count(distinct ec.commit) as performance_fix_rate
, count(distinct if(ec.is_security, ec.commit, null))/count(distinct ec.commit) as security_rate
, count(distinct if(ec.is_security and ec.is_corrective, ec.commit, null))/count(distinct ec.commit) as security_fix_rate

from
general.commits_files as cf
join
general.enhanced_commits as ec
on
cf.commit = ec.commit
and
cf.repo_name = ec.repo_name
where
# END_DATE
(PARSE_DATE('%d/%m/%Y',  '1/8/2021') > date(ec.commit_timestamp))
and
# START_DATE
(PARSE_DATE('%d/%m/%Y',  '1/6/2021') <= date(ec.commit_timestamp))
group by
repo_name
, file
;


drop table if exists general.file_first_commit;


create table
general.file_first_commit
as
select
fp.repo_name as repo_name
, fp.file as file
, min(fp.min_commit_time) as min_commit_time
, min(cf.author_name) as creator_name
, min(cf.author_email) as creator_email
, count(distinct commit) as commits # For uniqueness checking
, count(distinct cf.author_email) as authors # For uniqueness checking
from
general.file_properties_per_period as fp
join
general.commits_files as cf
on
fp.repo_name = cf.repo_name
and
fp.file = cf.file
and
fp.min_commit_time = cf.commit_timestamp
group by
fp.repo_name
, fp.file
;


update general.file_properties_per_period as fp
set
#creator_name = ffc.creator_name, # not set for privacy
creator_email = ffc.creator_email
from
general.file_first_commit as ffc
where
fp.repo_name = ffc.repo_name
and
fp.file = ffc.file
and
fp.min_commit_time = ffc.min_commit_time
and
ffc.authors = 1 # For uniqueness checking
;

drop table if exists general.file_first_commit;


drop table if exists general.file_testing_pair_involvement;

create table general.file_testing_pair_involvement
as
select
repo_name
, file
, avg(if(test_involved, 1,0) ) as testing_involved_prob
, if( sum(if(is_corrective, 1,0)) > 0
    , 1.0*sum(if(test_involved and is_corrective, 1,0) )/sum(if(is_corrective, 1,0))
    , null) as corrective_testing_involved_prob
, if( sum(if(is_refactor, 1,0)) > 0
    , 1.0*sum(if(test_involved and is_refactor, 1,0) )/sum(if(is_refactor, 1,0))
    , null) as refactor_testing_involved_prob
from
general.testing_pairs_commits
where
(general.period_start() is null or general.period_start() <= date(commit_timestamp))
and
(general.period_end() is null or general.period_end() > date(commit_timestamp))
group by
repo_name
, file
;

update general.file_properties_per_period as fp
set testing_involved_prob = aux.testing_involved_prob
, corrective_testing_involved_prob = aux.corrective_testing_involved_prob
, refactor_testing_involved_prob = aux.refactor_testing_involved_prob
from
general.file_testing_pair_involvement as aux
where
fp.repo_name = aux.repo_name
and
fp.file = aux.file
;

drop table if exists general.file_testing_pair_involvement;

# TODO - update link to the relevant content table

drop table if exists general.file_content_abstraction;

create table general.file_content_abstraction
as
SELECT
cnt.repo_name as repo_name
, path as file
 FROM
 general.contents as cnt
WHERE
general.bq_abstraction(lower(content)) > 0
;

update general.file_properties_per_period as fp
set abs_content_ratio = 1.0
from
general.file_content_abstraction as aux
where
fp.repo_name = aux.repo_name
and
fp.file = aux.file
;

update general.file_properties_per_period as fp
set fp.size = aux.size
from
general.contents as aux
where
fp.repo_name = aux.repo_name
and
fp.file = aux.path
;
