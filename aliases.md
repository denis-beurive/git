# Useful aliases

## Linux

Put these lines in your `.profile` (or `.bashrc`):

```shell
# git log short
# Usage: gls [<author name>]
# Note: <author name> can be just part of the real name (ex: the first name)
gls() {
   if [ -z "${1}" ]; then
      git log --pretty=format:"%C(green)%h%C(Reset) %s"
    else
      git log --author="${1}" --pretty=format:"%C(green)%h%C(Reset) %s"
   fi
}

# git log short with numeration
alias glsn='git log --pretty=format:"%h %s" | awk "{print \"HEAD~\" NR-1 \" \" \$s}"'
```

## Windows (MS-DOS)

File [gls.bat](scripts/gls.bat):

```
@echo off

REM git log short
REM Usage: gls [<author name>]
REM Note: <author name> can be just part of the real name (ex: the first name)

set author=%~1

if "%author%" == "" (
    git log --pretty=format:"%%C(green)%%h%%C(Reset) %%s"
) else (
    echo %author%
    git log --author="%author%" --pretty=format:"%%C(green)%%h%%C(Reset) %%s"
)
```

file [glsn.bat](scripts/glsn.bat):

```
@echo off

set PATH_TO_GLSN_PY="C:\Users\Denis BEURIVE\Documents\github\git\scripts\glsn.py"

python %PATH_TO_GLSN_PY%
```

> This use the Python3 scrip [glsn.py](scripts/glsn.py).
