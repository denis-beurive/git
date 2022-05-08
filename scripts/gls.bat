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
