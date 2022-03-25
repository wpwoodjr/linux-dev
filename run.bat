:: linux-dev run.bat
@echo off

SETLOCAL

IF "%~1"=="" ( echo Usage: run.bat "HOST-WORKING-DIRECTORY" [CONTAINER-NAME] && exit /B )
IF "%~2"=="" (set NAME="linux-dev") ELSE (set NAME="%~2")

:: get lowercase username https://stackoverflow.com/a/29118785/32122
echo>%username% && dir /b/l %username%>%username% && set /p USER=<%username% && del %username%

set WORK_DIR="/home/%USER%/work"

docker run -itd --restart=always --hostname %NAME% --name %NAME% --env HOST_DIR="%~1" -v %1:%WORK_DIR% -e DOCKER_HOST=tcp://host.docker.internal:2375 linux-dev
if %errorlevel% neq 0 exit /B %errorlevel%

echo Container %NAME% running with host directory "%~1" mounted at %WORK_DIR%

ENDLOCAL
