#!/bin/bash

_name_="$(basename $0)"

if [ "${doing_for_pipe}" == yes ]; then
    handle_text="$(cat /dev/stdin)"
else
    handle_text="$1"
fi

#result="$(echo "${handle_text}" | egrep -o '\S+'| egrep -v '(^-$)|(^\.$)|(^—$)'| sed 's/"//g')"

result="${handle_text}"

if [ "${doing_debug}" == yes ]; then
    echo "[${_name_}|debugging]----------" 1>&2
    echo "extract_sort: ${extract_sort}" 1>&2
    echo "handle_text: ${handle_text}" 1>&2
    echo "extract_group_by: ${extract_group_by}" 1>&2
    echo "extract_counting: ${extract_counting}" 1>&2
    echo "extract_excluding: ${extract_excluding}" 1>&2
    echo "extract_excluding_words_file: ${extract_excluding_words_file}" 1>&2
    echo "extract_sort_by_counting: ${extract_sort_by_counting}" 1>&2 
    echo "extract_including_number: ${extract_including_number}" 1>&2
    echo "extract_ignore_case: ${extract_ignore_case}" 1>&2
    echo "extract_excluding_words_ignore_case: ${extract_excluding_words_ignore_case}" 1>&2
    echo "extract_excluding_words_ignorecase_file_location: ${extract_excluding_words_ignorecase_file_location}" 1>&2
    echo "extract_ignore_row_prefix: ${extract_ignore_row_prefix}" 1>&2
    echo "extract_excluding_chinese_character: ${extract_excluding_chinese_character}" 1>&2
    echo "extract_ignore_first_letter_case: ${extract_ignore_first_letter_case}" 1>&2
    echo "extract_including_pure_number: ${extract_including_pure_number}" 1>&2
    echo "[${_name_}|debugging]----------" 1>&2
fi

if [ -n "${extract_ignore_row_prefix}" ]; then
    result="$(echo "${result}"| egrep -v "^${extract_ignore_row_prefix}")"
fi

if [ "${extract_ignore_case}" == yes ]; then
    result="$(echo "${result}"| tr 'A-Z' 'a-z')"

fi

# grammer filter
# remove 's
# for example
# echo "app's user-s use s a sss"|  sed -r  's/([^-a-zA-Z ])s//g' ==> app user-s use s a sss
result="$(echo "${result}"| sed -r 's/([^-a-zA-Z ])s//g')"
#echo "${result}" 1>&2


# split words
# v1
#result="$(echo "$result"| egrep -o '\w+(-\w+)*' )"
# v1.1 Compatible with "'t" "'ve" ending
result="$(echo "$result"| egrep -o "(\\w+(-\\w+)*)('t|'ve)?" )"



if [ "${extract_ignore_first_letter_case}" == yes ]; then
    # for example
    # echo -e "AVideo\nAVideo\nAvideo\nAvIdeo\nAvvvIdeO"| sed -r 's/^[A-Z][a-z]+$/\l&/g'
    result="$(echo "${result}"| sed -r "s/^[A-Z][a-z]+('\w+)?$/\l&/g")"
    # incorrect handle:
    #result="$(echo "${result}"| sed -r 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/')"
    #result="$(echo "${result}"| sed -r 'y/[A-Z]/[a-z]/')"
    #result="$(echo "${result}"| sed -r 's/^.*$/\l&/')"
    #result="${result,,}"
fi

if [ "${extract_excluding_chinese_character}" == yes ]; then
    #v1: result="$(echo "${result}"| egrep -o '([a-z]|[A-Z])+(-([a-z]+|[A-Z]+))*')"
    # v1.1 Compatible with "'t" "'ve" ending
    result="$(echo "${result}"| egrep -o "([a-z]|[A-Z])+(-([a-z]+|[A-Z]+))*('t|'ve)?")"
fi

#echo debugging ...
#echo "$result"|egrep -i 'don'
#echo debugging ...


case "${extract_sort}" in
    asc)
         result="$(echo "${result}"| sort)"
         ;;
    desc)
        result="$(echo "${result}"| sort -r)"
        ;;
esac

if [ "${extract_including_pure_number}" != yes ]; then
    result="$(echo "${result}"| egrep -v '^[0-9]+$')"
fi

if [ "${extract_including_number}" != yes ]; then
    result="$(echo "${result}"| egrep -v '[0-9]+')"
fi

if [ "${extract_excluding}" == yes ]; then
    if [ -f "${extract_excluding_words_file}" ]; then
        if [ "${extract_excluding_words_ignore_case}" == yes ]; then
            # set default location
            extract_excluding_words_file_dirname=$(dirname ${extract_excluding_words_file})
            # set custom location
            if [ -n "${extract_excluding_words_ignorecase_file_location}" ]; then
                mkdir -p "${extract_excluding_words_ignorecase_file_location}"
                if [ -d "${extract_excluding_words_ignorecase_file_location}" ]; then
                    extract_excluding_words_file_dirname="${extract_excluding_words_ignorecase_file_location}"
                fi
            fi
            extract_excluding_words_file_basename=$(basename ${extract_excluding_words_file})
            extract_excluding_words_ignorecase_file="${extract_excluding_words_file_dirname}/.ignorecase.${extract_excluding_words_file_basename}"
            cat ${extract_excluding_words_file}| tr 'A-Z' 'a-z' > "${extract_excluding_words_ignorecase_file}"
            test -f "${extract_excluding_words_ignorecase_file}" &&
                extract_excluding_words_file="${extract_excluding_words_ignorecase_file}"
        elif [ "${extract_excluding_words_ignore_first_letter_case}" == yes ]; then
            # set default location
            extract_excluding_words_file_dirname=$(dirname ${extract_excluding_words_file})
            # set custom location
            if [ -n "${extract_excluding_words_ignorecase_file_location}" ]; then
                mkdir -p "${extract_excluding_words_ignorecase_file_location}"
                if [ -d "${extract_excluding_words_ignorecase_file_location}" ]; then
                    extract_excluding_words_file_dirname="${extract_excluding_words_ignorecase_file_location}"
                fi
            fi
            extract_excluding_words_file_basename=$(basename ${extract_excluding_words_file})
            extract_excluding_words_ignorecase_file="${extract_excluding_words_file_dirname}/.ignorecase.${extract_excluding_words_file_basename}"
            cat ${extract_excluding_words_file}| sed -r 's/^[A-Z][a-z]+$/\l&/g' > "${extract_excluding_words_ignorecase_file}"
            test -f "${extract_excluding_words_ignorecase_file}" &&
                extract_excluding_words_file="${extract_excluding_words_ignorecase_file}"

        fi
        result="$(echo "${result}"| grep -wvFf "${extract_excluding_words_file}")"
    fi
fi

if [ "${extract_group_by}" == yes ]; then
    result="$(echo "${result}"| uniq -c| awk '($2 !~ /^$/){print $0}')"

    if [ "${extract_counting}" != yes ]; then
        result="$(echo "${result}"| awk '($2 !~ /^$/){print $2}')"
    fi
    case "${extract_sort_by_counting}" in 
        'asc')
            result="$(echo "${result}"|sort -nk1)"
            ;;
        'desc')
            result="$(echo "${result}"|sort -rnk1)"
            ;;
    esac
fi


echo "$result"





