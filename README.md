# e2ese

The goal of this repository is to enable End to End Software Engineering research.
It started in the source code as input and provide multiple process metrics that can be used as concepts in supervised learning.

While pridcitve models have value, we would like to take a step further and look for causal relations.
For that we provide the source code in different dates.
That enables using co-change analysis in order to identify likely causal relations.
The source code also provides intervention points, were one can use the classical experimental methodology.

This repository contains the source code needed for the generation and some auxaliry data.

The main data is in different repositories since their volum is very large the sturcture is rather similar.
The first batch of 1.8 million Java files from June 2021 is [here](https://github.com/evidencebp/e2ese-dataset)

# External e2ese data sets structure

The samples are splited into train, validation and test files.
Splits are done with psuedo random function to ease reproducability and being backward and forward compatible.

The first split is by the code repository.
This are split and appear in different directories in zipped files.
Inside each file, the samples (which are files in the subject repository) are also bing split into train, validation and test.

Notet the samples of the different splits should have similar properties.
However, when spliting by repository, the repositories are different and do not have to have similar properties.
This split is suitable for investigating domain adaptation.

If you publish results, please provide that on the test set so it will be camparable to others.
In case that the volum of the train set is too higj, you can use the validation set instead.

file_labels contains the process metrics for each file.
Note that there are many metrics so the data set can be used for many tasks.

The program_repair file contains files modified once in the observed period.
That make them suiable for program repair (as a bug fix or a refactor).


