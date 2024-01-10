#!/bin/bash
# ------------------------------------------------------------------------------
# MDM Version 9.7.1 base
# file/directory information -  MUST BE ADJUSTED FOR IMPLEMENTATION

MDM_SCRIPTS_HOME="/apps/mdm_exec_batch_process"
MDM_SCRIPTS_DIR="${MDM_SCRIPTS_HOME}/scripts"
MDM_CONNECT_PROPS_DIR="${MDM_SCRIPTS_HOME}/scripts"
MDM_ENV_SCRIPT="${MDM_SCRIPTS_DIR}/mdm_exec_batch_proc_env.sh"
MDM_LOGFILE_DIR="${MDM_SCRIPTS_HOME}/logs"

MDM_FILE_PREFIX=mdm_exec_batch_proc
MDM_LOGFILE_RETN_DAYS=10
MDM_EXECUTE_BATCH_CLASS="com.informatica.mdm.tools.MDMExecuteBatch"

# PATH and CLASSPATH -- MUST BE ADJUSTED FOR IMPLEMENTATION 
# set java bin directory (jdk or jre) in PATH and set CLASSPATH

PATH=/apps/jdk1.7.0_45/jre/bin:${PATH}
CLASSPATH=${MDM_SCRIPTS_HOME}/lib/*
export CLASSPATH

# mdm username and password
MDM_USERNAME=batch_process
MDM_PASSWORD=CD7FE5ADDCDD692EF6A1CB907DAB6151

# MDM Preferred Return Code:  Options: JOB_RUN_STATUS or JOB_RUN_RETURN_CODE . 
# Default: JOB_RUN_STATUS.  If spelled incorrectly, defaults to JOB_RUN_STATUS

MDM_PREFERRED_RETCODE="JOB_RUN_STATUS"

# the SiperianConnection.properties. To override loading from the root of the classpath
# -mdmconnectionproperties <path with the properties file name> -  use quotes with escape char \
MDM_CONNECTION_PROPERTIES="-mdmconnectionproperties \"${MDM_CONNECT_PROPS_DIR}/SiperianConnection.properties\""
