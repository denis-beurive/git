# Git log

## For the current branch

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

## For another branch

Just specify the name of the branch:

```shell
git log --pretty=format:"%ct %h %s" feature
```

## For a set of branches

Just specify the names of the branches:

```shell
$ git log --pretty=format:"%ct %h %s" feature master
1622741213 2778ac8 3. edit from master
1622741170 a38453b 2. edit from feature
1622741110 a53d88c 1. edit from master
1622741055 bfb5b09 initial commit
```

> The cool thing is that the commits are chronologically sorted.

