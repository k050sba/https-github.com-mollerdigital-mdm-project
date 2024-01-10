USE MDM_CM;

DECLARE @varClose             INT,
        @varActivate          INT,
        @varCloseActivate     INT,
        @recordsClose         INT = 500,
        @recordsActivate      INT = 500,
        @recordsCloseActivate INT = 250,
        @category             VARCHAR(50);

BEGIN
    PRINT( 'Close' )

    SELECT @varClose = Count(1)
    FROM   mdm_custom..df_car_load
    WHERE  category in ( 'Close','Close and Activate')
	       and role_code ='L'
           AND load_flg = '0';

    PRINT( 'Activate' )

    SELECT @varActivate = Count(1)
    FROM   mdm_custom..df_car_load
    WHERE  category in ( 'Activate','Close and Activate')
	       and role_code ='L'
           AND load_flg = '0';



    IF ( @varClose > 1 )
      BEGIN
          UPDATE TOP(@recordsClose) mdm_custom..df_car_load
          SET    load_flg = 1
          WHERE  load_flg = 0
                 AND category in ( 'Close','Close and Activate')
				 and role_code= 'L';

          DELETE FROM mdm_cm..C_S_DF_CAR_REL_CLOSE_LES;

          INSERT INTO C_S_DF_CAR_REL_CLOSE_LES
                      ([pkey_src_object],
                       [rowid_object],
                       [deleted_ind],
                       [deleted_date],
                       [deleted_by],
                       [period_start_date],
                       [period_end_date],
                       [version_seq],
                       [period_reference_time],
                       [timeline_action],
                       [last_update_date],
                       [updated_by],
                       [create_date],
                       [creator],
                       [src_rowid],
                       [hub_state_ind],
                       [relation_end_date],
                       [status_code])
          SELECT [pkey_src_object],
                 [rowid_object],
                 [deleted_ind],
                 [deleted_date],
                 [deleted_by],
                 [period_start_date],
                 [period_end_date],
                 [version_seq],
                 [period_reference_time],
                 [timeline_action],
                 [last_update_date],
                 [updated_by],
                 [create_date],
                 [creator],
                 [src_rowid],
                 [hub_state_ind],
                 [relation_end_date],
                 [status_code]
          FROM   mdm_custom..C_S_DF_CAR_REL_CLOSE_LES
          WHERE  car_id IN (SELECT car_id
                            FROM   mdm_custom..df_car_load
                            WHERE  load_flg = '1'
                                   AND category in ( 'Close','Close and Activate')
								   and role_code ='L');

          UPDATE mdm_custom..df_car_load
          SET    load_flg = 2
          WHERE  load_flg = 1
                 AND category in ( 'Close','Close and Activate')
				 and role_code = 'L';
      END
    
    
END 
