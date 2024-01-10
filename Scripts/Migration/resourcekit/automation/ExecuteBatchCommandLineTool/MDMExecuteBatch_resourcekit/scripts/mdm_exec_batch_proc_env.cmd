@ECHO OFF
@rem MDM Version 9.7.1 base
@rem file/directory information -  MUST BE ADJUSTED FOR IMPLEMENTATION

set "MDM_SCRIPTS_HOME=D:\Scripts\Migration\resourcekit\automation\ExecuteBatchCommandLineTool\MDMExecuteBatch_resourcekit"
set "MDM_SCRIPTS_DIR=%MDM_SCRIPTS_HOME%\scripts"
set "MDM_CONNECT_PROPS_DIR=%MDM_SCRIPTS_HOME%\scripts"
set "MDM_ENV_SCRIPT=%MDM_SCRIPTS_DIR%\mdm_exec_batch_proc_env.cmd"
set "MDM_LOGFILE_DIR=%MDM_SCRIPTS_HOME%\logs"

set MDM_FILE_PREFIX=mdm_exec_batch_proc
set MDM_LOGFILE_RETN_DAYS=10
set "MDM_EXECUTE_BATCH_CLASS=com.informatica.mdm.tools.MDMExecuteBatch"

@rem PATH and CLASSPATH -- MUST BE ADJUSTED FOR IMPLEMENTATION 
@rem set PATH and Class Path

set "PATH=C:\Program Files\Java\jdk1.8.0_181\jre\bin;%PATH%"
set "CLASSPATH=%MDM_SCRIPTS_HOME%\lib\*"

@rem mdm username and password -- MUST BE ADJUSTED FOR IMPLEMENTATION 

set MDM_USERNAME=admin
set MDM_PASSWORD=A75FCFBCB375F229

@rem MDM Preferred Return Code:  Options: JOB_RUN_STATUS or JOB_RUN_RETURN_CODE . 
@rem Default: JOB_RUN_STATUS.  If spelled incorrectly, defaults to JOB_RUN_STATUS

set "MDM_PREFERRED_RETCODE=JOB_RUN_STATUS"

@rem the SiperianConnection.properties. To override loading from the root of the classpath
@rem MUST BE ADJUSTED FOR IMPLEMENTATION 
@rem -mdmconnectionproperties
 
set "MDM_CONNECTION_PROPERTIES=-mdmconnectionproperties "%MDM_CONNECT_PROPS_DIR%\SiperianConnection.properties""
