# Branch management

## Create a repository on the GIT server (which may be localhost)

```shell
$ cd /opt/git
$ mkdir projet.git
$ cd projet.git
$ git --bare init
```

## Create a new branch

```shell
$ git checkout -b refactoring
Switched to a new branch 'refactoring'
```

```shell
$ git branch
  master
* refactoring
```

## Push a branch

### Secure

```shell
$ git push origin refactoring
```

### Unsecure

The following replaces the remote branch by the local one, **no matter the context**:

```shell
$ git push -f origin refactoring    
```

## Merge a branch

```shell
    $ git branch
      master
    * refactoring
```

```shell
    $ git checkout master
    Switched to branch 'master'
```

```shell
    $ git merge refactoring
```

```shell
    $ git push origin master
```

## Delete a local branch

### Secure

First, make sure that the branch has been merged:

```shell
git branch --merged
```

Then, you can delete it:

```shell
git branch -d refactoring
```

### Unsecure

The following command deletes the branch, **no matter its state**:

```shell
git branch -D refactoring
```

## Delete a remote branch

First, make sure that the remote branch has been merged:

```shell
git branch -r merged
```

Then, you can delete it:

```shell
git push origin --delete refactoring
```

## Force the update of the local branch from the remote one

The following command will force the update of the local branch `master`:

```shell
git checkout master
git fetch
git reset --hard origin/master
```

## Import the branch metadata only (do not merge)

For a single branch:

    git checkout <your branch>
    git fetch

For all branches:

```shell
git fetch --all
```

or, which is equivalent:

```shell
git remote update
```

**Note**:

Once the local repository has been updated/fetched, we can compare the local branch with the remote one:

    git diff <your branch> origin/<your branch>  # or: git diff main @{upstream}

## Override branches

### Override a REMOTE branch by LOCAL branch

Let's say that you want to _completely override_ the remote branch "`issue135`" by the local branch "`issue135-clean`".

```shell
$ git branch
* master
  issue135-clean
```

Checkout the branch "`issue135-clean`":

    $ git checkout issue135-clean

Rename the current branch (that is "`issue135-clean`") into "`issue135`":

```shell
$ git branch -m issue135
$ git branch
* issue135
  master
```

Then push (from now on) the branch "`issue135`":

```shell
git push -f origin issue135
```

> Please note the use of the option `-f` (force).

### Override a LOCAL branch by REMOTE branch

Let's say that you want to _completely override_ the local branch "`issue135`" by the remote branch "`issue135`".

```shell
$ git branch
* issue135
  master

$ git fetch --all

$ git reset --hard origin/issue135
```

> **WARINING**: all modifications made on the local branch will be lost!

# "origin" vs "upstream"

![](images/origin-vs-upstream.png)

From this [excellent explenation](https://stackoverflow.com/questions/9257533/what-is-the-difference-between-origin-and-upstream-on-github):

The difference between `upstream` and `origin` should be understood in the context of GitHub forks
(where you fork a GitHub repository on GitHub before cloning that fork locally).

* `upstream` generally refers to the original repository that you have forked.
* `origin` is your fork: your own repository on GitHub, clone of the original repository of GitHub.

> Please note that these names are conventions, simple alias. You can use other names as long as you know what they mean.

Print your configuration:

```shell
$ git config --get-regexp remote.origin.*
remote.origin.url https://...
remote.origin.fetch +refs/heads/*:refs/remotes/origin/*

$ git config --get-regexp remote.upstream.*
remote.upstream.url https://...
remote.upstream.fetch +refs/heads/*:refs/remotes/upstream/*
```

Delete a configuration:

```shell
git config --unset remote.origin.url
git config --unset remote.origin.fetch
git config --get-regexp remote.origin.*

git config --unset remote.upstream.url
git config --unset remote.upstream.fetch
git config --get-regexp remote.upstream.*
```

Set a configuration:

```shell
ORIGIN_URL=https://your.origin.repository.url
git remote add origin ${ORIGIN_URL}
git config --get-regexp remote.origin.*

UPSTREAM_URL=https://your.upstream.repository.url
git remote add upstream ${UPSTREAM_URL}
git config --get-regexp remote.upstream.*
```

**Quick note: synchronising local/remote repositories**

If you want to update you local branch from "upstream" (the _official project repository_ that you forked):

```shell
BRANCH="master"
git checkout "${BRANCH}"
git fetch upstream
git pull --rebase upstream "${BRANCH}"
```

or (quick _copy/paste_):

```shell
BRANCH="master"
git checkout "${BRANCH}" && git fetch upstream && git pull --rebase upstream "${BRANCH}" && echo "SUCCESS"
```

> You may specify another option than `--rebase` (`--no-rebase` or `--ff-only`).

> You can also override your local branch: `git reset --hard upstream/master` (see [here](https://stackoverflow.com/questions/15432052/what-is-the-meaning-of-git-reset-hard-origin-master/15432250))

Now, you can push the downloaded modifications to your distant forked repository:

```shell
BRANCH="master"
git push origin "${BRANCH}"
```

Now, your _forked project repository_ is synchronized with the _official project repository_.

All in one command:

```shell
BRANCH="master";
git checkout "${BRANCH}" && git fetch upstream && git pull --rebase upstream "${BRANCH}" && git push origin "${BRANCH}" && echo "SUCCESS"
```

## What is the default branch ?

```shell
origin=$(git config --get remote.origin.url)
git remote show "${origin}" | sed -n '/HEAD/s/.*: //p'
```


## Pick a file from another branch

```shell
git checkout <branch name> -- <file name>
```

## Compare a file within 2 branches

    git diff <branch1> <branch2> -- <file path>

or, using a specific diff visualizer:

    git difftool -y --tool=meld <branch1> <branch2> -- <file path>

## Show files that are on another branch

    git ls-tree -r --name-only <branch name> [<path to directory>]

> See [git ls-tree](https://git-scm.com/docs/git-ls-tree)

## Print only the name of the current branch

```shell
git branch --show-current
```

## Create a new branch from a branch that has uncommitted changes

You are on a branch. You made a lot of modifications. And you want to create a new branch that is the _exact_ copy of the current branch, including the uncommitted changes. 

    git switch -c <new branch>

> See [Git: Create a branch from unstaged/uncommitted changes on master](https://stackoverflow.com/questions/2569459/git-create-a-branch-from-unstaged-uncommitted-changes-on-master)


