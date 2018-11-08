@echo off
setlocal
if "%*"=="" echo You need to give a name like "April 2016 Update 2"&goto :eof

if NOT DEFINED FAKEDATE set FAKEDATE=%DATE:~4%T17:00
set LOGLINE=%*
echo Changes will be named "Blah Blah blah - %LOGLINE%"

echo.
echo Verifying committer email.
set GIT_COMMITTER_EMAIL=
git config --get user.email|findstr github
if errorlevel 1 echo Wrong committer email.&goto :eof

echo Verifying that fork repo is in sync with vso.
cd /d S:\repos\fork
if NOT "%CD%"=="S:\repos\fork" echo Wrong directory!&goto :eof
git fetch vso
call :check-equal-refs s/win10-1507 vso/s/win10-1507
if errorlevel 1 goto :eof
call :check-equal-refs s/win10-1511 vso/s/win10-1511
if errorlevel 1 goto :eof
call :check-equal-refs rs1 vso/rs1&rem s/win10-1607
if errorlevel 1 goto :eof
call :check-equal-refs rs2 vso/rs2&rem s/win10-1703
if errorlevel 1 goto :eof
call :check-equal-refs rs3 vso/rs3&rem s/win10-1709
if errorlevel 1 goto :eof
call :check-equal-refs rs4 vso/rs4&rem s/win10-1803
if errorlevel 1 goto :eof
call :check-equal-refs rs5 vso/rs5&rem s/win10-18xx
if errorlevel 1 goto :eof

cd /d S:\repos\public
if NOT "%CD%"=="S:\repos\public" echo Wrong directory 2!&goto :eof
git fetch vso

echo Verifying that public repo is in sync with github.

git fetch public
call :check-equal-refs win10-1507 public/win10-1507
if errorlevel 1 goto :eof
call :check-equal-refs win10-1511 public/win10-1511
if errorlevel 1 goto :eof
call :check-equal-refs win10-1607 public/win10-1607
if errorlevel 1 goto :eof
call :check-equal-refs win10-1703 public/win10-1703
if errorlevel 1 goto :eof
call :check-equal-refs win10-1709 public/win10-1709
if errorlevel 1 goto :eof
call :check-equal-refs master public/master
if errorlevel 1 goto :eof
call :check-equal-refs dev public/dev
if errorlevel 1 goto :eof

echo Detaching HEAD
git checkout --detach dev

set PREV_BRANCH= &rem empty space intentional

echo Looking for changes in win10-1507
call :check-equal-trees vso/s/win10-1507 win10-1507
if not errorlevel 1 goto skip-win10-1507
echo Merging win10-1507
set GIT_COMMITTER_DATE=%FAKEDATE%:00
set GIT_AUTHOR_DATE=%FAKEDATE%:00
for /f %%i in ('git commit-tree vso/s/win10-1507^^^^{tree} -p win10-1507 -m "Windows 10 Version 1507 - %LOGLINE%"') do git fetch . %%i:win10-1507
set PREV_BRANCH=-p win10-1507
:skip-win10-1507

echo Looking for changes in win10-1511
call :check-equal-trees vso/s/win10-1511 win10-1511
if not errorlevel 1 goto skip-win10-1511
echo Merging vso:s/win10-1511 to public:win10-1511
set GIT_COMMITTER_DATE=%FAKEDATE%:01
set GIT_AUTHOR_DATE=%FAKEDATE%:01
for /f %%i in ('git commit-tree vso/s/win10-1511^^^^{tree} -p win10-1511 %PREV_BRANCH% -m "Windows 10 Version 1511 - %LOGLINE%"') do git fetch . %%i:win10-1511
set PREV_BRANCH=-p win10-1511
:skip-win10-1511

echo Looking for changes in win10-1607
call :check-equal-trees vso/rs1 win10-1607&rem vso/s/win10-1607
if not errorlevel 1 goto skip-win10-1607
echo Merging vso:rs1 to public:win10-1607
set GIT_COMMITTER_DATE=%FAKEDATE%:02
set GIT_AUTHOR_DATE=%FAKEDATE%:02
for /f %%i in ('git commit-tree vso/rs1^^^^{tree} -p win10-1607 %PREV_BRANCH% -m "Windows 10 Version 1607 - %LOGLINE%"') do git fetch . %%i:win10-1607
set PREV_BRANCH=-p win10-1607
:skip-win10-1607

echo Looking for changes in win10-1703
call :check-equal-trees vso/rs2 win10-1703&rem vso/s/win10-1703
if not errorlevel 1 goto skip-win10-1703
echo Merging vso:rs2 to public:win10-1703
set GIT_COMMITTER_DATE=%FAKEDATE%:03
set GIT_AUTHOR_DATE=%FAKEDATE%:03
for /f %%i in ('git commit-tree vso/rs2^^^^{tree} -p win10-1703 %PREV_BRANCH% -m "Windows 10 Version 1703 - %LOGLINE%"') do git fetch . %%i:win10-1703
set PREV_BRANCH=-p win10-1703
:skip-win10-1703

echo Looking for changes in win10-1709
call :check-equal-trees vso/rs3 win10-1709&rem vso/s/win10-1709
if not errorlevel 1 goto skip-win10-1709
echo Merging vso:rs3 to public:win10-1709
set GIT_COMMITTER_DATE=%FAKEDATE%:04
set GIT_AUTHOR_DATE=%FAKEDATE%:04
for /f %%i in ('git commit-tree vso/rs3^^^^{tree} -p win10-1709 %PREV_BRANCH% -m "Windows 10 Version 1709 - %LOGLINE%"') do git fetch . %%i:win10-1709
set PREV_BRANCH=-p win10-1709
:skip-win10-1709

echo Looking for changes in win10-1803
call :check-equal-trees vso/rs4 master&rem vso/s/win10-1803
if not errorlevel 1 goto skip-win10-1803
echo Merging vso:rs4 to public:win10-1803
set GIT_COMMITTER_DATE=%FAKEDATE%:05
set GIT_AUTHOR_DATE=%FAKEDATE%:05
for /f %%i in ('git commit-tree vso/rs4^^^^{tree} -p win10-1803 %PREV_BRANCH% -m "Windows 10 Version 1803 - %LOGLINE%"') do git fetch . %%i:master
set PREV_BRANCH=-p master
:skip-win10-1803

echo Looking for changes in win10-1809
call :check-equal-trees vso/rs5 win10-1809&rem vso/s/win10-1809
if not errorlevel 1 goto skip-win10-1809
echo Merging vso:rs5 to public:master
set GIT_COMMITTER_DATE=%FAKEDATE%:06
set GIT_AUTHOR_DATE=%FAKEDATE%:06
for /f %%i in ('git commit-tree vso/rs5^^^^{tree} -p master %PREV_BRANCH% -m "Windows 10 Version 1809 - %LOGLINE%"') do git fetch . %%i:master
set PREV_BRANCH=-p master
:skip-win10-1809

rem echo Merging vso:rs5 to public:dev
rem set GIT_COMMITTER_DATE=%FAKEDATE%:06
rem set GIT_AUTHOR_DATE=%FAKEDATE%:06
rem for /f %%i in ('git commit-tree vso/rs5^^^^{tree} -p dev %PREV_BRANCH% -m "Windows 10 future version - %LOGLINE%"') do git fetch . %%i:dev
rem set PREV_BRANCH=-p dev
rem echo MAKE DEV EQUAL TO MASTER FOR NOW

goto :eof

rem Verify that %1 and %2 are equal refs.
:check-equal-refs
for /f %%i in ('git rev-list --max-count=1 %1...%2') do echo %1 and %2 are not in sync!&exit /b 1
goto :eof

rem Verify that %1 and %2 are equal trees.
:check-equal-trees
set _1=
set _2=
for /f %%i in ('git rev-parse %1^^^^{tree}') do set _1=%%i
for /f %%i in ('git rev-parse %2^^^^{tree}') do set _2=%%i
if "%_1%"=="%_2%" echo Trees %1 and %2 are the same.&exit /b 0
echo Trees %1 and %2 are different!&exit /b 1
