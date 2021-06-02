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

    $ ssh -T git@personal.github.com
    Hi your-login-1! You've successfully authenticated, but GitHub does not provide shell access.

    $ ssh -T git@profesional.github.com
    Hi your-login-2! You've successfully authenticated, but GitHub does not provide shell access.

> If you need to check the repository configuration: `git config -l`

## SSH troubleshouting

Here are some useful commands.

Check the fingerprint of an SSH key:

    $ sh-keygen -l -E sha256 -f $SSH_KEY_FILE

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

    $ git remote add origin git@personal.github.com:your-login-1/your-repository.git
    $ git config user.email "your-login-1@domain.com"

or:

    $ git remote add origin git@profesional.github.com:your-login-2/your-repository.git
    $ git config user.email "your-login-2@domain.com"

To see the configuration:

    $ git config --list
    $ git config --get-all user.email
    $ git config --get-all remote.origin.url

Il you need to unset/remove a configuration paramter:

    $ git config --unset user.email your-login-1@domain.com
    $ git remote rm origin

If you need to change the origin URL:

    $ git remote set-url origin git@personal.github.com:your-login-1/your-repository.git

> This command may be useful depending on your GitHub account settings.

# Troubleshooting

## Activate the debug output

If you have a problem while performing a GIT command, you can try this commands:

    GIT_TRACE=2 git push --verbose -u origin master

Or, even better:

    GIT_CURL_VERBOSE=1 GIT_TRACE=1 git push -u origin master

## Did you get this error ? "error: failed to push some refs to..."

You probably need to commit something.

# Useful commands

## Make an initial empty commit

    git commit --allow-empty -m "initial commit"

> Please note:
>
> Git represents branches as pointers to the latest commit in that branch. If you haven't created a commit yet, there's nothing for that branch to point to. So you can't really create branches until you have at least one commit [source](https://stackoverflow.com/questions/5678699/creating-branches-on-an-empty-project-in-git/5678812).

## Inject the modifications into the repository

    git push -u origin master

## Add all modified files to the staging area

	git status --porcelain | egrep '^ M ' | sed --expression='s/^ M //' | xargs -n1 git add

## Commit all staged files

	git status --porcelain | egrep '^M  ' | sed --expression='s/^M  //' |  xargs -n1 git commit -m "Your message"

## Commit all the modification at once

    $ git status --porcelain | perl -e '@lines = (); while (<STDIN>) { chomp; $_ =~ s/^ *(M|A|D|R|C|U) //; push(@lines, $_); } print join(" ", @lines);' | xargs git add

    $ git status --porcelain | perl -e '@lines = (); while (<STDIN>) { chomp; unless($_ =~ m/^ *M /) { next; }; $_ =~ s/^ *M //; push(@lines, $_); } print join(" ", @lines);' | xargs git add

    $ git status --porcelain | perl -e '@lines = (); while (<STDIN>) { chomp; unless($_ =~ m/^ *D /) { next; }; $_ =~ s/^ *D //; push(@lines, $_); } print join(" ", @lines);' > delete.sh

## Change the case

    git mv foldername tempname && git mv tempname folderName
    git mv Entrypoints tempname && git mv tempname EntryPoints

## Print the LOG (print commits)

    git log --pretty="%h %an %ae"

Add color and filter on commits author:

    git log --stat --pretty=format:"%C(#ff69b4)#####> %h - %an, %ar :%C(reset)%n%n%C(#FFFF00)%s%c(Reset)%n%n%b" --author="Denis BEURIVE"

> Please note that you may need to use `git fetch` first.

Add the file(s) associated with the commits (add option `--name-only`):

    $ git log --pretty=format:"%C(green)%h%C(Reset) %s" --name-only

Add the names of the commits authors (add "`%an`"):

    $ git log --pretty=format:"%C(green)%h%C(Reset) %C(red)%an%C(Reset) %s%n%aD" --name-only

## Print the changed applied on a specific commit

    $ git diff <commit SHA>

> Please note that you may need to use `git fetch` first.

## Print the remote configuration

    git remote -v

If you need to remove a remote:

    git remote rm <name of the remote> # For example git remote rm origin

## Tags

If you need to tag:

    git tag -a 1.0.0 -m "First version"
    git push origin --tags

If you need to delete the tag:

    git tag -d 1.0.0
    git push origin :refs/tags/1.0.0

Check the tags on the remote:

    git ls-remote --tags

## Remove a file from the (remote) repository

The command below removes files on the (remote) repository only.
It does not remove the file from the local filesystem.

    git rm --cached /path/to/the/file 
    git commit -m "remove /path/to/the/file"
    git push -u origin master

## Create a repository on the GIT server (which may be localhost)

    $ cd /opt/git
    $ mkdir projet.git
    $ cd projet.git
    $ git --bare init

## Create a new branch

    $ git checkout -b refactoring
    Switched to a new branch 'refactoring'

    $ git branch
      master
    * refactoring

## Push the branch

    $ git push origin refactoring

## Merge the branch

    $ git branch
      master
    * refactoring
    
    $ git checkout master
    Switched to branch 'master'
    
    $ git merge refactoring

    $ git push origin master

## Delete a local branch

First, make sure that the branch has been merged:

    git branch --merged

Then, you can delete it:

    git branch -d refactoring

## Delete a remote branch

First, make sure that the remote branch has been merged:

    git branch -r merged

Then, you can delete it:

    git push origin --delete refactoring

## Save authentication parameters

    git config credential.helper store

or:

    git config --global credential.helper store

For a session only:

    git config --global credential.helper cache

## Force the update of the local repository

The following command will force the update of the local repository:

    git fetch --all && git reset --hard origin/master

## Check a .gitignore file

Assuming that you have the following `.gitignore` file:

    .gradle/
    build/
    libs/
    .idea/
    lib/

Then, you can make sure that a particular entry (file or directory) is ignored:

    $ git check-ignore -v */lib
    .gitignore:5:lib/   app-cbc-des/lib
    .gitignore:5:lib/   app-cfb-des/lib

## Global .gitignore

You can create a `.gitignore` file that will apply for all your projects:

    git config --global core.excludesFile ~/.gitignore

## Import the branch metadata only (do not merge)

For a single branch:

    git fetch

For all branches:

    git fetch --all

or, which is equivalent:

    git remote update

**Note**:

Once the local repository has been updated/fetched, we can compare the local branch with the remote one:

    git diff main origin/main  # git diff main @{upstream}

> `git diff` only relies on local (downloaded) data.

## Print details about a specific commit

    git show <commit SHA>

Example:

    $ git log  --pretty=format:"%C(green)%h%C(Reset) %s"
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
 
If you need to show the last commit:

    git show HEAD

## Checkout a specific commit

    git checkout <commit SHA>

For example:

    git checkout b928950669f5da9414000de50c3a3ba7f7be7597

## Set specific editor for interactive oprations

    git config --global core.editor "/home/denis/Documents/softwares/sublime_text_3/sublime_text -n -w"

Or, for version 4 of Sublime Text:

    git config --global core.editor "/usr/bin/subl -n -w"

> Source: [Git Tips #2 - Change editor for interactive Git rebase](https://www.kevinkuszyk.com/2016/03/08/git-tips-2-change-editor-for-interactive-git-rebase/)

## Change commits messages

In order to change commits, you use the command `rebase`.

    $ git log  --pretty=format:"%C(green)%h%C(Reset) %s"
    b34a05c Edit file2 for the first time
    174f7f2 Create file2
    c4fb274 Create file1
    9fb518b first commit

Let's say that you want to change the messages for the commits `174f7f2` and `c4fb274`. Then you need to consider the 3 last commits.

> Please note that a all commits you want to edit must have a parent commit. This means that, in our example, the commit `9fb518b` cannot be edited.

    COMMITS_COUNT=3
    git rebase -i HEAD~${COMMITS_COUNT}

> Please note that the command below may be useful to find out the value of COMMITS_COUNT: `max=$(echo "$(git log --pretty=format:"#> %h")" | wc -l) && echo "max=${max}"`

Then GIT will open the editor you configured and ask you to modify the printed text. For example:

    pick c4fb274 Create file1
    pick 174f7f2 Create file2
    pick b34a05c Edit file2 for the first time

    # Rebasage de 9fb518b..b34a05c sur 9fb518b (3 commandes)
    #
    # Commandes :
    #  p, pick <commit> = utiliser le commit
    #  r, reword <commit> = utiliser le commit, mais reformuler son message
    # ...

Then for `174f7f2` and `c4fb274`, change "`pick`" to "`reword`". That is:

    reword c4fb274 Create file1
    reword 174f7f2 Create file2
    pick b34a05c Edit file2 for the first time

Close the editor and follow the instructions... At the end, you get:

    $ git rebase -i HEAD~3
    [HEAD détachée 50659dc] Create file1. This message has been modified.
     Date: Thu May 6 11:03:45 2021 +0200
     1 file changed, 1 insertion(+)
     create mode 100644 file1
    [HEAD détachée faf7388] Create file2. This message has been modified.
     Date: Thu May 6 11:46:00 2021 +0200
     1 file changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 file2
    Rebasage et mise à jour de refs/heads/main avec succès.

And:

    $ git log --pretty=format:"#> %h %s"
    #> 8699120 Edit file2 for the first time
    #> faf7388 Create file2. This message has been modified.
    #> 50659dc Create file1. This message has been modified.
    #> 9fb518b first commit

> Please note that the commits SHA have been modified.

# Override branches

## Override a REMOTE branch by LOCAL branch

Let's say that you want to _completely override_ the remote branch "`issue135`" by the local branch "`issue135-clean`".

    $ git branch
    * master
      issue135-clean

Checkout the branch "`issue135-clean`":

    $ git checkout issue135-clean

Rename the current branch (that is "`issue135-clean`") into "`issue135`":

    $ git branch -m issue135
    $ git branch
    * issue135
      master

Then push (from now on) the branch "`issue135`":

    $ git push -f origin issue135

> Please note the use of the option `-f` (force).

## Override a LOCAL branch by REMOTE branch

Let's say that you want to _completely override_ the local branch "`issue135`" by the remote branch "`issue135`".

    $ git branch
    * issue135
      master

    $ git fetch --all

    $ git reset --hard origin/issue135

> **WARINING**: all modifications made on the local branch will be lost!

# Quick "do / undo"

| Do                                                       | Undo                                          | Note                                             | Examples                         |
|----------------------------------------------------------|-----------------------------------------------|--------------------------------------------------|----------------------------------|
| `git add <file>`                                         | `git reset <file>`                            |                                                  |                                  |
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

This is a long story... [see here](rebase.md).

# Good links

* [Git de l'intérieur](https://alm.developpez.com/tutoriel/fonctionnement-interne-de-git/)
