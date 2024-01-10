@echo off

@rem script dir
set "MDM_SCRIPTS_DIR=C:\Users\cgoon\Documents\Sip_Tools\mdm_exec_batch_process\scripts"


@rem Save user's current working directory
set SAVE_DIR=%CD%

@rem  directory change to script directory
cd %MDM_SCRIPTS_DIR%

set RETURN_CODE=0

@rem  Execute the step.  Check return code. If not zero, restore directory
@rem  and exit passing the return code

call mdm_exec_batch_proc.cmd -action stage -tablename C_STG_IMS_PROD_MSTR
set RETURN_CODE=%ERRORLEVEL%
if %RETURN_CODE% NEQ 0 GOTO :FAILURE

call mdm_exec_batch_proc.cmd -action load -tablename C_STG_IMS_PROD_MSTR
set RETURN_CODE=%ERRORLEVEL%
if %RETURN_CODE% NEQ 0 GOTO :FAILURE

call mdm_exec_batch_proc.cmd -action stage -tablename C_STG_CMN_PROD_MSTR
set RETURN_CODE=%ERRORLEVEL%
if %RETURN_CODE% NEQ 0 GOTO :FAILURE

call mdm_exec_batch_proc.cmd -action load -tablename C_STG_CMN_PROD_MSTR
set RETURN_CODE=%ERRORLEVEL%
if %RETURN_CODE% NEQ 0 GOTO :FAILURE

call mdm_exec_batch_proc.cmd -action execbatchgroup -batchgroupname "bg stg ims" -resume true
set RETURN_CODE=%ERRORLEVEL%
if %RETURN_CODE% NEQ 0 GOTO :FAILURE

call mdm_exec_batch_proc.cmd -action automatchmerge -tablename C_BO_PROD_MSTR
set RETURN_CODE=%ERRORLEVEL%
if %RETURN_CODE% NEQ 0 GOTO :FAILURE

@rem Do a final tokenize
call mdm_exec_batch_proc.cmd -action tokenize -tablename C_BO_PROD_MSTR
set RETURN_CODE=%ERRORLEVEL%
if %RETURN_CODE% NEQ 0 GOTO :FAILURE


@rem successful completion exit
@rem All step executed successfully, restore user's directory, exit with return code
cd %SAVE_DIR%
exit /B %RETURN_CODE%

@rem **************  failure exit
:FAILURE
@rem Restore user's directoty and exit with return code
cd %SAVE_DIR%
exit /B %RETURN_CODE%
