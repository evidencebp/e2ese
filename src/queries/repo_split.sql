CREATE OR REPLACE FUNCTION
general.bq_repo_type
 (repo_name string)
 RETURNS string
AS (
    case
        when substr(TO_HEX(md5(repo_name)), 1,1) = '0'  then 'Validation'
        when substr(TO_HEX(md5(repo_name)), 1,1) = '1'  then 'Test'
        else 'Train' end # Train

 )
;


WITH tab AS (
  SELECT  'tensorflow/tensorflow' AS repo_name
            , 'Train' as expected
    UNION ALL SELECT '3846masa/upload-gphotos'
                    , 'Validation'

    UNION ALL SELECT '3scale/echo-api'
                    , 'Test'

    UNION ALL SELECT null
                    , null
)
SELECT repo_name
, expected
, general.bq_repo_type(repo_name) as actual
, general.bq_repo_type(repo_name) = expected as pass
FROM tab as testing
;

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
, general.bq_repo_type(r.repo_name) as type
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
