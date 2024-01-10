#!/bin/bash

MDM_SCRIPTS_DIR="/apps/mdm_exec_batch_process/scripts"

# Save user's current working directory
SAVE_DIR=`pwd`

#  directory change to script directory
cd "$MDM_SCRIPTS_DIR"

RETURN_CODE=0

# Execute the step.  Check return code. If not zero, restore directory
# and exit passing the return code

./mdm_exec_batch_proc.sh -action stage -tablename C_STG_IMS_PROD_MSTR
RETURN_CODE=$?
if [ $RETURN_CODE != 0 ]; then
	cd "$SAVE_DIR"
  exit $RETURN_CODE 
fi

./mdm_exec_batch_proc.sh -action load -tablename C_STG_IMS_PROD_MSTR
RETURN_CODE=$?
if [ $RETURN_CODE != 0 ]; then 
	cd "$SAVE_DIR"
  exit $RETURN_CODE 
fi

./mdm_exec_batch_proc.sh -action stage -tablename C_STG_CMN_PROD_MSTR
RETURN_CODE=$?
if [ $RETURN_CODE != 0 ]; then 
	cd "$SAVE_DIR"
  exit $RETURN_CODE 
fi

./mdm_exec_batch_proc.sh -action load -tablename C_STG_CMN_PROD_MSTR
RETURN_CODE=$?
if [ $RETURN_CODE != 0 ]; then 
	cd "$SAVE_DIR"
  exit $RETURN_CODE 
fi

./mdm_exec_batch_proc.sh -action execbatchgroup -batchgroupname "bg stg ims" -resume true
RETURN_CODE=$?
if [ $RETURN_CODE != 0 ]; then 
	cd "$SAVE_DIR"
  exit $RETURN_CODE 
fi

./mdm_exec_batch_proc.sh -action automatchmerge -tablename C_BO_PROD_MSTR
RETURN_CODE=$?
if [ $RETURN_CODE != 0 ]; then 
	cd "$SAVE_DIR"
  exit $RETURN_CODE 
fi

# Do a final tokenize
./mdm_exec_batch_proc.sh -action tokenize -tablename C_BO_PROD_MSTR
RETURN_CODE=$?
if [ $RETURN_CODE != 0 ]; then 
	cd "$SAVE_DIR"
  exit $RETURN_CODE 
fi

# successful completion exit
# All step executed successfully, restore user's directory, exit with return code
cd "$SAVE_DIR"
exit $RETURN_CODE
