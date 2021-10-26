drop view if exists general.contents_prev_content;

create view
general.contents_prev_content
as
select
*
from
general.june_2021_c_file_content
;

drop view if exists general.contents_cur_content;

create view
general.contents_cur_content
as
select
*
from
general.august_2021_c_file_content
;

