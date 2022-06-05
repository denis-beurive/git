# Git diff

## Print the changed applied to a specific commit

```shell
$ git diff <commit SHA>
```

> Please note that you may need to use `git fetch` first.

## Print only the names of files that changed between 2 commits

    git diff --name-only <commit sha1> [<commit sha2>]

And, if you want to get the kind of modification that affected the files:

    git diff --name-status <commit sha1> [<commit sha2>]
