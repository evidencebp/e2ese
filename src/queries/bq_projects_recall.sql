# Standard Sql
drop table if exists general.bq_repos;

create table
general.bq_repos
as
SELECT
  commit_repo_name as repo_name,
  COUNT(DISTINCT commit) AS commits,
  COUNT(DISTINCT
    CASE
      WHEN extract(year from TIMESTAMP_SECONDS(committer.date.seconds)) = 2020 THEN commit
      ELSE NULL END) AS commits_2020,
  COUNT(DISTINCT committer.email) AS commiters,
  MIN(TIMESTAMP_SECONDS(committer.date.seconds)) AS start_time,
  MAX(TIMESTAMP_SECONDS(committer.date.seconds)) AS end_time
FROM
  `bigquery-public-data.github_repos.commits`
  cross join  UNNEST(repo_name) as commit_repo_name
GROUP BY
  commit_repo_name


# into bq_projects_recall.csv
select
substr(repo_name, 0, strpos(repo_name,'/') -1) as org
, count(*) as projects
, sum(if(commits_2020 >= 50, 1,0)) as fit_projects
from
general.bq_repos
where
substr(repo_name, 0, strpos(repo_name,'/') -1) in ('apache', 'wikimedia', 'google', 'GNOME', 'tensorflow')
group by
org
order by
org
;

select
count(*) as projects
, sum(if(commits_2020 >= 50, 1,0)) as fit_projects
, sum(if(commits_2020 >= 50, 1,0))/count(*) as large_and_uptodate
from
general.bq_repos
;