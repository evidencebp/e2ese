
# general.bq_repo_type is defined in split_util.sql in
# https://github.com/evidencebp/general

drop table if exists general.repos_split;

create table
general.repos_split
as
select
r.*
, license
, license in (
'agpl-3.0'
, 'apache-2.0'
, 'artistic-2.0'
, 'bsd-2-clause'
, 'bsd-3-clause'
, 'cc0-1.0'
, 'epl-1.0'
, 'gpl-2.0'
, 'gpl-3.0'
, 'isc'
, 'lgpl-2.1'
, 'lgpl-3.0'
, 'mit'
, 'mpl-2.0'
, 'unlicense'
) as oss_license_found
, general.bq_repo_split(r.repo_name) as type
from
general.repos as r
left join
`bigquery-public-data.github_repos.licenses` as l
on
r.repo_name = l.repo_name
;

select
type
, count(*) as repos
from
general.repos_split
group by
type
;


select
license
, count(*) as repos
from
general.repos_split
group by
license
;
