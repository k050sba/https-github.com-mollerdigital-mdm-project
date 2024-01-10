update top(1000) MDM_Custom..TMP_C_S_BRING_CAR_REL_NEW set load_flg=1 where load_flg=0;

delete from mdm_cm..[C_S_BRING_CAR_REL_NEW];

INSERT INTO mdm_cm..[C_S_BRING_CAR_REL_NEW]
           ([PKEY_SRC_OBJECT]
           ,[ROWID_OBJECT]
           ,[DELETED_IND]
           ,[DELETED_DATE]
           ,[DELETED_BY]
           ,[PERIOD_START_DATE]
           ,[PERIOD_END_DATE]
           ,[VERSION_SEQ]
           ,[PERIOD_REFERENCE_TIME]
           ,[TIMELINE_ACTION]
           ,[LAST_UPDATE_DATE]
           ,[UPDATED_BY]
           ,[CREATE_DATE]
           ,[CREATOR]
           ,[SRC_ROWID]
           ,[HUB_STATE_IND]
           ,[RELATION_END_DATE]
           ,[RELATION_START_DATE]
           ,[PARTY_ID]
           ,[CAR_ID]
           ,[ROLE_CODE]
           ,[STATUS_CODE])

		select [PKEY_SRC_OBJECT]
           ,[ROWID_OBJECT]
           ,[DELETED_IND]
           ,[DELETED_DATE]
           ,[DELETED_BY]
           ,[PERIOD_START_DATE]
           ,[PERIOD_END_DATE]
           ,[VERSION_SEQ]
           ,[PERIOD_REFERENCE_TIME]
           ,[TIMELINE_ACTION]
           ,[LAST_UPDATE_DATE]
           ,[UPDATED_BY]
           ,[CREATE_DATE]
           ,[CREATOR]
           ,[SRC_ROWID]
           ,[HUB_STATE_IND]
           ,[RELATION_END_DATE]
           ,[RELATION_START_DATE]
           ,[PARTY_ID]
           ,[CAR_ID]
           ,[ROLE_CODE]
           ,[STATUS_CODE] from MDM_Custom..TMP_C_S_BRING_CAR_REL_NEW
		   where load_flg='1';

update MDM_CUSTOM..TMP_C_S_BRING_CAR_REL_NEW set load_flg=2 where load_flg=1;
