# file_properties.sql
# This file is based on file_properties.sql from the general repository
# The main difference is (and should be kept) that the computation is on the
# pre-prepared relevant data and the table names are adapted.
# The difference is marked in "NOTE"
# You should check them and update accordingly.

drop table if exists general.relevant_file_properties;


create table
general.relevant_file_properties
as
select
cf.repo_name as repo_name
, file
, '' as creator_name
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

, if(sum(if(files <= 103, files, null)) > 0
    , sum(if(files <= 103, files - non_test_files, null))/ sum(if(files <= 103, files, null))
    , null) as test_file_ratio_cut
, if(sum(if(code_files <= 103, code_files, null)) > 0
    , sum(if(code_files <= 103, code_files - code_non_test_files, null))/ sum(if(code_files <= 103, code_files, null))
    , null) as test_code_file_ratio_cut

, count(distinct cf.Author_email) as authors
, max(cf.Author_email) as Author_email # Meaningful only when authors=1
, min(ec.commit_month) as commit_month

, avg(if(same_date_as_prev, duration, null)) as same_day_duration_avg

, 0.0 as prev_touch_ago
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
, 0.0 as abs_content_ratio

, -1.0 as size

, count(distinct if(is_performance, ec.commit, null))/count(distinct ec.commit) as performance_rate
, count(distinct if(is_security, ec.commit, null))/count(distinct ec.commit) as security_rate

from
general.relevant_commits_files as cf
join
general.relevant_enhanced_commits as ec
on
cf.commit = ec.commit and cf.repo_name = ec.repo_name
group by
repo_name
, file
;

drop table if exists general.relevant_file_first_commit;


create table
general.relevant_file_first_commit
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
general.relevant_file_properties as fp
join
general.relevant_commits_files as cf
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


update general.relevant_file_properties as fp
set creator_name = ffc.creator_name, creator_email = ffc.creator_email
from
general.relevant_file_first_commit as ffc
where
fp.repo_name = ffc.repo_name
and
fp.file = ffc.file
and
fp.min_commit_time = ffc.min_commit_time
and
ffc.authors = 1 # For uniqueness checking
;

drop table if exists general.relevant_file_first_commit;


drop table if exists general.relevant_file_testing_pair_involvement;

create table general.relevant_file_testing_pair_involvement
as
select
c.repo_name
, c.file
, avg(if(c.test_involved, 1,0) ) as testing_involved_prob
, if( sum(if(c.is_corrective, 1,0)) > 0
    , 1.0*sum(if(c.test_involved and c.is_corrective, 1,0) )/sum(if(c.is_corrective, 1,0))
    , null) as corrective_testing_involved_prob
, if( sum(if(c.is_refactor, 1,0)) > 0
    , 1.0*sum(if(c.test_involved and c.is_refactor, 1,0) )/sum(if(c.is_refactor, 1,0))
    , null) as refactor_testing_involved_prob
from
general.testing_pairs_commits as c
# NOTE - this join does not appear in  file_properties.sql
# It should not be updated when running but only when updating new file_properties modifications
join
general.relevant_enhanced_commits as rec
on
c.repo_name = rec.repo_name
and
c.commit = rec.commit
group by
c.repo_name
, c.file
;

update general.relevant_file_properties as fp
set testing_involved_prob = aux.testing_involved_prob
, corrective_testing_involved_prob = aux.corrective_testing_involved_prob
, refactor_testing_involved_prob = aux.refactor_testing_involved_prob
from
general.relevant_file_testing_pair_involvement as aux
where
fp.repo_name = aux.repo_name
and
fp.file = aux.file
;

drop table if exists general.relevant_file_testing_pair_involvement;


drop table if exists general.relevant_file_content_abstraction;

create table general.relevant_file_content_abstraction
as
SELECT
cnt.repo_name as repo_name
, file
 FROM
 general.lang_relevant_content as cnt
WHERE
general.bq_abstraction(lower(content)) > 0
;

update general.relevant_file_properties as fp
set abs_content_ratio = 1.0
from
general.relevant_file_content_abstraction as aux
where
fp.repo_name = aux.repo_name
and
fp.file = aux.file
;

update general.relevant_file_properties as fp
set fp.size = aux.size
from
general.relevant_content as aux
where
fp.repo_name = aux.repo_name
and
fp.file = aux.path
;
