
drop table if exists general.lang_relevant_content_train;

create table
general.lang_relevant_content_train
as
select
id
, cnt.repo_name
, file
, content
, general.bq_file_split(cnt.repo_name, file) as file_split
from
general.lang_relevant_content as cnt
where
general.bq_repo_split(cnt.repo_name) = 'Train'
;


drop table if exists general.lang_relevant_content_validation;

create table
general.lang_relevant_content_validation
as
select
id
, cnt.repo_name
, file
, content
, general.bq_file_split(cnt.repo_name, file) as file_split
from
general.lang_relevant_content as cnt
where
general.bq_repo_split(cnt.repo_name) = 'Validation'
;

drop table if exists general.lang_relevant_content_test;

create table
general.lang_relevant_content_test
as
select
id
, cnt.repo_name
, file
, content
, general.bq_file_split(cnt.repo_name, file) as file_split
from
general.lang_relevant_content as cnt
where
general.bq_repo_split(cnt.repo_name) = 'Test'
;
