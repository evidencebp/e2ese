

drop table if exists general.contents_diff;


create table
general.contents_diff
as
select
c.repo_name
, c.file as file
, c.content as current_content
, p.content as prev_content
from
general.contents_prev_content as p
join
general.contents_cur_content as c
on
p.repo_name = c.repo_name
and
p.file = c.file
where
p.content != c.content
;


drop table if exists general.code_similarity;

create table
general.code_similarity
as
select
f1.repo_name
, f1.file as file1
, f2.file as file2
, general.bq_repo_split(f1.repo_name) as repo_split
, general.bq_file_pair_split(f1.repo_name
 , f1.file
 , f2.repo_name
 , f2.file
) as pair_split
, 0 as Is_Similar
from
general.contents_diff as f1
join
general.contents_cur_content as f2
on
f1.repo_name = f2.repo_name
and
f1.file != f2.file
where
lower(if(STRPOS(f1.file, '/') >= 0
    , reverse(substr(reverse(f1.file), STRPOS(reverse(f1.file), '/') ))
    , null))
=  lower(if(STRPOS(f2.file, '/') >= 0
    , reverse(substr(reverse(f2.file), STRPOS(reverse(f2.file), '/') ))
    , null))
# Filter about a 3/4 in order to get positive/negative ratio 1:10
and
substr(TO_HEX(md5(concat(f1.repo_name
 , f1.file
 , f2.repo_name
 , f2.file
 , "48hf5tg"))), 9,1) in ('1', '2','3', '4')
;

insert into
general.code_similarity
select
f1.repo_name
, f1.file as file1
, f1.file as file2
, general.bq_repo_split(f1.repo_name) as repo_split
, general.bq_file_pair_split(f1.repo_name
 , f1.file
 , f1.repo_name
 , f1.file
) as pair_split
, 1 as Is_Similar
from
general.contents_diff as f1
;



drop table if exists general.contents_diff_train;

create table
general.contents_diff_train
as
select
*
from
general.contents_diff
where
general.bq_repo_split(repo_name) = 'Train'
;



drop table if exists general.contents_diff_validation;

create table
general.contents_diff_validation
as
select
*
from
general.contents_diff
where
general.bq_repo_split(repo_name) = 'Validation'
;



drop table if exists general.contents_diff_test;

create table
general.contents_diff_test
as
select
*
from
general.contents_diff
where
general.bq_repo_split(repo_name) = 'Test'
;

