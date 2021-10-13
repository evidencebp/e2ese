# Compres test/validation/train files (in test/validation/train directories)
tar cvzf - train | split -b 40m - october_2021_python_file_content_train.csv.tar.gz
tar cvzf - validation | split -b 40m - october_2021_python_file_content_validation.csv.tar.gz
tar cvzf - test | split -b 40m - october_2021_python_file_content_test.csv.tar.gz

# Extract test/validation/train files
cat october_2021_python_file_content_train.csv.tar.gz.* | tar xzvf -
cat october_2021_python_file_content_validation.csv.tar.gz.* | tar xzvf -
cat october_2021_python_file_content_test.csv.tar.gz.* | tar xzvf -
