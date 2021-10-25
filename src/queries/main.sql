# This scripts document the actions needed to build the data set

# Build the infrastructure using https://github.com/evidencebp/general

# Follow instructions using the specific language directory


#### Per language
# Modify and run prepare_source_extraction.sql

# Run lang/prepare_source_extraction.sql

# Run generate_dataset.sql

# Modify and run prepare_before_extraction.sql

# Run file_properties_on_relevant.sql

# Run commit_file_prev_touch.sql

# Run extract_previous_file_properties.sql

# Run lang/prepare_after_extraction.sql

# Run file_properties_on_relevant.sql

# Run commit_file_prev_touch.sql

# Run lang/extract_after_file_properties.sql

# Run generate_commits_dataset.sql

# Run extract_after_commits.sql

# Run generate_labels.sql



# Run program_repair.sql

# Run generate_difficulty_pairs.sql

# Run lang/prepare_code_similarity.sql
# Run generate_code_similarity_dataset.sql

# Run cleanup.sql
