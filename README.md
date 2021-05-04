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


    $ git remote set-url origin git@personal.github.com:denis-beurive/git.git

# Troubleshooting

## Activate the debug output

If you have a problem while performing a GIT command, you can try this commands:

    GIT_TRACE=2 git push --verbose -u origin master

Or, even better:

    GIT_CURL_VERBOSE=1 GIT_TRACE=1 git push -u origin master

## Did you get this error ? "error: failed to push some refs to..."

You probably need to commit something.

# Useful commands

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

## Print the LOG

    git log --pretty="%h %an %ae"

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

    & git push origin master

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

# Good links

* [Git de l'intérieur](https://alm.developpez.com/tutoriel/fonctionnement-interne-de-git/)

## See all commits

    git log --pretty="%cd %H"

## Checout a specific commit

    git checkout <commit SHA>

For example:

    git checkout b928950669f5da9414000de50c3a3ba7f7be7597

