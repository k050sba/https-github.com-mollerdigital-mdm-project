use MDM_CM; delete from C_S_DF_CAR_REL_ACT_LES where ROLE_CODE='L' and exists(select 1 from C_REL_PARTY_CAR where ROLE_CODE='L' and LAST_ROWID_SYSTEM not in('DATAFACTORY ') and RELATION_END_DATE is null and CAR_ID=(select ROWID_OBJECT from C_B_CAR where VEHICLE_IDENTIFICATION_NO=C_S_DF_CAR_REL_ACT_LES.CAR_ID));