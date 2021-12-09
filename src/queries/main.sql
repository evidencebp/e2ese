# This scripts document the actions needed to build the data set

# Build the infrastructure using https://github.com/evidencebp/general

# Follow instructions using the specific language directory


#### Per language
# Modify and run lang/prepare_source_extraction.sql

# Run generate_dataset.sql

# export data set (source code)


### Before file properties

# Modify and run prepare_before_extraction.sql

# Run file_properties_on_relevant.sql

# Run commit_file_prev_touch.sql

# Run lang/extract_previous_file_properties.sql

# export previous_file_properties


### After file properties

# Run prepare_after_extraction.sql

# Run file_properties_on_relevant.sql

# Run commit_file_prev_touch.sql

# Run lang/extract_after_file_properties.sql

# Run generate_labels.sql

# export generate_labels

# Run generate_commits_dataset.sql

# Run extract_after_commits.sql

# export commits



# Run program_repair.sql

# export program_repair

# Run generate_difficulty_pairs.sql

# export difficulty_pairs

# Run prepare_code_similarity.sql
# Run generate_code_similarity_dataset.sql

# export code_similarity

# Run cleanup.sql
