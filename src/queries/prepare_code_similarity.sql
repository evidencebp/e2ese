# prepare_code_similarity.sql
drop view if exists general.contents_prev_content;

create view
general.contents_prev_content
as
select
cnt.repo_name
, content
, path as file
from
general.contents_1_october_2022 as cnt
join
general.relevant_repos as r
on
cnt.repo_name = r.repo_name

;

drop view if exists general.contents_cur_content;

create view
general.contents_cur_content
as
select
cnt.repo_name
, content
, path as file
from
general.contents_1_december_2022 as cnt
join
general.relevant_repos as r
on
cnt.repo_name = r.repo_name
;

