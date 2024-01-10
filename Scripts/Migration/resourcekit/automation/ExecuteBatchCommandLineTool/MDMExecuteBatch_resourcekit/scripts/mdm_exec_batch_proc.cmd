@ECHO OFF
@rem must have enabledelayedexpansion option for delayed code block execution
SETLOCAL enabledelayedexpansion

@rem scripts to get environment variables
call D:\Scripts\Migration\resourcekit\automation\ExecuteBatchCommandLineTool\MDMExecuteBatch_resourcekit\scripts\mdm_exec_batch_proc_env.cmd


@rem if log directory does not exist, create it
if not exist "%MDM_LOGFILE_DIR%" mkdir "%MDM_LOGFILE_DIR%"

@rem construct log file name suffix using data format of YYYY-MM-DD) 
@rem
@rem get date (Ddd mm/dd/yyyy format) assuming the NT regional setting for date is
@rem Ddd mm/dd/yyyy for US
set "MDM_LOG_DATE=%DATE%"

@rem format date to YYYY-MM-DD  ----------------------------------
set MDM_LOG_MM=%MDM_LOG_DATE:~4,2%
set MDM_LOG_DD=%MDM_LOG_DATE:~7,2%
set MDM_LOG_YYYY=%MDM_LOG_DATE:~10,4%
set MDM_LOGFILE_SFX=%MDM_LOG_YYYY%-%MDM_LOG_MM%-%MDM_LOG_DD%
set MDM_LOGFILE=%MDM_LOGFILE_DIR%\%MDM_FILE_PREFIX%_%MDM_LOGFILE_SFX%.log
@rem end of log file name construction ---------------------------
@rem log startup
set EMPTY_LINE=*
echo %EMPTY_LINE% >> %MDM_LOGFILE%

echo * ENTERED %MDM_FILE_PREFIX% script - %DATE% %TIME% **************************************************** >> %MDM_LOGFILE%

echo %EMPTY_LINE% >> %MDM_LOGFILE%

@rem get username and pwd if passed in as argument
set "NOVALUE_STR=!xzy*zzx@"

set "MDM_USERNAME=%NOVALUE_STR%"
set "MDM_PASSWORD=%NOVALUE_STR%"

@rem get username pwd from command line if exists
GOTO :GET_USERID

@rem check if username pwd is in the command line
:CHECK_USERID
@rem get the username pwd if passed in
set MDM_USERID_OK="true"
if "!MDM_USERNAME!" == ""  (
   set MDM_USERID_OK="false"
)
if "!MDM_PASSWORD!" == ""  (
   set MDM_USERID_OK="false"
)
if "!MDM_USERNAME!" == "%NOVALUE_STR%"  (
   set MDM_USERID_OK="false"
)
if "!MDM_PASSWORD!" == "%NOVALUE_STR%"  (
   set MDM_USERID_OK="false"
) 

@rem if username pwd not passed in, attempt to get from env script
if %MDM_USERID_OK% == "false" (
   @rem if user id password not entered as argument get from environment file
   if exist "%MDM_ENV_SCRIPT%" (
        call %MDM_ENV_SCRIPT%
   )
)

@rem if found username pwd set it, not in env script wripe it out -- no username and pwd
if "!MDM_USERNAME!" == "%NOVALUE_STR%" (
   set MDM_ARG1=
   set MDM_VAL1=
) else (
   set "MDM_ARG1=-username"
   set "MDM_VAL1=!MDM_USERNAME!"
)
if "!MDM_PASSWORD!" == "%NOVALUE_STR%" (
   set MDM_ARG2=
   set MDM_VAL2=
) else (
   set "MDM_ARG2=-password"
   set "MDM_VAL2=!MDM_PASSWORD!"
)

@rem get remaining arguments entered as command line
GOTO :GET_ARGS

:CONTINUE
@rem save original directory
set SAVE_DIR=%CD%
@rem change to script directory
cd "%MDM_SCRIPTS_DIR%"

@rem setup the MDM_PREFERRED_RETCODE
if "%NOVALUE_STR%%MDM_PREFERRED_RETCODE%" == "%NOVALUE_STR%" (
   set "MDM_PREFERRED_RETCODE="
) else (
   set "MDM_PREFERRED_RETCODE=-mdmprefreturncode %MDM_PREFERRED_RETCODE%"
)

@rem delete logs older than MDM_LOGFILE_RETN_DAYS day(s)
if "%MDM_LOGFILE_RETN_DAYS%" neq "0" (
    echo [%DATE% %TIME%] Removing log files older than %MDM_LOGFILE_RETN_DAYS% day^(s^) from directory %MDM_LOGFILE_DIR% >> %MDM_LOGFILE%
    forfiles -p "%MDM_LOGFILE_DIR%" -s -m %MDM_FILE_PREFIX%*.log /D -%MDM_LOGFILE_RETN_DAYS% /C "cmd /c del @path" 1>>%MDM_LOGFILE% 2>>&1
    if %ERRORLEVEL% neq 0 (
        echo [%DATE% %TIME%] No files found for deletion >> %MDM_LOGFILE%
    )
    echo [%DATE% %TIME%] Completed removal of old log files >> %MDM_LOGFILE% 
)

@rem construct command line to execute java with class
set "CMD_LINE=%MDM_EXECUTE_BATCH_CLASS% %MDM_ARG1% %MDM_VAL1% %MDM_ARG2% ******** !MDM_ARGN! %MDM_CONNECTION_PROPERTIES% %MDM_PREFERRED_RETCODE%"
echo [%DATE% %TIME%] Executing Command line java %CMD_LINE% >> %MDM_LOGFILE%


@rem INVOKE JAVA TO EXECUTE MDMExecuteBatch.class -- redirect the STDOUT and STDERR to log file
java %MDM_EXECUTE_BATCH_CLASS% %MDM_ARG1% %MDM_VAL1% %MDM_ARG2% %MDM_VAL2% !MDM_ARGN! %MDM_CONNECTION_PROPERTIES% %MDM_PREFERRED_RETCODE% 1>> %MDM_LOGFILE% 2>>&1


@rem get and save return code
set "MDM_RC=%ERRORLEVEL%"

echo [%DATE% %TIME%] Returned from %MDM_EXECUTE_BATCH_CLASS% >> %MDM_LOGFILE%

@rem restore original directory
cd %SAVE_DIR%

@rem check for errors and return error code
if %MDM_RC%==0 GOTO SUCCESS

echo [%DATE% %TIME%] %MDM_EXECUTE_BATCH_CLASS%, exit with return code = %MDM_RC% >> %MDM_LOGFILE%
exit /B %MDM_RC%

:SUCCESS
@rem return 0 for success
echo [%DATE% %TIME%] %MDM_EXECUTE_BATCH_CLASS% completed successfully, exit with return code = %MDM_RC% >> %MDM_LOGFILE%
exit /B %MDM_RC%

:GET_USERID
set pwd_ind=0
set usrnm_ind=0
for %%I in (%*) do (
      if !pwd_ind! == 1 (
	set "MDM_PASSWORD=%%I"
        set pwd_ind="0"
      )
      if "%%I" == "-password" (
         set pwd_ind=1
      )
      if !usrnm_ind! == 1 (
	 set "MDM_USERNAME=%%I"
	 set usrnm_ind=0
      )
      if "%%I" == "-username" (
	 set usrnm_ind=1
      )
)
GOTO :CHECK_USERID

:GET_ARGS
set skip=0
for %%I in (%*) do (
      if "%%I" neq "-password"  (
	 if "%%I" neq "-username"  (
	     if !skip! == 0 (
		 set "MDM_ARGN=!MDM_ARGN! %%I"
             )
	 )
      )
      set skip=0
      if "%%I" == "-password" (
      	set skip=1
      )
      if "%%I" == "-username" (
        set skip=1
      )    
)
GOTO :CONTINUE

ENDLOCAL