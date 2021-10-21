# Source tables
drop table if exists general.october_2021_c_file_content;
drop table if exists general.october_2021_c_file_content_train;
drop table if exists general.october_2021_c_file_content_validation;
drop table if exists general.october_2021_c_file_content_test;

# Relevant auxiliary tables
drop table if exists general.relevant_repos;
drop table if exists general.relevant_enhanced_commits;
drop table if exists general.relevant_commits_files;

# File properties
drop table if exists general.relevant_file_properties;
drop table if exists general.previous_file_properties;
drop table if exists general.after_file_properties;
drop table if exists general.file_labels;

drop table if exists general.program_repair;

drop table if exists general.difficulty_pairs_by_ccp;
drop table if exists general.difficulty_pairs_by_tenure;

# Code similarity
drop view if exists general.contents_prev_content;
drop view if exists general.contents_cur_content;
drop table if exists general.code_similarity;
drop table if exists general.contents_diff;
drop table if exists general.contents_diff_test;
drop table if exists general.contents_diff_validation;
drop table if exists general.contents_diff_train;


