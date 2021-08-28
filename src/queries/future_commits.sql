select
count(*)
, sum(if(commit_timestamp> current_timestamp(),1,0)) as future_commits
, sum(if( commit_timestamp> current_timestamp(),1,0))/count(*) as future_commits_ratio
from
general.enhanced_commits
;