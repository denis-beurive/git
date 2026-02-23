# Git diff

## Reading the command output

Let's consider the command below:

    git diff <left> [<rigth>]

> * `<left>` and `<right>` represent **commits**.
> * By default, if `<right>` is not specified, then `<right>` is `HEAD` (see [notations](notations.md)).

It prints:

> What should be done to pass from  `<left>` to `<right>`.

Notations:

* `--- a/file`: the content of `<left>`.
* `+++ b/file`: the content of `<right>`.
* `-`: what we remove from `<left>` (in order to obtain `<right>`).
* `+`: what we add to `<left>` (in order to obtain `<right>`).

See [this example](examples/git-diff-manip.md).

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
