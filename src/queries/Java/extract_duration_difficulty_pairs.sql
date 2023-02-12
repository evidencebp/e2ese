# Contains a stricter similarity dataset.
# It originated from a too large data set.
# However, it contains names of the relevant file, which are not tests.
# Hence, this dataset my be more suitable to some datasets.

drop table if exists general.relevant_difficulty_pairs_by_commit_duration;


create table
general.relevant_difficulty_pairs_by_commit_duration
as
select
*
from
general.difficulty_pairs_by_commit_duration
where
lower(RIGHT(easy_file, 5)) = '.java'
and
not regexp_contains(lower(easy_file), 'test')
and
lower(RIGHT(hard_file, 5)) = '.java'
and
not regexp_contains(lower(hard_file), 'test')
;
