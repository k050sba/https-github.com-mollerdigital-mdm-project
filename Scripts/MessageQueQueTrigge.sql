USE MDM_CM;

DECLARE @varSentMessage          INT,
        @recordSentMessage      INT = 500;

BEGIN
     
    SELECT @varSentMessage = Count(1)
    FROM   MDM_CUSTOM..C_REPOS_MQ_DATA_CHANG_backup,C_REPOS_TABLE
					where
					C_REPOS_TABLE.ROWID_TABLE=C_REPOS_MQ_DATA_CHANG_backup.ROWID_TABLE
					and TABLE_NAME='C_REL_PARTY_CAR'
					and CHANGE_TYPE in(1,2,4)
					and Flag=0;

    IF ( @varSentMessage> 1 )
      BEGIN
                   update  TOP(@recordSentMessage)MDM_CUSTOM..C_REPOS_MQ_DATA_CHANG_backup 
				   set flag=1
					where ROWID_MQ_DATA_CHANGE in(
					select ROWID_MQ_DATA_CHANGE from MDM_CUSTOM..C_REPOS_MQ_DATA_CHANG_backup,C_REPOS_TABLE
					where
					C_REPOS_TABLE.ROWID_TABLE=C_REPOS_MQ_DATA_CHANG_backup.ROWID_TABLE
					and TABLE_NAME='C_REL_PARTY_CAR'
					and CHANGE_TYPE in(1,2,4)
					and Flag=0);

				update C_REPOS_MQ_DATA_CHANGE set SENT_STATE_ID=0 
				--select * from C_REPOS_MQ_DATA_CHANGE
				where ROWID_MQ_DATA_CHANGE in(
				select ROWID_MQ_DATA_CHANGE from MDM_CUSTOM..C_REPOS_MQ_DATA_CHANG_backup,C_REPOS_TABLE
				where
				C_REPOS_TABLE.ROWID_TABLE=C_REPOS_MQ_DATA_CHANG_backup.ROWID_TABLE
				and TABLE_NAME='C_REL_PARTY_CAR'
				and CHANGE_TYPE in(1,2,4)
				and Flag=1
				) and SENT_STATE_ID=9

						  UPDATE mdm_custom..C_REPOS_MQ_DATA_CHANG_backup
						  SET    flag = 2
						  WHERE  flag = 1;

      END
    
    
END 