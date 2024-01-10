
USE MDM_CM;

DECLARE @varClose             INT,
        @recordsClose         INT = 500;
        

BEGIN
    
    SELECT @varClose = Count(1)
    FROM   MDM_CUSTOM..VATNUMBER_UPDATION_NO
    WHERE  load_flg = '0';


    IF ( @varClose > 1 )
      BEGIN
          UPDATE TOP(@recordsClose) MDM_CUSTOM..VATNUMBER_UPDATION_NO
          SET    load_flg = 1
          WHERE  load_flg = 0;

          DELETE FROM mdm_cm..C_S_MDM_ORG_VATNO_UPDATE;
 PRINT( 'deleted the records' )
          insert into  
		  MDM_CM..C_S_MDM_ORG_VATNO_UPDATE(PKEY_SRC_OBJECT,ROWID_OBJECT,VERSION_SEQ,LAST_UPDATE_DATE,HUB_STATE_IND,SRC_ROWID,VAT_NUMBER)
			select distinct CONCAT(rtrim(vat.ROWID_OBJECT),'|MDM|INSERT|'),vat.ROWID_OBJECT,1,GETDATE(),1,'MDM',				vat.VAT_NUMBER
					from MDM_Custom..VATNUMBER_UPDATION_NO vat
					WHERE  load_flg=1;

          UPDATE mdm_custom..VATNUMBER_UPDATION_NO
          SET    load_flg = 2
          WHERE  load_flg = 1;
		 
		  
	END
    
    
END 
