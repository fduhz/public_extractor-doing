#!/bin/bash

# default setting for env variable

###################################
# setting for doing 
###################################
export doing_debug=yes
export doing_for_pipe=yes
#export doing_extra_setting=
# don't set doing_extra_setting be null in default setting file when you need to set it.

###################################
# setting for extract words 
###################################

#------------------------
# sort, group-by and counting
#------------------------
export extract_sort=asc
export extract_group_by=yes
# description: output distinct words list from your input content.

export extract_counting=yes
# description: output distinct words list within the words count in the input content when setting extract_group_by=yes
# note: if extract_group_by=no, this setting will be not effective.

export extract_sort_by_counting=desc
# description: sort the output word list by word counting
# note: if extract_group_by=no or extract_counting=no, this setting will be not effective.
#       when this setting enable will be cover "extract_sort=asc/desc"

#------------------------
# excluding and including for extract
#------------------------
export extract_excluding=yes

export extract_excluding_words_file=./excluding_words
# description: if extract_excluding_words_file be invalid, this is same to extract_excluding=no

export extract_including_number=yes
# description: if extract_including_number=yes, some words will be output when that include any number

export extract_including_pure_number=no
# description: output words include pure number in your input contents when you need to list that
# testcase:  cd ${doing_home_dir}; echo -e 'abc110\n110' | bin/do.sh extract

export extract_excluding_words_ignore_first_letter_case=yes
# description:  in case you need to excludeing some words in your specify word-file and ignore the case for each first letter of all the words in word-file, it's should use extract_excluding_words_ignore_first_letter_case=yes
# testcase: 
# cmd: cd ${doing_home_dir}; echo 'assa' | bin/do.sh extract   
# excluding_words: 
# - AssA 
# - assa

export extract_excluding_chinese_character=no
# description: when extract_excluding_chinese_character=yes, exclude the chinese charachers whitin the words list when it outputing.

#------------------------
# setting for ignore something
#------------------------
export extract_ignore_case=no
export extract_excluding_words_ignore_case=yes
export extract_ignore_first_letter_case=yes
export extract_excluding_words_ignorecase_file_location=/tmp
export extract_ignore_row_prefix='#'


