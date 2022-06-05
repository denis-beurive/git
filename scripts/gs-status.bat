@echo off

REM show files status for a specified commit.
REM Usage: gs-status <commit id>

set commit=%~1

if "%commit%" == "" (
    echo Argument "commit" missing
) else (
    git show --pretty="" --name-status %commit%
)
