# Compres test/validation/train files (in compress directory)
tar cvzf - compress | split -b 40m - october_2021_javascript_file_content_train.csv.tar.gz
tar cvzf - compress | split -b 40m - october_2021_javascript_file_content_validation.csv.tar.gz
tar cvzf - compress | split -b 40m - october_2021_javascript_file_content_test.csv.tar.gz

tar cvzf - compress | split -b 40m - previous_file_properties.csv.tar.gz
tar cvzf - compress | split -b 40m - after_file_properties.csv.tar.gz
tar cvzf - compress | split -b 40m - code_similarity.csv.tar.gz

# Extract test/validation/train files
cat october_2021_javascript_file_content_train.csv.tar.gz.* | tar xzvf -
cat october_2021_javascript_file_content_validation.csv.tar.gz.* | tar xzvf -
cat october_2021_javascript_file_content_test.csv.tar.gz.* | tar xzvf -

tar previous_file_properties.csv.tar.gz.* | tar xzvf -
tar after_file_properties.csv.tar.gz.* | tar xzvf -
tar code_similarity.csv.tar.gz.* | tar xzvf -
