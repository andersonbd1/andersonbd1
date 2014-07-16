rem originally copied from here, but I modified it: http://stackoverflow.com/questions/1881594/use-winmerge-inside-of-git-to-file-diff
@echo off

setlocal

if "%1" == "-?" (
    echo GitDiff - enables diffing of file lists, instead of having to serially
    echo diff files without being able to go back to a previous file.
    echo Command-line options are passed through to git diff.
    echo If GIT_FOLDER_DIFF is set, it is used to diff the file lists. Default is windff.
    goto END
)

if "%GIT_DIFF_COPY_FILES%"=="" (
    rd /s /q %TEMP%\GitDiff
    mkdir %TEMP%\GitDiff
    mkdir %TEMP%\GitDiff\old
    mkdir %TEMP%\GitDiff\new

    REM This batch file will be called by git diff. This env var indicates whether it is
    REM being called directly, or inside git diff
    set GIT_DIFF_COPY_FILES=1

    set GIT_DIFF_OLD_FILES=%TEMP%\GitDiff\old
    set GIT_DIFF_NEW_FILES=%TEMP%\GitDiff\new

    rem set GIT_EXTERNAL_DIFF="%~dp0\GitDiff.bat"
    set GIT_EXTERNAL_DIFF=GitDiff.bat
    echo Please wait and press q when you see "(END)" printed in reverse color...
    call git diff %*

    if defined GIT_FOLDER_DIFF (
        REM This command using GIT_FOLDER_DIFF just does not work for some reason.
        %GIT_FOLDER_DIFF% %TEMP%\GitDiff\old %TEMP%\GitDiff\new
        goto END
    )

    if exist "%ProgramFiles%\Beyond Compare 2\BC2.exe" (
        set GIT_FOLDER_DIFF="%ProgramFiles%\Beyond Compare 2\BC2.exe"
        "%ProgramFiles%\Beyond Compare 2\BC2.exe" %TEMP%\GitDiff\old %TEMP%\GitDiff\new
        goto END
    )

    "c:\dev\apps\WinMerge\WinMergeU.exe" -r -e -dl "Base" -dr "Mine"  %TEMP%\GitDiff\old %TEMP%\GitDiff\new
    goto END
)

echo "gitdiff called" %*

set one=%1
if "%one%" NEQ "/dev/null" (
    set one=%one:/=\%
)
echo %one%

set five=%5
if "%five%" NEQ "/dev/null" (
    set five=%five:/=\%
)
echo %five%

REM diff is called by git with 7 parameters:
REM     path old-file old-hex old-mode new-file new-hex new-mode
copy %TEMP%\%~nx2 %GIT_DIFF_OLD_FILES%\%one%
copy %five% %GIT_DIFF_NEW_FILES%

:END
