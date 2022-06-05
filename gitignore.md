# File .gitgnore

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
