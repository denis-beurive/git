# Useful aliases

## Useful aliases

### Linux

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

# git log short with list of impacted files
# Usage: gls-files [<author name>]
# Note: <author name> can be just part of the real name (ex: the first name)
gls-files() {
   if [ -z "${1}" ]; then
      git log --pretty=format:"%C(green)%h%C(Reset) %s" --name-only
    else
      git log --author="${1}" --pretty=format:"%C(green)%h%C(Reset) %s" --name-only
   fi
}

# git log short that tracks all logs that affected a given file
# Usage: gls-track <file path>
gls-track() {
   if [ -z "${1}" ]; then
      echo "Argument <file> missing"
    else
      git log --follow --pretty=format:"%C(green)%h%C(Reset) %s" -- "${1}"
   fi
}

# show files status for a specified commit.
# Usage: gs-status <commit id>
gs-status() {
   if [ -z "${1}" ]; then
      echo "Argument <commit> missing"
    else
      git show --pretty="" --name-status "${1}"
   fi
}

# git log short with numeration
alias glsn='git log --pretty=format:"%h %s" | awk "{print \"HEAD~\" NR-1 \" \" \$s}"'

gh() {
    echo "gls [<author>]        - print short log"
    echo "glsn [<author>]       - print short log using \"HEAD\""
    echo "gls-files [<author>]  - print short log with impacted files"
    echo "gls-track <file>      - print short log related to a given file"
    echo "gs-status <commit>    - print files modifications during a given commit"
}
```

### Windows (MS-DOS)

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

File [gls-files.bat](scripts/gls-files.bat):

```
@echo off

REM git log short with files names
REM Usage: gls-files [<author name>]
REM Note: <author name> can be just part of the real name (ex: the first name)

set author=%~1

if "%author%" == "" (
    git log --pretty=format:"%%C(green)%%h%%C(Reset) %%s" --name-only
) else (
    echo %author%
    git log --author="%author%" --pretty=format:"%%C(green)%%h%%C(Reset) %%s"  --name-only
)
```

File [gls-track.bat](scripts/gls-track.bat):

```
@echo off

REM git log short that tracks all logs that affected a given file
REM Usage: gls-track <file path>

set file=%~1

if "%file%" == "" (
    echo Argument "file" missing
) else (
    git log --follow --pretty=format:"%%C(green)%%h%%C(Reset) %%s" -- %file%
)
```

File [gs-status.bat](scripts/gs-status.bat):

```
@echo off

REM show files status for a specified commit.
REM Usage: gs-status <commit id>

set commit=%~1

if "%commit%" == "" (
    echo Argument "commit" missing
) else (
    git show --pretty="" --name-status %commit%
)
```

Print help for aliases (file [gh.bat](scripts/gh.bat)):

```
@echo off

echo gls [^<author^>]        - print short log
echo glsn [^<author^>]       - print short log using "HEAD"
echo gls-files [^<author^>]  - print short log with impacted files
echo gls-track ^<file^>      - print short log related to a given file
echo gs-status ^<commit^>    - print files modifications during a given commit
```
