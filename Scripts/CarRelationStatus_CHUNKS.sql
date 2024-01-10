
USE MDM_CM;

DECLARE @varClose             INT,
        @recordsClose         INT = 500;
        

BEGIN
    
    SELECT @varClose = Count(1)
    FROM   MDM_CUSTOM..C_S_MDM_PARTY_CAR_REL_UPDATE
    WHERE  load_flg = '0';


    IF ( @varClose > 1 )
      BEGIN
          UPDATE TOP(@recordsClose) MDM_CUSTOM..C_S_MDM_PARTY_CAR_REL_UPDATE
          SET    load_flg = 1
          WHERE  load_flg = 0;

          DELETE FROM mdm_cm..C_S_MDM_PARTY_CAR_REL;
 PRINT( 'deleted the records' )
          insert into  
		  MDM_CM..C_S_MDM_PARTY_CAR_REL([PKEY_SRC_OBJECT]
           ,[ROWID_OBJECT]
           ,[VERSION_SEQ]
           ,[LAST_UPDATE_DATE]
           ,[SRC_ROWID]
           ,[STATUS_CODE])
			select 		distinct		PKEY_SRC_OBJECT,ROWID_OBJECT,'1',GETDATE(),'MDM', STATUS_CODE
					from MDM_Custom..C_S_MDM_PARTY_CAR_REL_UPDATE vat
					WHERE  load_flg=1;

          UPDATE mdm_custom..C_S_MDM_PARTY_CAR_REL_UPDATE
          SET    load_flg = 2
          WHERE  load_flg = 1;
		 
		  
	END
    
    
END 
