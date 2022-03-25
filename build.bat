:: linux-dev build.bat
@echo off

SETLOCAL

:: get lowercase username https://stackoverflow.com/a/29118785/32122
echo>%username% && dir /b/l %username%>%username% && set /p USER=<%username% && del %username%

set HOME_DIR="/home/%USER%"
set image="linux-dev"

set proxy="http://%~1:%~2@nodecrypt.corp.com:800"
set noproxy="localhost,127.0.0.1,.corp.com,.corp2.com"

IF "%~1"=="--noproxy" (
  echo Building docker container...
  docker build --tag %image% source ^
    --progress=plain ^
    --build-arg USER="%USER%" ^
    --build-arg HOME_DIR=%HOME_DIR% ^
    --build-arg UID="1000" ^
    --build-arg GROUP="%USER%" ^
    --build-arg GID="1000"
) ELSE (
  IF "%~1"=="" ( echo Usage: build.bat USERNAME "PASSWORD" && echo    or: build.bat --noproxy && exit /B )
  IF "%~2"=="" ( echo Please provide a password in double quotes && exit /B )
  IF "%~2"=="%2" ( echo Please provide a password in double quotes, for example "%2" && exit /B )
  echo Building docker container...
  docker build --tag %image% source ^
    --progress=plain ^
    --build-arg USER="%USER%" ^
    --build-arg HOME_DIR=%HOME_DIR% ^
    --build-arg UID="1000" ^
    --build-arg GROUP="%USER%" ^
    --build-arg GID="1000" ^
    --build-arg http_proxy=%proxy% ^
    --build-arg HTTP_PROXY=%proxy% ^
    --build-arg https_proxy=%proxy% ^
    --build-arg HTTPS_PROXY=%proxy% ^
    --build-arg ftp_proxy=%proxy% ^
    --build-arg FTP_PROXY=%proxy% ^
    --build-arg no_proxy=%noproxy% ^
    --build-arg NO_PROXY=%noproxy%
)

ENDLOCAL
