delete from MDM_CM..[C_S_MDM_ADDRESS];

update top(500) mdm_custom..tmp_c_s_mdm_address1702
set HUB_STATE_IND=1
where HUB_STATE_IND=0;

INSERT INTO MDM_CM..[C_S_MDM_ADDRESS]
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
           ,[POSTAL_CODE]
           ,[CARE_OF]
           ,[CITY]
           ,[COUNTRY_ISO2_CODE])
select * from mdm_custom..tmp_c_s_mdm_address1702 where HUB_STATE_IND=1;

delete from mdm_custom..tmp_c_s_mdm_address1702 where HUB_STATE_IND=1;