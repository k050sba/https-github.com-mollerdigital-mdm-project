#!/bin/bash
# ------------------------------------------------------------------------------
# file/directory information -  MUST BE ADJUSTED FOR IMPLEMENTATION
# environment variables from script:
 . ./mdm_exec_batch_proc_env.sh
 

# if log directory does not exist, create it
if [ ! -d "$MDM_LOGFILE_DIR" ]; then
   mkdir "$MDM_LOGFILE_DIR"
fi
# construct log file name using time
CURDATE=`date +%Y-%m-%d`
MDM_LOGFILE="${MDM_LOGFILE_DIR}/${MDM_FILE_PREFIX}_${CURDATE}.log"
#
# redirect all echo to file name in env variable $MRM_LOGFILE
EMPTY_LINE="*"
echo "$EMPTY_LINE" >> "$MDM_LOGFILE"
echo "* ENTERED ${MDM_FILE_PREFIX} script - `date +%Y-%m-%d\ %H:%M:%S` ****************************************************" >> "$MDM_LOGFILE"
echo "$EMPTY_LINE" >> "$MDM_LOGFILE"

# get username and pwd if passed in as argument
MDM_USERNAME=""
MDM_PASSWORD=""
# loop thru command line and extract username and password
PREV_ARG=""
for arg in { "$@" }
do
  if [ -n "$PREV_ARG" ]; then  
  	  if [ "${PREV_ARG}" == "-password" ]; then
  	      MDM_PASSWORD="${arg}"
  	      PREV_ARG=""
 	        continue 
      fi
      if [ "${PREV_ARG}" == "-username" ]; then
          MDM_USERNAME="${arg}"
          PREV_ARG=""
          continue 
      fi
  fi
	if [ "${arg}" == "-password" ]; then
		  PREV_ARG="${arg}"
		  continue
	fi
	if [ "${arg}" == "-username" ]; then
	    PREV_ARG="${arg}"
	    continue 
	fi
done

# if either username password is missing attempt to get if from env script
if [ -z "${MDM_USERNAME}" ] || [ -z "${MDM_PASSWORD}" ]; then
#  if file exist executed 
	  if [ -a "${MDM_ENV_SCRIPT}" ]; then
	  	. "${MDM_ENV_SCRIPT}"
	  fi
fi
# setup the username if exits
if [ -z "${MDM_USERNAME}" ]; then
	  MDM_ARG1=""
    MDM_VAL1=""
else
    MDM_ARG1="-username"
    MDM_VAL1="${MDM_USERNAME}"
fi
if [ -z "${MDM_PASSWORD}" ]; then
	  MDM_ARG2=""
    MDM_VAL2=""
else
    MDM_ARG2="-password"
    MDM_VAL2="${MDM_PASSWORD}"
fi
# construct the remaining arguments passed in
MDM_ARGN=""
for arg in { "$@" }
do
   if [ "${arg}" != "-password" ]; then
  	  if [ "${arg}" != "-username" ]; then
  	  	  if [ -z "${PREV_ARG}" ]; then
  	  	     VAL="${arg}"
  	  	     # add leading and trail double quotes to value if there are spaces
  	  	     if echo "${VAL}" | egrep -q "[[:space:]]"; then 
  	  	     	  VAL="\"${VAL}\""
  	  	     fi
   	  	  	 MDM_ARGN="${MDM_ARGN} ${VAL}"
   	  	  	 continue
  	  	  else
  	  	     PREV_ARG=""
  	  	     continue
  	  	  fi  	  	  
  	  fi
  fi
	if [ "${arg}" == "-password" ] || [ "${arg}" == "-username" ]; then
		  PREV_ARG="skip"
		  continue
	fi
	if [ "${arg}" == "\{" ] || [ "${arg}" == "\}" ]; then
	    PREV_ARG="skip"
	    continue 
	fi
done
# remove leading { and trailing } if exists
MDM_ARGN=`echo ${MDM_ARGN} | tr "{" " "`
MDM_ARGN=`echo ${MDM_ARGN} | tr "}" " "`

# setup the preferred return code from environment variable
if [ -z "${MDM_PREFERRED_RETCODE}" ]; then
	  MDM_PREFERRED_RETCODE=""
else
	  MDM_PREFERRED_RETCODE="-mdmprefreturncode ${MDM_PREFERRED_RETCODE}"
fi

# remove old log files
if [ "$MDM_LOGFILE_RETN_DAYS" != "0" ]; then
	 echo "[`date +%Y-%m-%d\ %H:%M:%S`] Removing log files older than $MDM_LOGFILE_RETN_DAYS day(s) from directory $MDM_LOGFILE_DIR" >> "$MDM_LOGFILE"
         find "${MDM_LOGFILE_DIR}" -name ${MDM_FILE_PREFIX}*.log -mtime +$MDM_LOGFILE_RETN_DAYS -exec rm {} \;
   echo "[`date +%Y-%m-%d\ %H:%M:%S`] Completed removal of old log files" >> "$MDM_LOGFILE"
fi

# save original user working directory
SAVE_DIR=`pwd`
# change current working directory to script directory
cd "${MDM_SCRIPTS_DIR}"

# construct command line to execute java with class
CMD_LINE="${MDM_EXECUTE_BATCH_CLASS} ${MDM_ARG1} ${MDM_VAL1} ${MDM_ARG2} ******** ${MDM_ARGN} ${MDM_CONNECTION_PROPERTIES} ${MDM_PREFERRED_RETCODE}"
echo "[`date +%Y-%m-%d\ %H:%M:%S`] Executing Command line java $MDM_EXECUTE_BATCH_CLASS $CMD_LINE" >> "$MDM_LOGFILE"

# INVOKE JAVA TO EXECUTE MDMExecuteBatch.class -- redirect the STDOUT and STDERR to log file
java $MDM_EXECUTE_BATCH_CLASS $MDM_ARG1 $MDM_VAL1 $MDM_ARG2 $MDM_VAL2 $MDM_ARGN $MDM_CONNECTION_PROPERTIES $MDM_PREFERRED_RETCODE >> "${MDM_LOGFILE}" 2>&1 

# get and save return code
MDM_RC=$?

echo "[`date +%Y-%m-%d\ %H:%M:%S`] Returned from ${MDM_EXECUTE_BATCH_CLASS}" >> "$MDM_LOGFILE"

# restore original directory
cd "$SAVE_DIR"

# exit with return code
echo "[`date +%Y-%m-%d\ %H:%M:%S`] ${MDM_EXECUTE_BATCH_CLASS} Return Code: $MDM_RC" >> "$MDM_LOGFILE"
if [ $MDM_RC -eq 0 ]; then
   echo "[`date +%Y-%m-%d\ %H:%M:%S`] ${MDM_EXECUTE_BATCH_CLASS} completed successfully, exit with return code = $MDM_RC" >> "$MDM_LOGFILE"
   exit 0
else
   echo "[`date +%Y-%m-%d\ %H:%M:%S`] ${MDM_EXECUTE_BATCH_CLASS} Failed, exit with return code = $MDM_RC" >> "$MDM_LOGFILE"
   exit $MDM_RC
fi
