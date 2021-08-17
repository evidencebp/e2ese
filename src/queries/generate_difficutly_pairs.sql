# Using files of the same developer of different quality in order to learn program difficulty.
# Since the developer is factored out, program difficulty is more dominating.
# An alternative, complementary way to build paris of different difficulty level is use
# files created by beginners as easy ones, compare to file of programmers experienced in the project
#(again, preferring the the same developer)
# Using beginners code is inspired by "Characterizing and Predicting Good First Issues"
# https://www.eecs.yorku.ca/~wangsong/papers/esem21b.pdf

drop table if exists general.difficulty_pairs;


create table
general.difficulty_pairs
as
select
e.repo_name
, e.file as easy_file
, h.file as hard_file
from
general.file_labels as e
join
general.file_labels as h
on
e.repo_name = h.repo_name
and
e.creator_email = h.creator_email
where
e.authors = 1
and
h.authors = 1
and
# get files of the same year (same developer skill) and same age
extract(year from e.min_commit_time) = extract(year from h.min_commit_time)
and
extract(year from e.max_commit_time) = extract(year from h.max_commit_time)
and
e.ccp_level = 1 and e.commits >= 10
and
h.ccp_level = 4 and e.commits >= 10
;