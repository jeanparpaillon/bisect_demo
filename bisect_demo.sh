#!/bin/bash

set -e

basedir=$(cd $(dirname $0) && pwd)
script=$(basename $0)
testscript=$basedir/test.sh
default_n=100

function usage {
    echo "Usage: $script dir [N]"
    echo "    dir: base dir where to create git repos"
    echo "    N: number of commits (default: ${default_n})"
}

git_v=$(git --version | awk '{print $3}')
git_major_v=$(echo $git_v | awk -F '.' '{print $1}')
git_minor_v=$(echo $git_v | awk -F '.' '{print $2}')

if test $git_major_v -lt 2; then
    echo "E: git $git_v detected. git 2.0 at least is required."
    exit 1
fi

n=${default_n}
if test $# -lt 1; then
    usage
    exit 1
else
    repodir=$1
    if test $# -gt 1; then
	n=$2
    fi
fi

echo "I: Running $script with $n commits"

# Init repo
mkdir -p $repodir
tmpdir=$(mktemp --directory --tmpdir=$repodir)
git="git -C $tmpdir"

echo "I: Init repository in $tmpdir"

$git init > /dev/null
echo > $tmpdir/v
echo 1 > $tmpdir/test
$git add v test
$git commit -m "Initial commit" > /dev/null
initial=$($git describe --always)

# Commit, commit, commit...
i=0
err=$(( $RANDOM % $n ))
while test $i -lt $n; do
    echo -en "\033[2K\r"
    echo -en "I: Commit #"$i
    msg="Commit #"$i
    # Introduce a change for commit
    echo $i > $tmpdir/v
    if test $i -eq $err; then
	# Introduce error
	echo 0 > $tmpdir/test
	$git add test
	msg="$msg (error)"
    fi
    $git commit --all --message="$msg" > /dev/null
    i=$(( $i + 1 ))
done
echo

# Get the error
$git bisect start
$git bisect bad
$git bisect good $initial
$git bisect run $testscript
