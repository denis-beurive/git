# Git rebase

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
