# Commit management

## Checkout a specific commit

    git checkout <commit SHA>

For example:

```shell
git checkout b928950669f5da9414000de50c3a3ba7f7be7597
```

## Find the commits that are in a branch, but not in another one

Find the commit that are in `BRANCH1` but not in `BRANCH2`

```shell
BRANCH1="master"
BRANCH2="feature"

diff <(git log --pretty=format:"%h %ai <%an> %s" ${BRANCH1}) <(git log --pretty=format:"%h %ai <%an> %s" ${BRANCH2}) | grep '^<'    | sed 's|^< ||'
```

## Show what has been done to files on a specific commit

The command below only shows created/renamed/deleted files:

```shell
$ git show 3959352 --summary
commit 3959352cdef7d3b458c4278d859a79203f101e93
Author: Denis Beurivé <dbeurive@protonmail.com>
Date:   Fri May 28 17:57:27 2021 +0200

    The commit message.
    
    Ref: #123

 create mode 100644 __init__.py
 create mode 100644 file1.py
 create mode 100644 file2.py
 create mode 100644 file3.py
 rename postproc/{file4.py => file5.py} (57%)
 create mode 100644 file6.py
```

> The line `rename postproc/{file4.py => file5.py} (57%)` indicates that a file has been **split**. **You should be VERY careful**: you cannot rely on GIT to show you what changed between the two commits! You must look at the code very carefully.

The command below shows modified files between 2 commits:

```shell
git diff --name-only HEAD~6 HEAD~7
```

## Print all commits that modified a specific file

    git log --follow -- <file path>

    git log --follow --pretty=format:"%C(green)%h%C(Reset) %s" -- <file path>

    git log --follow --pretty=format:"%h %s" -- file.py | awk "{print \"HEAD~\" NR-1 \" \" \$s}"

You can also print the kind of modification that affected the file (use option `--name-status`):

    git log --follow --name-status --pretty=format:"%C(green)%h%C(Reset) %s" -- file.py

