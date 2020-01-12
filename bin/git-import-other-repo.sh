#!/bin/sh


#usage:
# first cd to repo where to import to, then:
# $ sh git-import-repo.sh other/repo/to/import

# undo with $ git reset --hard origin/master (assuming no local changes)

die() 
{ 
    echo "E: $@" 1>&2; 
    exit 1
}


import_repo()
{
    local REPO_PATH="$1"
    if [ ! -d "$REPO_PATH" ]; then
       die "bad path"
    fi

    local REPO_NAME="$2"
    if [ -z "$REPO_NAME" ] ; then
        REPO_NAME=$(basename $REPO_PATH)
    fi
        
    if [ -e "./$REPO_NAME" ] ; then
        die "path $REPO_NAME already exists in curren dir"
    fi

    # use current branch
    REPO_URL="$(cd $REPO_PATH && git remote get-url origin)"
    REPO_BRANCH="$(cd $REPO_PATH && git symbolic-ref --short -q HEAD)"
    if [ -z "$REPO_BRANCH" ] ; then
        die "head detatched or provided path is not a git repo"
    fi

    echo "importing '$REPO_PATH' (current branch:$REPO_BRANCH) as '$REPO_NAME'"
    #exit 0

    # kudos: stackoverflow.com/questions/1425892/
    #git remote add $REPO_NAME $REPO_PATH
    #git fetch $REPO_NAME --tags
    #git merge --allow-unrelated-histories $REPO_NAME/$REPO_BRANCH
    #git remote remove $REPO_NAME

    git remote add -f $REPO_NAME $REPO_PATH
    git merge \
        -s ours \
        --allow-unrelated-histories \
        --no-commit $REPO_NAME/$REPO_BRANCH

    git read-tree --prefix=$REPO_NAME/ -u $REPO_NAME/$REPO_BRANCH 
    git commit -m "Merged/imported repo $REPO_NAME/$REPO_BRANCH \n\n($REPO_URL)"
    git pull -s subtree $REPO_NAME master
}


import_repo "$@"
