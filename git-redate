#!/bin/bash

is_git_repo() {
    git rev-parse --show-toplevel > /dev/null 2>&1
    result=$?
    if test $result != 0; then
        >&2 echo 'Not a git repo!'
        exit $result
  fi
}

is_git_repo

make_editor_choice() {

    echo "Which editor do you want to use for this repo?\n";
    echo "1. VI\n";
    echo "2. NANO\n";
    echo "3. Your own\n"
    echo "You Choose: ";

    read CHOOSE_EDITOR
}

get_editor_executable() {

    echo "What is the path to your prefered test editor?\n";
    read EDITOR_PATH
}


is_has_editor() {
    SETTINGS_FILE="~/.redate-settings";
    if [ -f "$SETTINGS_FILE" ]
    then
        OUR_EDITOR=$(cat ${SETTINGS_FILE});
    elif [ ! -z "$EDITOR" ]
    then
	OUR_EDITOR="$EDITOR";
    else
        make_editor_choice;
        if [ ${CHOOSE_EDITOR} == 3 ] || [ ${CHOOSE_EDITOR} == "3" ]; then
            get_editor_executable
            OUR_EDITOR=${EDITOR_PATH}
        elif [ ${CHOOSE_EDITOR} == 1 ] || [ ${CHOOSE_EDITOR} == "1" ]; then
            OUR_EDITOR="vi";
        else
            OUR_EDITOR="nano";
        fi
        echo ${OUR_EDITOR} > ${SETTINGS_FILE}
    fi
}

is_has_editor


ALL=0
DEBUG=0
LIMITCHUNKS=20

while [[ $# -ge 1 ]]
do
key="$1"

case $key in
    -c| --commits)
    COMMITS="$2"
    if [ -z "${COMMITS}" ]; then COMMITS="5"; fi;
    shift
    ;;
    -l| --limit)
    LIMITCHUNKS="$2"
    if [ -z "${LIMITCHUNKS}" ]; then LIMITCHUNKS="20"; fi;
    shift
    ;;
    -d| --debug)
    DEBUG=1
    shift
    ;;
    -a| --all)
    ALL=1
    shift
    ;;
    *)
    # unknown option
    ;;
esac
shift
done

die () {
    echo >&2 `basename $0`: $*
    exit 1
}

tmpfile=$(mktemp gitblah-XXXX)
[ -f "$tmpfile" ] || die "could not get tmpfile=[$tmpfile]"
trap "rm -f $tmpfile" EXIT


datefmt=%cI
if [ "`git log -n1  --pretty=format:"$datefmt"`" == "$datefmt" ];
then
    datefmt=%ci
fi

if [ "${ALL}" -eq 1 ];
then
    git log --pretty=format:"$datefmt | %H | %s" > $tmpfile;
else
    if [ -n "${COMMITS+set}" ];
    then git log -n ${COMMITS} --pretty=format:"$datefmt | %H | %s" > $tmpfile;
    else git log -n 5 --pretty=format:"$datefmt | %H | %s" > $tmpfile;
    fi
fi

${VISUAL:-${EDITOR:-${OUR_EDITOR}}} $tmpfile


ITER=0
COLITER=0
declare -a COLLECTION

COUNTCOMMITS=$(awk 'END {print NR}' $tmpfile)

while read commit || [ -n "$commit" ]; do

    IFS="|" read date hash message <<< "$commit"
    shopt -s nocasematch
    if [[ "$date" == 'now' ]]; then
        date=$(date +%Y-%m-%dT%H:%M:%S%z);
    fi
    shopt -u nocasematch
    if [ "$datefmt" == "%cI" ]
    then
        DATE_NO_SPACE="$(echo "${date}" | tr -d '[[:space:]]')"
    else
        DATE_NO_SPACE="$(echo "${date}")"
    fi


    COMMIT_ENV=$(cat <<-END
if [ \$GIT_COMMIT = $hash ];
then
    export GIT_AUTHOR_DATE="$DATE_NO_SPACE"
    export GIT_COMMITTER_DATE="$DATE_NO_SPACE";
fi;
END
)

    ((ITER++))

    if [ "${DEBUG}" -eq 1 ] && [ $((ITER % LIMITCHUNKS)) == $((LIMITCHUNKS - 1)) ];
    then
        echo "Chunk $COLITER Finished"
    fi

    if [ $((ITER % LIMITCHUNKS)) == 0 ]
    then
        ((COLITER++))

        if [ "${DEBUG}" -eq 1 ];
        then
            echo "Chunk $COLITER Started"
        fi

    fi

    COLLECTION[$COLITER]=${COLLECTION[COLITER]}"$COMMIT_ENV"
    if [ "${DEBUG}" -eq 1 ]
    then
        echo "Commit $ITER/$COUNTCOMMITS Collected"
    fi

done < $tmpfile

ITERATOR=0
for each in "${COLLECTION[@]}"
do

    ((ITERATOR++))

    if [ "${ALL}" -eq 1 ];
    then
        if [ "${DEBUG}" -eq 1 ];
        then
            echo "Chunk $ITERATOR/"${#COLLECTION[@]}" Started"
            git filter-branch -f --env-filter "$each" -- --all
            echo "Chunk $ITERATOR/"${#COLLECTION[@]}" Finished"
        else
            git filter-branch -f --env-filter "$each" -- --all >/dev/null
        fi
    else
        if [ "${DEBUG}" -eq 1 ];
        then
            echo "Chunk $ITERATOR/"${#COLLECTION[@]}" Started"
            git filter-branch -f --env-filter "$each" HEAD~${COMMITS}..HEAD
            echo "Chunk $ITERATOR/"${#COLLECTION[@]}" Finished"
        else
            git filter-branch -f --env-filter "$each" HEAD~${COMMITS}..HEAD >/dev/null
        fi
    fi
done

if [ $? = 0 ] ; then
    echo "Git commit dates updated. Run 'git push -f BRANCH_NAME' to push your changes."
else
    echo "Git redate failed. Please make sure you run this on a clean working directory."
fi
