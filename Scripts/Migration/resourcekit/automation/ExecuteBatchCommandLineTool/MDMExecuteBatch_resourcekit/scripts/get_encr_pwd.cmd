@rem Get the MDM encrypted password from clear test password
@echo off
SETLOCAL

@rem get environment variables
call mdm_exec_batch_proc_env.cmd

set KEY_TYPE=PASSWORD_KEY

if "%1" == "" (
   echo Argument Error.  Usage: %0 ^<password_string^>
   exit /b 1
)

java com.siperian.common.security.Blowfish %KEY_TYPE% %1

ENDLOCAL