# Using files of the same developer of different quality in order to learn program difficulty.
# Since the developer is factored out, program difficulty is more dominating.
# Another possible way is same developer, single same date commit and different duration

drop table if exists general.difficulty_pairs_by_ccp;


create table
general.difficulty_pairs_by_ccp
as
select
efp.repo_name
, efp.file as easy_file
, hfp.file as hard_file
from
general.relevant_repos as r
join
general.file_properties as efp
on
r.repo_name = efp.repo_name
join
general.file_properties as hfp
on
efp.repo_name = hfp.repo_name
and
efp.creator_email = hfp.creator_email
where
efp.authors = 1
and
hfp.authors = 1
and
# get files of the same year (same developer skill) and same age
extract(year from efp.min_commit_time) = extract(year from hfp.min_commit_time)
and
extract(year from efp.max_commit_time) = extract(year from hfp.max_commit_time)
and
if(efp.ccp <= -0.048 #ccp_q1
, 1, if(efp.ccp >= 0.23007692307692312 # ccp_q4
, 4, 2)) = 1 and efp.commits >= 5
and
if(hfp.ccp <= -0.048 #ccp_q1
, 1, if(hfp.ccp >= 0.23007692307692312 # ccp_q4
, 4, 2)) = 4 and hfp.commits >= 5
and
not efp.is_test
and
not hfp.is_test
;

# An alternative, complementary way to build paris of different difficulty level is use
# files created by beginners as easy ones, compare to file of programmers experienced in the project
#(again, preferring the the same developer)
# Using beginners code is inspired by "Characterizing and Predicting Good First Issues"
# https://www.eecs.yorku.ca/~wangsong/papers/esem21b.pdf

drop table if exists general.difficulty_pairs_by_tenure;


create table
general.difficulty_pairs_by_tenure
as
select
e.repo_name
, e.file as easy_file
, h.file as hard_file
from
general.relevant_repos as r
join
general.developer_per_repo_profile as d
on
r.repo_name = d.repo_name
join
general.file_properties as e
on
d.repo_name = e.repo_name
and
d.author_email = e.creator_email
and
e.authors = 1 # was create by only this person
and
timestamp_diff(e.max_commit_time, d.min_commit_timestamp, DAY) <= 6*30
join
general.file_properties as h
on
d.repo_name = h.repo_name
and
d.author_email = h.creator_email
and
h.authors = 1 # was create by only this person
and
timestamp_diff(h.min_commit_time, d.min_commit_timestamp, DAY) > 6*30
and
timestamp_diff(h.max_commit_time, d.min_commit_timestamp, DAY) < 12*30
where
e.code_extension
and
not e.is_test
and
h.code_extension
and
not h.is_test
and
e.commits >= 5 # To have file with considerable work
and
h.commits >= 5
;

drop table if exists general.difficulty_pairs_by_commit_duration;


create table
general.difficulty_pairs_by_commit_duration
as
select
e.repo_name
, e.file as easy_file
, h.file as hard_file
from
general.relevant_repos as r
join
general.file_labels as e
on
r.repo_name = e.repo_name
join
general.file_properties as efp
on
e.repo_name = efp.repo_name
and
e.file = efp.file
join
general.file_labels as h
on
e.repo_name = h.repo_name
join
general.file_properties as hfp
on
h.repo_name = hfp.repo_name
and
h.file = hfp.file
and
efp.creator_email = hfp.creator_email
where
e.authors = 1
and
h.authors = 1
and
# get files of the same year (same developer skill) and same age
extract(year from efp.min_commit_time) = extract(year from hfp.min_commit_time)
and
extract(year from efp.max_commit_time) = extract(year from hfp.max_commit_time)
and
(efp.same_day_duration_avg > 10 and efp.same_day_duration_avg <= 30) and e.commits = 1
and
(hfp.same_day_duration_avg > 30 and hfp.same_day_duration_avg <= 120) and h.commits = 1
and
not e.is_test
and
not h.is_test
;
