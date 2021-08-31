drop table if exists general.august_2021_python_file_content;

create table
general.august_2021_python_file_content
as
select
id
, cnt.repo_name
, path as file
, content
, general.bq_repo_split(cnt.repo_name) as repo_split
, general.bq_file_split(cnt.repo_name, path) as file_split
from
general.contents_1_august_2021 as cnt
join
general.repos_split as r
on
cnt.repo_name = r.repo_name
where
r.language = 'Python'
and
extension = '.py'
and
oss_license_found
;

drop table if exists general.august_2021_python_file_content_train;

create table
general.august_2021_python_file_content_train
as
select
id
, cnt.repo_name
, file
, content
, general.bq_file_split(cnt.repo_name, file) as file_split
from
general.august_2021_python_file_content as cnt
where
general.bq_repo_split(cnt.repo_name) = 'Train'
;

drop table if exists general.august_2021_python_file_content_test;

create table
general.august_2021_python_file_content_test
as
select
id
, cnt.repo_name
, file
, content
, general.bq_file_split(cnt.repo_name, file) as file_split
from
general.august_2021_python_file_content as cnt
where
general.bq_repo_split(cnt.repo_name) = 'Test'
;


drop table if exists general.august_2021_python_file_content_validation;

create table
general.august_2021_python_file_content_validation
as
select
id
, cnt.repo_name
, file
, content
, general.bq_file_split(cnt.repo_name, file) as file_split
from
general.august_2021_python_file_content as cnt
where
general.bq_repo_split(cnt.repo_name) = 'Validation'
;

# TODO - properties prior to June
# TODO - properties from august to August
drop table if exists general.august_2020_python_file_properties;

create table
general.august_2020_python_file_properties
as
select
id
, fp.*
, general.bq_repo_split(cnt.repo_name) as repo_split
, general.bq_file_split(cnt.repo_name, cnt.file) as file_split
from
general.august_2021_python_file_content as cnt
join
general.file_properties as fp
on
cnt.repo_name = fp.repo_name
and
cnt.file = fp.file
;
