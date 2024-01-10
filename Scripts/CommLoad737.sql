delete from mdm_cm..[C_S_MDM_COMMUNI];

update top(600) mdm_custom..TMP_C_S_MDM_COMMUNI set ROWNO=1 WHERE ROWNO=0;

INSERT INTO mdm_cm..[C_S_MDM_COMMUNI]
           ([PKEY_SRC_OBJECT]
           ,[VERSION_SEQ]
           ,[LAST_UPDATE_DATE]
           ,[SRC_ROWID]
           ,[HUB_STATE_IND]
           ,[COMMUNICATION_CHANNEL_ID]
           ,[PARTY_ID]
           ,[RELATION_START_DATE]
           ,[BRAND_ID]
           ,[ACTIVE_PREFERENCE_FLAG]
           ,[STATUS_CODE])
select [PKEY_SRC_OBJECT]
           ,[VERSION_SEQ]
           ,[LAST_UPDATE_DATE]
           ,[SRC_ROWID]
           ,[HUB_STATE_IND]
           ,[COMMUNICATION_CHANNEL_ID]
           ,[PARTY_ID]
           ,[RELATION_START_DATE]
           ,[BRAND_ID]
           ,[ACTIVE_PREFERENCE_FLAG]
           ,[STATUS_CODE] from mdm_custom..TMP_C_S_MDM_COMMUNI where ROWNO=1;

update mdm_custom..TMP_C_S_MDM_COMMUNI set ROWNO=2 WHERE ROWNO=1;