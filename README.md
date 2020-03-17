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

# Good links

* [Git de l'intérieur](https://alm.developpez.com/tutoriel/fonctionnement-interne-de-git/)

