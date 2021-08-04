
drop table if exists general.contents_diff_java_june_aug_2021;


create table
general.contents_diff_java_june_aug_2021
as
select
n.repo_name
, n.path as file
, n.content
from
general.june_2021_java_file_content as p
join
general.contents_1_august_2021 as n
on
p.repo_name = n.repo_name
and
p.file = n.path
where
p.content != n.content
;


drop table if exists general.java_june_aug_2021_similarity;

create table
general.java_june_aug_2021_similarity
as
select
f1.repo_name
, f1.file as file1
, f2.path as file2
, general.bq_repo_split(f1.repo_name) as repo_split
, general.bq_file_pair_split(f1.repo_name
 , f1.file
 , f2.repo_name
 , f2.path
) as pair_split
, 0 as Is_Similar
from
general.contents_diff_java_june_aug_2021 as f1
join
general.contents_1_august_2021 as f2
on
f1.repo_name = f2.repo_name
and
f1.file != f2.path
where
lower(if(STRPOS(f1.file, '/') >= 0
    , reverse(substr(reverse(f1.file), STRPOS(reverse(f1.file), '/') ))
    , null))
=  lower(if(STRPOS(f2.path, '/') >= 0
    , reverse(substr(reverse(f2.path), STRPOS(reverse(f2.path), '/') ))
    , null))
# Filter about a 3/4 in order to get positive/negative ratio 1:10
and
substr(TO_HEX(md5(concat(f1.repo_name
 , f1.file
 , f2.repo_name
 , f2.path
 , "48hf5tg"))), 9,1) in ('1', '2','3', '4')
;

insert into
general.java_june_aug_2021_similarity
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
general.contents_diff_java_june_aug_2021 as f1
;



drop table if exists general.contents_diff_java_june_aug_2021_test;

create table
general.contents_diff_java_june_aug_2021_test
as
select
*
from
general.contents_diff_java_june_aug_2021
where
general.bq_repo_split(repo_name) = 'Test'
;


drop table if exists general.contents_diff_java_june_aug_2021_validation;

create table
general.contents_diff_java_june_aug_2021_validation
as
select
*
from
general.contents_diff_java_june_aug_2021
where
general.bq_repo_split(repo_name) = 'Validation'
;


drop table if exists general.contents_diff_java_june_aug_2021_train;

create table
general.contents_diff_java_june_aug_2021_train
as
select
*
from
general.contents_diff_java_june_aug_2021
where
general.bq_repo_split(repo_name) = 'Train'
;

drop table if exists general.contents_diff_java_june_aug_2021_test;
drop table if exists general.contents_diff_java_june_aug_2021_validation;
drop table if exists general.contents_diff_java_june_aug_2021_train;
