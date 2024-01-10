USE MDM_CM;

DECLARE @varActivate          INT,
        @recordsActivate      INT = 500;

BEGIN
     PRINT( 'Activate' )

    SELECT @varActivate = Count(1)
    FROM   mdm_custom..C_S_DF_CAR_REL_ACTIVATE_06102021
    WHERE  load_flg = '0';

    IF ( @varActivate> 1 )
      BEGIN
         UPDATE TOP(@recordsActivate) mdm_custom..C_S_DF_CAR_REL_ACTIVATE_06102021
          SET    load_flg = 1
          WHERE  load_flg = 0;

          DELETE FROM mdm_cm..c_s_df_car_rel_activate;

          INSERT INTO c_s_df_car_rel_activate
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
                       [relation_start_date],
                       [relation_end_date],
                       [party_id],
                       [car_id],
                       [role_code],
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
                 [relation_start_date],
                 [relation_end_date],
                 [party_id],
                 [car_id],
                 [role_code],
                 [status_code]
          FROM   mdm_custom..C_S_DF_CAR_REL_ACTIVATE_06102021
          WHERE  load_flg = 1;

          UPDATE mdm_custom..C_S_DF_CAR_REL_ACTIVATE_06102021
          SET    load_flg = 2
          WHERE  load_flg = 1;

      END
    
    
END 