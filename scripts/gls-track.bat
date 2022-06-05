@echo off

REM git log short that tracks all logs that affected a given file
REM Usage: gls-track <file path>

set file=%~1

if "%file%" == "" (
    echo Argument "file" missing
) else (
    git log --follow --pretty=format:"%%C(green)%%h%%C(Reset) %%s" -- %file%
)
