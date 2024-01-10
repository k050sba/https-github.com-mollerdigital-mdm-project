
USE MDM_CM;

DECLARE @varClose             INT,
        @recordsClose         INT = 500;
        

BEGIN
    
    SELECT @varClose = Count(1)
    FROM   MDM_CUSTOM..SVA_DEALER
    WHERE  load_flg = '0';


    IF ( @varClose > 1 )
      BEGIN
          UPDATE TOP(@recordsClose) MDM_CUSTOM..SVA_DEALER
          SET    load_flg = 1
          WHERE  load_flg = 0;

          DELETE FROM mdm_cm..[C_S_MDM_SAP_PARTY_DEALER];
 PRINT( 'deleted the records' )
          insert into  
		  MDM_CM..[C_S_MDM_SAP_PARTY_DEALER]([PKEY_SRC_OBJECT],[VERSION_SEQ],[LAST_UPDATE_DATE],[SRC_ROWID],[PARTY_ID],[DEALER_ID]  ,[RELATION_START_DATE],[RELATION_END_DATE],[STATUS_CODE])
			select [PKEY_SRC_OBJECT],[VERSION_SEQ],[LAST_UPDATE_DATE],[SRC_ROWID],[PARTY_ID],[DEALER_ID]  ,[RELATION_START_DATE],[RELATION_END_DATE],[STATUS_CODE]
					from MDM_CUSTOM..SVA_DEALER SVA
					WHERE  load_flg=1;

          UPDATE MDM_CUSTOM..SVA_DEALER
          SET    load_flg = 2
          WHERE  load_flg = 1;
		 
		  
	END
    
    
END 
