USE MDM_CM;

update top(700) C_S_DF_ADDRESS_LOAD set load_flg=1 where load_flg=0;

TRUNCATE TABLE C_S_DF_ADDRESS;


INSERT INTO mdm_cm..[C_S_DF_ADDRESS]
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
      ,[ADDRESS_LINE_1]
      ,[ADDRESS_LINE2]
      ,[CARE_OF]
      ,[CITY]
      ,[POSTAL_CODE]
      ,[COUNTRY_ISO2_CODE]
      ,[PO_BOX]
      ,[PO_BOX_LOBBY]
      ,[PO_BOX_POSTAL_CITY]
      ,[PO_BOX_POSTAL_CODE]
      ,[REGION])
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
      ,[ADDRESS_LINE_1]
      ,[ADDRESS_LINE2]
      ,[CARE_OF]
      ,[CITY]
      ,[POSTAL_CODE]
      ,[COUNTRY_ISO2_CODE]
      ,[PO_BOX]
      ,[PO_BOX_LOBBY]
      ,[PO_BOX_POSTAL_CITY]
      ,[PO_BOX_POSTAL_CODE]
      ,[REGION]
from 
C_S_DF_ADDRESS_LOAD 
where load_flg=1;


update C_S_DF_ADDRESS_LOAD set load_flg=2 where load_flg=1;