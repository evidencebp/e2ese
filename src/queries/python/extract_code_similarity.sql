# Contains a stricter similarity dataset.
# It originated from a too large data set.
# However, it contains source code of the relevant file, which are not tests.
# Hence, this dataset my be more suitable to some datasets.

# Note that code similarity datasets, according to your need, can be generated
# from the source code directly.
drop table if exists general.relevant_code_similarity;

create table
general.relevant_code_similarity
as
select
*
from
general.code_similarity
where
RIGHT(file1, 3) = '.py'
and
not regexp_contains(lower(file1), 'test')
and
RIGHT(file2, 3) = '.py'
and
not regexp_contains(lower(file2), 'test')
;
