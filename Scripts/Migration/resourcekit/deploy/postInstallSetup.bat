@rem Copyright Siperian Corp. 2005
@setlocal
@echo off


rem archive logs
@pushd "%~dp0logs"
IF EXIST postInstallSetup.log2 MOVE postInstallSetup.log2 postInstallSetup.log3
IF EXIST postInstallSetup.log1 MOVE postInstallSetup.log1 postInstallSetup.log2
IF EXIST postInstallSetup.log MOVE postInstallSetup.log postInstallSetup.log1
@popd


@pushd "%~dp0bin"
call "sip_ant.bat" postinstallsetup -logger org.apache.tools.ant.NoBannerLogger -logfile ../logs/postInstallSetup.log %*


IF %ERRORLEVEL% EQU 0 goto :success
echo.
echo *** DEPLOYMENT FAILED ***
echo.
goto :end

:success
echo.
echo *** DEPLOYMENT SUCCESSFUL ***
echo.

:end
echo *** View execution results in log file :  %~dp0logs/postInstallSetup.log ***

@popd
@endlocal
