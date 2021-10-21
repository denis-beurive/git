# Configuring SSH for two GitHub users

Let's say that you have two GitHub accounts configured using the following parameters:

Your first GitHub account:

* Your login: `your-login-1`
* Your email address: `your-login-1@domain.com`
* Your private SSH key stored in the file `~/.ssh/ssh_github-1`.

Your second GitHub account:

* Your login: `your-login-2`
* Your email address: `your-login-2@domain.com`
* Your private SSH key stored in the file `~/.ssh/ssh_github-2`.

When accessing GitHub, you want the SSH client (launched behind the scenes by the GIT client) to perform the following actions:

* use the private key that is associated to the public key you downloaded to your GitHub account.
* use your GitHub login.

## Configuration

One way to do that is to associate a couple `(private key, login)` to an alias. This behaviour is configured in the SSH configuration file `~/.ssh`. For example:

    host personal.github.com
         HostName github.com
         User your-login-1
         PreferredAuthentications publickey
         IdentityFile ~/.ssh/ssh_github-1
         IdentitiesOnly yes

    host profesional.github.com
         HostName github.com
         User your-login-2
         PreferredAuthentications publickey
         IdentityFile ~/.ssh/ssh_github-2
         IdentitiesOnly yes


This way, when the SSH client opens a connexion to the host `github.com`, using the alias `personal.github.com`, it uses the login (`your-login-1`) and the SSH key (`~/.ssh/ssh_github-1`).

## Testing

Run the command below:

```shell
$ ssh -T git@personal.github.com
Hi your-login-1! You've successfully authenticated, but GitHub does not provide shell access.
```

```shell
$ ssh -T git@profesional.github.com
Hi your-login-2! You've successfully authenticated, but GitHub does not provide shell access.
```

> If you need to check the repository configuration: `git config -l`

## SSH troubleshouting

Here are some useful commands.

Check the fingerprint of an SSH key:

```shell
$ sh-keygen -l -E sha256 -f $SSH_KEY_FILE
```

> You can make sure that the private SSH you have matches to the public key you uploaded on GitHub.

Load the private keys into the SSH user agent:

    $ ssh-add
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    Permissions 0644 for '/home/denis/.ssh/id_rsa' are too open.
    It is required that your private key files are NOT accessible by others.
    This private key will be ignored.

> If you get this error message, then you know that the permissions for the directory `.ssh` are not valid. You must have `-rw-------` for all files within the `.ssh` directory. And, for the `.ssh` directory, the permissions must be `drwx------`.

Print the list of loaded private keys:

    $ ssh-add -l

# Configuring a repository

```shell
$ git remote add origin git@personal.github.com:your-login-1/your-repository.git
$ git config user.email "your-login-1@domain.com"
```

or:

```shell
$ git remote add origin git@profesional.github.com:your-login-2/your-repository.git
$ git config user.email "your-login-2@domain.com"
```

To see the configuration:

```shell
$ git config --list
$ git config --get-all user.email
$ git config --get-all remote.origin.url
```

Il you need to unset/remove a configuration paramter:

```shell
$ git config --unset user.email your-login-1@domain.com
$ git remote rm origin
```

If you need to change the origin URL:

```shell
$ git remote set-url origin git@personal.github.com:your-login-1/your-repository.git
```

> This command may be useful depending on your GitHub account settings.

# Troubleshooting

## Activate the debug output

If you have a problem while performing a GIT command, you can try this commands:

```shell
$ GIT_TRACE=2 git push --verbose -u origin master
```

Or, even better:

```shell
$ GIT_CURL_VERBOSE=1 GIT_TRACE=1 git push -u origin master
```

## Did you get this error ? "error: failed to push some refs to..."

You probably need to commit something.

## Wrong GIT user

If you have more than 1 GitHub account, then you may have trouble with GIT users. If so, the try this solution:

```shell
git init
git config user.name "<the user you want to use>"
git config user.email "<the user's email>"
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin <project GIT URI>
git config --local credential.helper ""
git push -u origin main
```

Please note that the important points are:

* `git config user.name...` and `git config user.email...`
* `git config --local credential.helper ""`

# Useful commands

## Use of --procelain

### Add all modified files to the staging area

```shell
git status --porcelain | egrep '^ M ' | sed --expression='s/^ M //' | xargs -n1 git add
```

> Same as `git add --all`

### Commit all staged files

```shell
git status --porcelain | egrep '^M  ' | sed --expression='s/^M  //' |  xargs -n1 git commit -m "Your message"
```

> Will generate as many commits as files (this is not equivalent to a single `git commit`).

### Commit all the modification at once

```shell
git status --porcelain | perl -e '@lines = (); while (<STDIN>) { chomp; $_ =~ s/^ *(M|A|D|R|C|U) //; push(@lines, $_); } print join(" ", @lines);' | xargs git add
```

```shell
git status --porcelain | perl -e '@lines = (); while (<STDIN>) { chomp; unless($_ =~ m/^ *M /) { next; }; $_ =~ s/^ *M //; push(@lines, $_); } print join(" ", @lines);' | xargs git add
```

```shell
git status --porcelain | perl -e '@lines = (); while (<STDIN>) { chomp; unless($_ =~ m/^ *D /) { next; }; $_ =~ s/^ *D //; push(@lines, $_); } print join(" ", @lines);' > delete.sh
```

## Make an initial empty commit

```shell
git commit --allow-empty -m "initial commit"
```

> Please note:
>
> Git represents branches as pointers to the latest commit in that branch. If you haven't created a commit yet, there's nothing for that branch to point to. So you can't really create branches until you have at least one commit [source](https://stackoverflow.com/questions/5678699/creating-branches-on-an-empty-project-in-git/5678812).

## Inject the modifications into the repository

```shell
git push -u origin master
```

## Change the case

```shell
git mv foldername tempname && git mv tempname folderName
git mv Entrypoints tempname && git mv tempname EntryPoints
```

## Print the LOG (print commits)

### For the current branch

```shell
git log --pretty="%h %an %ae"
```

Add color and filter on commits author:

```shell
git log --stat --pretty=format:"%C(#ff69b4)#####> %h - %an, %ar :%C(reset)%n%n%C(#FFFF00)%s%c(Reset)%n%n%b" --author="Denis BEURIVE"
```

> Please note that you may need to use `git fetch` first.

Add the file(s) associated with the commits (add option `--name-only`):

```shell
git log --pretty=format:"%C(green)%h%C(Reset) %s" --name-only
```

Add the names of the commits authors (add "`%an`"):

```shell
git log --pretty=format:"%C(green)%h%C(Reset) %C(red)%an%C(Reset) %s%n%aD" --name-only
```

This command may be useful to compare commits histories between branches:

```shell
git log  --pretty=format:"%C(green)%h%C(Reset) %ai <%an> %s" | head -n 20 | less --chop-long-lines
```

> You have:
> * the commit (sha) tag.
> * the date.
> * the author.
> * the message.
> * terminal word wrap is disabled.

This command add numerotation:

```shell
git log --pretty=format:"%h %s" | awk '{print "HEAD~" NR " " $s}'
```

Example:

```shell
$ git log --pretty=format:"%h %s" | awk '{print "HEAD~" NR " " $s}' | head -n 4
HEAD~1 697c643 message1
HEAD~2 85fe2df message2
HEAD~3 4e3b991 message3
HEAD~4 0386a8f message4
```

Show history by author (use the option `--author=<author name>`):

```shell
git log --author=Denis --pretty=format:"%h %s"  
```

> See [this link](https://stackoverflow.com/questions/4259996/how-can-i-view-a-git-log-of-just-one-users-commits) for details.

### For another branch

Just specify the name of the branch:

```shell
git log --pretty=format:"%ct %h %s" feature
```

### For a set of branches

Just specify the names of the branches:

```shell
$ git log --pretty=format:"%ct %h %s" feature master
1622741213 2778ac8 3. edit from master
1622741170 a38453b 2. edit from feature
1622741110 a53d88c 1. edit from master
1622741055 bfb5b09 initial commit
```

> The cool thing is that the commits are chronologically sorted.

## Print the changed applied to a specific commit

```shell
$ git diff <commit SHA>
```

> Please note that you may need to use `git fetch` first.

## Print the remote configuration

```shell
git remote -v
```

If you need to remove a remote:

    git remote rm <name of the remote> # For example git remote rm origin

## Tags

If you need to tag:

```shell
git tag -a 1.0.0 -m "First version"
git push origin --tags
```

If you need to delete the tag:

```shell
git tag -d 1.0.0
git push origin :refs/tags/1.0.0
```

Check the tags on the remote:

```shell
git ls-remote --tags
```

## Remove a file from the (remote) repository

The command below removes files on the (remote) repository only.
It does not remove the file from the local filesystem.

```shell
git rm --cached /path/to/the/file 
git commit -m "remove /path/to/the/file"
git push -u origin master
```

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

## Save authentication parameters

```shell
git config credential.helper store
```

or:

```shell
git config --global credential.helper store
```

For a session only:

```shell
git config --global credential.helper cache
```

## Force the update of the local branch from the remote one

The following command will force the update of the local branch `master`:

```shell
git checkout master
git fetch
git reset --hard origin/master
```

## Check a .gitignore file

Assuming that you have the following `.gitignore` file:

    .gradle/
    build/
    libs/
    .idea/
    lib/

Then, you can make sure that a particular entry (file or directory) is ignored:

```shell
$ git check-ignore -v */lib
.gitignore:5:lib/   app-cbc-des/lib
.gitignore:5:lib/   app-cfb-des/lib
```

## Global .gitignore

You can create a `.gitignore` file that will apply for all your projects:

```shell
git config --global core.excludesFile ~/.gitignore
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

## Print details about a specific commit

    git show <commit SHA>

Example:

```shell
$ git log --pretty=format:"%C(green)%h%C(Reset) %s"
8699120 Edit file2 for the first time
faf7388 Create file2. This message has been modified.
50659dc Create file1. This message has been modified.
9fb518b first commit

$ git show faf7388
commit faf7388eec0e94f601a2af506dfea81ca60c31e4
Author: Denis BEURIVE <dbeurive@protonmail.com>
Date:   Thu May 6 11:46:00 2021 +0200

    Create file2. This message has been modified.

diff --git a/file2 b/file2
new file mode 100644
index 0000000..e69de29
```

If you are just interested by the files associated with a commit:

    git show --pretty="" --name-only <commit SHA>
 
If you need to show the last commit:

```shell
git show HEAD
```

## Checkout a specific commit

    git checkout <commit SHA>

For example:

```shell
git checkout b928950669f5da9414000de50c3a3ba7f7be7597
```

## Set specific editor for interactive oprations

for version 3 of Sublime Text:

```shell
git config --global core.editor "/home/denis/Documents/softwares/sublime_text_3/sublime_text -n -w"
```

Or, for version 4 of Sublime Text:

```shell
git config --global core.editor "/usr/bin/subl -n -w"
```

> Source: [Git Tips #2 - Change editor for interactive Git rebase](https://www.kevinkuszyk.com/2016/03/08/git-tips-2-change-editor-for-interactive-git-rebase/)

## Test if a local repository is up to data

```shell
git fetch --dry-run
```

> Git "fetch" Downloads commits, objects and refs from another repository. It fetches branches and tags from one or more repositories. 

## Changing history

### Change commits messages (reword)

Let's say that we have this history:

```shell
$ git log --pretty=format:"%h %s" | awk '{print "HEAD~" NR-1 " " $s}'
HEAD~0 8ddbc63 Add new doc
HEAD~1 2f8b16c Add doc
HEAD~2 609ad8a generate conflicts with feature
HEAD~3 c39b623 This is the new message.
HEAD~4 6ff4a8f first import
HEAD~5 14bd895 initial commit
```

We want to modify the following commit messages: `2f8b16c` (`HEAD~1`) and `c39b623` (`HEAD~3`).

Type the following command:

```shell
git rebase --interactive HEAD~4
```

> Please note:
>
> * we use `HEAD~4` (and not `HEAD~3`).
> * a all commits you want to edit **must have a parent commit**. This means that, in our example, the commit `14bd895` cannot be edited.

GIT will open the editor you configured and ask you to modify the printed text. For example:

    pick c39b623 This is the new message.
    pick 609ad8a generate conflicts with feature
    pick 2f8b16c Add doc
    pick 8ddbc63 Add new doc

    # Rebasage de 6ff4a8f..8ddbc63 sur 8ddbc63 (4 commandes)
    #
    # Commandes :
    #  p, pick <commit> = utiliser le commit
    #  r, reword <commit> = utiliser le commit, mais reformuler son message
    #  e, edit <commit> = utiliser le commit, mais s'arrêter pour le modifier

Then for `c39b623` and `2f8b16c`, change "`pick`" to "`reword`". That is:

    reword c39b623 This is the new message.
    pick 609ad8a generate conflicts with feature
    reword 2f8b16c Add doc
    pick 8ddbc63 Add new doc

Close the editor and follow the instructions...

At the end:

```shell
$ git log --pretty=format:"%h %s" | awk '{print "HEAD~" NR-1 " " $s}'
HEAD~0 2e1b9ed Add new doc
HEAD~1 686a257 Add doc. Mes message for 6ff4a8f.
HEAD~2 29519fe generate conflicts with feature
HEAD~3 fb3f4ba This is the new message. New message for 6ff4a8f.
HEAD~4 6ff4a8f first import
HEAD~5 14bd895 initial commit
```

> Please note that the commits SHA have been modified.

### Change commits "content" (and messages) (edit)

Please note that by "content" we mean "what has been done in the source code".

Let's say that we have this history:

```shell
$ git log --pretty=format:"%h %s" | awk '{print "HEAD~" NR-1 " " $s}'
HEAD~0 5f8bfa4 Add new doc
HEAD~1 5b8fa8f Add doc
HEAD~2 ade9bf4 generate conflicts with feature
HEAD~3 6ff4a8f first import
HEAD~4 14bd895 initial commit
```

We want to modify the following commits: `5b8fa8f` (`HEAD~1`) and `6ff4a8f` (`HEAD~3`).

Type the following command:

    git rebase --interactive HEAD~4

> Please note:
>
> * we use `HEAD~4` (and not `HEAD~3`).
> * a all commits you want to edit **must have a parent commit**. This means that, in our example, the commit `14bd895` cannot be edited.

GIT will open the editor you configured and ask you to modify the printed text. For example:

    pick 6ff4a8f first import
    pick ade9bf4 generate conflicts with feature
    pick 5b8fa8f Add doc
    pick 5f8bfa4 Add new doc

    # Rebasage de 14bd895..5f8bfa4 sur 5f8bfa4 (4 commandes)
    #
    # Commandes :
    #  p, pick <commit> = utiliser le commit
    #  r, reword <commit> = utiliser le commit, mais reformuler son message
    #  e, edit <commit> = utiliser le commit, mais s'arrêter pour le modifier

Replace `pick` by `edit` on the lines that contains the IDs `6ff4a8f` and `5b8fa8f`.

    edit 6ff4a8f first import
    pick ade9bf4 generate conflicts with feature
    edit 5b8fa8f Add doc
    pick 5f8bfa4 Add new doc

Then close the editor.

Modify the code.

When you've done, then commit the modifications.

Please note that you can change the commit message or not:

* If you don't want to change the commit message, use the following commands: `git commit --all --amend --no-edit`.
* If you want to change the commit message, use the following command: `git commit --all`.

> See [--all](https://git-scm.com/docs/git-commit#Documentation/git-commit.txt--a) and [--amend --no-edit](https://git-scm.com/docs/git-commit#Documentation/git-commit.txt---no-edit).

And continue the `rebase`:

```shell
git rebase --continue
```

Then proceed for the second commit...

> Please note that the commits SHA have been modified.

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

# Reading git conflict. What is "yours" and "theirs" ?

Official explanation: [HOW CONFLICTS ARE PRESENTED](https://git-scm.com/docs/git-merge#_how_conflicts_are_presented)

In a nutshell:

    <<<<<<< yours:sample.txt
    Conflict resolution is hard;
    let's go shopping.
    =======
    Git makes conflict resolution easy.
    >>>>>>> theirs:sample.txt

## Rebase

We do:

    git checkout their-modifications-branch
    git rebase your-modifications-branch

**Vocabulary**: we say that `their-modifications-branch` is _rebased onto_ `your-modifications-branch` ([source](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)).

> * we are on `their-modifications-branch`.
> * We modify `their-modifications-branch`.
> * `HEAD` _always_ refers to a commit _coming from_ `your-modifications-branch`.
>
> The names of the branches in this example are not necessarily appropriate, relatively to the context.
> That is, depending on _who_ is doing the _rebase_ (relatively to the modifications author).
> That's why it can be confusing.

Thus:

    <<<<<<< HEAD:...
    Your modifications.
    =======
    Their modifications.
    >>>>>>> 3959352...

![](images/git-rebase-conflict.png)

# Quick "do / undo"

| Do                                                       | Undo                                          | Note                                             | Examples                         |
|----------------------------------------------------------|-----------------------------------------------|--------------------------------------------------|----------------------------------|
| `git add <file>`                                         | `git reset <file>`                            | Unstage a single file                            |                                  |
| `git add --all`                                          | `git reset`                                   | Unstage all staged files                         |                                  |
| `git commit`                                             | `git commit --amend`                          | Change message for the last commit only          |                                  |
| `git commit`                                             | `git reset --soft HEAD~1`                     | Undo last commit, but preserve changes           |                                  |
| `git commit`                                             | `git reset --hard HEAD~1`                     | Undo last commit, but **discard changes**!       |                                  |
| multiple `git commit`                                    | `git reset --soft <commit sha>`               | Undo multiple commits, but preserve changes      | [ex](examples/git-reset-soft.md) |
| multiple `git commit`                                    | `git reset --hard <commit sha>`               | Undo multiple commits, but **discard changes**!  | [ex](examples/git-reset-hard.md) |
| `git reset --soft <commit sha>`                          | `git reset 'HEAD@{1}'`                        |                                                  | [ex](examples/git-reset-head.md) |
| `git stash`                                              | `git stash pop`                               |                                                  |                                  |
| `git merge`                                              | `git merge --abort`                           | If you cannot merge...                           |                                  |
| You modify a file... but you want to discard all changes | `git restore -s origin/<branch> -- <file>`    | Get the file from a remote branch                |                                  |

# Rebase

## Work with branches

Will remove commits included in the interval `]<new parent>, <last commit to remove>]`.

Ideal arrangement (no conflict):

![](images/git-rebase-1-brief.png)

> **Vocabulary**: we say that `master` is _rebased onto_ `feature` ([source](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)).

However, be aware that conflicts may disturb this ideal arrangement.

![](images/git-rebase-conflict.png)

## Work with commits

    git rebase --onto <new parent> <last commit to remove> <new head>

> or `git rebase --onto <new parent> <old parent> <new head>`.

![](images/git-rebase-onto-2-2-brief.png)

If the last parameter is not specified, then its value is `HEAD`.

    git rebase --onto <new parent> <last commit to remove>

> or `git rebase --onto <new parent> <old parent>`.

![](images/git-rebase-onto-2-1-brief.png)

The long story... [see here](rebase.md).

## Tips and tricks during rebase

Show the SHA of the commit that is being the source of a conflict

```shell
$ git rebase --show-current-patch | head -n 1
commit 3959352cdef7d3b458c4278d859a79203f101e93
```

# GIT general tips

## What is the default branch ?

```shell
origin=$(git config --get remote.origin.url)
git remote show "${origin}" | sed -n '/HEAD/s/.*: //p'
```

## Add repository configuration to Bash prompt + usefull commands

Add this in your file `.bashrc`:

```shell

git_help() {
    # Print the list of custom commands.
    declare -F | awk {'print $3'} | egrep '^git_'
}

git_conf_check() {
  # Check the confguration of the local repository.
  local origin
  local upstream
  local origin_value
  local upstream_value

  origin=$(git config --get remote.origin.url)
  upstream=$(git config --get remote.upstream.url)

  if [ -z "${origin}" ]; then
      printf "WARNING: \"remote.origin.url\" is not configured!\n"
      return
  fi

  if [ -z "${upstream}" ]; then
      return
  fi

  origin_value=$(echo "${origin}" | sed --expression='s/^.*\/\([^\/]*\)$/\1/')
  upstream_value=$(echo "${upstream}" | sed --expression='s/^.*\/\([^\/]*\)$/\1/')

  if [ "${origin_value}" != "${upstream_value}" ]; then
      printf "ERROR: \"remote.origin.url\" (%s) and \"remote.upstream.url\" (%s) mismatch!\n" "${origin_value}" "${upstream_value}"
      return
  fi

  return
}

git_conf_print() {
  # Print the local repository cionfiguration.
  local origin
  local upstream
  local name
  local email
  local branch
  local status
  local default_branch

  name=$(git config user.name)
  email=$(git config user.email)
  branch=$(git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  origin=$(git config --get remote.origin.url)
  upstream=$(git config --get remote.upstream.url)
  status=$(git_conf_check)
  default_branch=$(git remote show "${origin}" | sed -n '/HEAD/s/.*: //p')

  printf "Git configuration:\n\n"
  printf "USER:     \"%s\"\n" "${name}"
  printf "EMAIL:    \"%s\"\n" "${email}"
  printf "BRANCH:   \"%s\" (default: \"%s\")\n" "${branch}" "${default_branch}"
  printf "ORIGIN:   \"%s\"\n" "${origin}"
  printf "UPSTREAM: \"%s\"\n" "${upstream}"

  if [ -z "${status}" ]; then
     printf "\n%s\n" "${status}"
  fi
}

git_get_id() {
  local status=$(git rev-parse --git-dir > /dev/null 2>&1; echo $?)
  if [ "${status}" -eq "0" ]; then
    local name
    local email
    local branch
    local origin
    local status

    name=$(git config user.name)
    email=$(git config user.email)
    branch=$(git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    origin=$(git config remote.origin.url)

    status=$(git_conf_check)
    if [ -z "${status}" ]; then
       printf "\nname:   [%s]\nemail:  [%s]\norigin: [%s]\nbranch: [%s]" "${name}" "${email}" "${origin}" "${branch}"
    else 
       printf "\nname:   [%s]\nemail:  [%s]\norigin: [%s]\nbranch: [%s]\n\n%s" "${name}" "${email}" "${origin}" "${branch}" "${status}"
    fi
  else
    printf ""
  fi;
}

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;93m\]`git_get_id`\[\033[0m\]\$ ' 
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
```

Result:

![](images/bash-prompt.png)

> The important point here is ``\[\033[01;33m\]`get_git_id`\[\033[0m\]``.
>
> [Good link](https://superuser.com/questions/382456/why-does-this-bash-prompt-sometimes-keep-part-of-previous-commands-when-scrollin) in case you have a problem with the colors.
>
> Links for colors:
> * [Bash Shell PS1: 10 Examples to Make Your Linux Prompt like Angelina Jolie](https://www.thegeekstuff.com/2008/09/bash-shell-ps1-10-examples-to-make-your-linux-prompt-like-angelina-jolie/)
> * [Bash tips: Colors and formatting (ANSI/VT100 Control sequences)](https://misc.flogisoft.com/bash/tip_colors_and_formatting)

Note that you can get the local data only:

```shell
name=$(git config --local --get-all user.name)
email=$(git config --local --get-all user.email)
```

## Read a "rebase" conflict message

```shell
$ git checkout feature
$ git rebase master
Fusion automatique de path/to/file
CONFLIT (contenu) : Conflit de fusion dans path/to/file
error: impossible d'appliquer 3959352... the commit message...
Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".
impossible d'appliquer 3959352... the commit message...
```

You are applying the commit `3959352` (from master) to the `HEAD` of `feature`:

    master/3959352 ---> HEAD/feature

## Have I resolved all conflicts ?

```shell
git diff --check
```

## Pick a file from another branch

    git checkout <branch name> -- <file name>

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

## Print only the names of files that changed between 2 commits

    git diff --name-only <commit sha1> [<commit sha2>]

And, if you want to get the kind of modification that affected the files:

    git diff --name-status <commit sha1> [<commit sha2>]

## Print the files in conflict

```shell
git diff --name-only --diff-filter=U
```

## Use custom diff visualizer

    git difftool -y -x sdiff 4f706f8 af61421 file.py

    git difftool -y --tool=vimdiff 4f706f8 af61421 file.py

    git difftool -y --tool=meld 4f706f8 af61421 file.py

Or you can use a _sublime_ tool: [sublim merge](https://www.sublimemerge.com/docs/faq#diffing_between_commits) (highly recommanded!)

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

## Useful aliases

Put these lines in your `.profile` (or `.bashrc`):

```shell
# git log short
# Usage: gls [<author name>]
# Note: <author name> can be just part of the real name (ex: the first name)
gls() {
   if [ -z "${1}" ]; then
      git log --pretty=format:"%C(green)%h%C(Reset) %s"
    else
      git log --author="${1}" --pretty=format:"%C(green)%h%C(Reset) %s"
   fi
}

# git log short with numeration
alias glsn='git log --pretty=format:"%h %s" | awk "{print \"HEAD~\" NR-1 \" \" \$s}"'
```

## Create a new branch from a branch that has uncommitted changes

You are on a branch. You made a lot of modifications. And you want to create a new branch that is the _exact_ copy of the current branch, including the uncommitted changes. 

    git switch -c <new branch>

> See [Git: Create a branch from unstaged/uncommitted changes on master](https://stackoverflow.com/questions/2569459/git-create-a-branch-from-unstaged-uncommitted-changes-on-master)

## Quickly set configuration for several accounts

Put this function into your `~/.bashrc`.

```shell
git_set_account() {
   if [ -d .git ]; then
      local upstream_cmd="git remote add upstream \"git@domain.com:group1/repos.git\""

      case "${1}" in
         account1)
              printf "Set configuration for GIT account [%s]\n" "${1}"
              git config user.email "account1@domain.com"
              git config user.name "Name"
              printf "Done\n\n"
              ;;
         account2)
              printf "Set configuration for GIT account [%s]\n" "${1}"
              git config user.email "account2@domain.com"
              git config user.name "Name"
              printf "Done\n\n"
              ;;
         *)
              printf "Unexpected account [%s]\n" $1
              return
              ;;
      esac

      printf "Upstream configuration:\n"
      git config --get-regexp remote.upstream.*
      printf "You may need to set upstream:\n  %s\n" "${upstream_cmd}"
   else
      printf "WARNING: your are not in a repository!\n"
   fi
}
```

The following code may be used as base for specific configuration:


```shell
git_set_target() {
   local upstream
   local origin
   local origin_value

   upstream=$(git config --get remote.upstream.url)
   origin=$(git config --get remote.origin.url)
   origin_value=$(echo "${origin}" | sed --expression='s/^.*\/\([^\/]*\)$/\1/')
   git config user.email "email@target.com" 
   git config user.name "Your Name"
   if [ -z "${upstream}"]; then
        printf "WARNING: upstream is not configured! You should execute:\n\n"
        printf "git config remote.upstream.url \"git@git.target.com:devel/%s\"\n" "${origin_value}"
        printf "git config remote.upstream.fetch \"+refs/heads/*:refs/remotes/upstream/*\"\n\n"
   else
        git config --get-regexp remote.upstream.*
   fi
}
```

