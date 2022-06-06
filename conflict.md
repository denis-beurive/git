# Conflits management

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

## Reading git conflict. What is "yours" and "theirs" ?

Official explanation: [HOW CONFLICTS ARE PRESENTED](https://git-scm.com/docs/git-merge#_how_conflicts_are_presented)

In a nutshell:

    <<<<<<< yours:sample.txt
    Conflict resolution is hard;
    let's go shopping.
    =======
    Git makes conflict resolution easy.
    >>>>>>> theirs:sample.txt

## Print the files in conflict

```shell
git diff --name-only --diff-filter=U
```

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
> * * All-or-none

