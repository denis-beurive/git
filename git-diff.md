# Git diff

## Print the changed applied to a specific commit

```shell
$ git diff <commit SHA>
```

> Please note that you may need to use `git fetch` first.

## Print only the names of files that changed between 2 commits

```shell
git diff --name-only <commit sha1> [<commit sha2>]
```

> The default value for `<commit sha2>` is `HEAD`.

And, if you want to get the kind of modification that affected the files:

```shell
git diff --name-status <commit sha1> [<commit sha2>]
```

## Print the names of the files that have been modified between 2 commits

```shell
git diff --name-only --diff-filter=M <commit sha1> [<commit sha2>]
```

> The default value for `<commit sha2>` is `HEAD`.
>
> For the list of values for the option "--dif-only": [--dif-only values](https://stackoverflow.com/questions/6879501/filter-git-diff-by-type-of-change)
>
> * A Added
> * C Copied
> * D Deleted
> * M Modified
> * R Renamed
> * T have their type (mode) changed
> * U Unmerged
> * X Unknown
> * B have had their pairing Broken
> * \* All-or-none
