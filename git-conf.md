# Git configuration

## Save authentication parameters

```shell
git config credential.helper store
```

or:

```shell
git config --global credential.helper store
```

For a session only:

```shell
git config --global credential.helper cache
```

## Set specific editor for interactive oprations

for version 3 of Sublime Text:

```shell
git config --global core.editor "/home/denis/Documents/softwares/sublime_text_3/sublime_text -n -w"
```

Or, for version 4 of Sublime Text:

```shell
git config --global core.editor "/usr/bin/subl -n -w"
```

> Source: [Git Tips #2 - Change editor for interactive Git rebase](https://www.kevinkuszyk.com/2016/03/08/git-tips-2-change-editor-for-interactive-git-rebase/)

## Use custom diff visualizer

    git difftool -y -x sdiff 4f706f8 af61421 file.py

    git difftool -y --tool=vimdiff 4f706f8 af61421 file.py

    git difftool -y --tool=meld 4f706f8 af61421 file.py

Or you can use a _sublime_ tool: [sublim merge](https://www.sublimemerge.com/docs/faq#diffing_between_commits) (highly recommanded!)


