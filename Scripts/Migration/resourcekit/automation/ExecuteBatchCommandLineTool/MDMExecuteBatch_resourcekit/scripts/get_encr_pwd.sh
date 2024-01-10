#!/bin/bash
# Get the MDM encrypted password from clear test password

# set the java path (bin dir) if not set in you path
. ./mdm_exec_batch_proc_env.sh

KEY_TYPE=PASSWORD_KEY  
# or PASSWORD_KEY (DB_PASSWORD_KEY is the default)


if [ -z "$1" ]; then
   COMMD=`echo $0 | sed 's/.*\///'`
   echo Argument Error.  Usage: $COMMD \<password_string\>
   exit 1
fi

java com.siperian.common.security.Blowfish $KEY_TYPE $1
