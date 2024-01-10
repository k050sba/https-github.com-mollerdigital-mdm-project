@REM Copyright Siperian Corp. 2005
@echo off
@setlocal

SET THISFOLDER=%~dp0
SET THISSCRIPT=%~nx0
SET PARAM=%*

@pushd "%THISFOLDER%"
call "%THISFOLDER%..\setSiperianEnv.bat"

SET CLASSPATH=%SIP_HOME%\deploy\lib\ProductVersion.jar;%SIP_HOME%\deploy\lib\xml-apis.jar;%SIP_HOME%\deploy\lib\log4j-1.2.16.jar;%SIP_HOME%\deploy\lib\xercesImpl.jar

@echo ------------------------------------------------------------------
@echo on
"%JAVA_HOME%\bin\java" %USER_INSTALL_PROP% -classpath "%CLASSPATH%" com.siperian.ia.prodversion.SoftwareVersionInfo %SIP_HOME%\deploy
@echo off

