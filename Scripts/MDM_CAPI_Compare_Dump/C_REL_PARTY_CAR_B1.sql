SET NOCOUNT ON; select  * from C_REL_PARTY_CAR as C_REL_PARTY_CAR_B1 where exists(select 1 from C_B_PARTY where TYPE in('P','O') and COUNTRY_CODE in('NO', 'EE', 'LV', 'LT') and HUB_STATE_IND=1 and C_REL_PARTY_CAR_B1.PARTY_ID=C_B_PARTY.ROWID_OBJECT) and ROLE_CODE='B' and STATUS_CODE=1 and HUB_STATE_IND=1 ORDER BY CAST(ROWID_OBJECT AS INT)