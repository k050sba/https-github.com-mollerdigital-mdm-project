USE MDM_CM;

update top(500) MDM_CM..[C_S_DF_PHONE_LOAD] set load_flg=1 where load_flg=0;

delete from mdm_cm..[C_S_DF_PHONE];

INSERT INTO mdm_cm..C_S_DF_PHONE
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
      ,[PARTY_ID]
      ,[PHONE_NUMBER]
      ,[TYPE]
      ,[PHONE_COUNTRY]
      ,[RELATION_START_DATE]
      ,[RELATION_END_DATE])
select 
[PKEY_SRC_OBJECT]
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
      ,[PARTY_ID]
      ,[PHONE_NUMBER]
      ,[TYPE]
      ,[PHONE_COUNTRY]
      ,[RELATION_START_DATE]
      ,[RELATION_END_DATE]
from 
[C_S_DF_PHONE_LOAD] where load_flg=1;

update [C_S_DF_PHONE_LOAD] set load_flg=2 where load_flg=1;
