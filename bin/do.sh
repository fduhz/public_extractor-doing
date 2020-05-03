#!/bin/bash

_dir_="$(cd `dirname $0` && pwd)"
_name_=`basename $0`

envfile="${_dir_}/setenv.sh"

# default setting
test -f "${envfile}" && 
    source "${envfile}"

# custom setting
test -f "${doing_extra_setting}" &&
    source "${doing_extra_setting}"

debug_output_env(){
if [ "${doing_debug}" == yes ]; then
    echo "[${_name_}|debugging]----------" 1>&2
    echo "doing_debug: ${doing_debug}" 1>&2
    echo "doing_for_pipe: ${doing_for_pipe}" 1>&2
    echo "pipe_content: ${pipe_content}" 1>&2
    echo "doing_extra_setting: ${doing_extra_setting}" 1>&2
    echo "[${_name_}|debugging]----------" 1>&2
fi
}

help(){
echo "
#################################
# extractor-doing
# version 0.0.1
# power by dovfz
#################################

usage for extractor-doing:
module/function:
- extract
- ...

#############################
# module/function: extract 
#############################
* if you enable doing_for_pipe=yes, all the input for doing is from pipe, 
for example:
    echo -e \"apple\norange\"| bin/do.sh extract

    cat article.txt| bin/do.sh extract

    cat << ! | bin/do.sh extract
    apple
    orange
    !

    ...

* if doing_for_pipe disable, then do.sh use variable as your input,
for example:
    article=\"The secret of change is to focus all of your energy, not on fighting the old, but on building the new,’ said ‘Socrates’. \"
    bin/do.sh \"\${article}\"

* if you need to use a file as your input in this case, you can use as below example,
    bin/do.sh \"\$(cat article.txt)\"

"
}




if [ "$#" -gt 0 ]; then
    debug_output_env
    calling_action="$1"
    shift 1
    if [ "${doing_for_pipe}" == 'yes' ]; then
        pipe_content="$(cat /dev/stdin)"
        echo "${pipe_content}" | ${_dir_}/../lib/${calling_action}.sh "$@"
    else
        ${_dir_}/../lib/${calling_action}.sh "$@"
    fi
else
    help
fi



