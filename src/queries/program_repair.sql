# into program_repair.csv

# Program repair samples
# files with a single commit, so we have the diff in the content files.
# The repair can be a fix or a refactor, modifying a single non test code file.

drop table if exists general.program_repair;

create table general.program_repair
as
select
fl.repo_name
, fl.file
, fl.min_commit as commit
, is_corrective
, is_refactor
from
general.relevant_file_properties as fl
join
general.enhanced_commits as ec
on
fl.repo_name = ec.repo_name
and
fl.min_commit = ec.commit
where
fl.commits = 1
and
(ec.code_non_test_files = 1)
and
(is_refactor or is_corrective)
order by
fl.repo_name
, fl.min_commit
, fl.file
;