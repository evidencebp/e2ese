# Compres test/validation/train files (in test/validation/train directories)
tar cvzf - test | split -b 40m - june_2021_java_file_content_test.csv.tar.gz
tar cvzf - validation | split -b 40m - june_2021_java_file_content_validation.csv.tar.gz
tar cvzf - train | split -b 40m - june_2021_java_file_content_train.csv.tar.gz

# Extract test/validation/train files
cat june_2021_java_file_content_test.csv.tar.gz.* | tar xzvf -
cat june_2021_java_file_content_validation.csv.tar.gz.* | tar xzvf -
cat june_2021_java_file_content_train.csv.tar.gz.* | tar xzvf -