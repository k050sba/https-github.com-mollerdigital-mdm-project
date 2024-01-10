USE MDM_CM;
update top(500) C_S_DF_PERSON_LOAD set load_flg=1 where load_flg=0;

delete from mdm_cm..C_S_DF_PERSON;

INSERT INTO mdm_cm..C_S_DF_PERSON
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
      ,[FIRST_NAME]
      ,[PARTY_ID]
      ,[MIDDLE_NAME]
      ,[SURNAME])
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
      ,[FIRST_NAME]
      ,[PARTY_ID]
      ,[MIDDLE_NAME]
      ,[SURNAME]
from 
C_S_DF_PERSON_LOAD where load_flg=1;

update C_S_DF_PERSON_LOAD set load_flg=2 where load_flg=1;
