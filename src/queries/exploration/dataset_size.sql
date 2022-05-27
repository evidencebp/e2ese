select
r.language
, count(distinct cnt.repo_name) as projects
, count(distinct path) as files
from
general.contents_1_june_2021 as cnt
join
general.repos_split as r
on
cnt.repo_name = r.repo_name
join
general.language_extensions as l
on
r.language = l.language
and
cnt.extension = l.language_extension
where
oss_license_found
group by
r.language
order by
r.language
;

select
count(distinct repo_name) as projects
, count(distinct commit) as commits
, count(distinct author_email) as developers
, avg(if(is_cursing,1,0)) as is_cursing_ratio
, avg(if(is_negative_sentiment,1,0)) as is_negative_sentiment_ratio
from
general.enhanced_commits
;