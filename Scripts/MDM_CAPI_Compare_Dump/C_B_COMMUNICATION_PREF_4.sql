SET NOCOUNT ON; select * from C_B_COMMUNICATION_PREF as  C_B_COMMUNICATION_PREF_4 where exists(select 1 from C_B_PARTY where TYPE in('P','O') and COUNTRY_CODE in('NO', 'EE', 'LV', 'LT') and HUB_STATE_IND=1 and C_B_COMMUNICATION_PREF_4.PARTY_ID=C_B_PARTY.ROWID_OBJECT ) and BRAND_ID=4 and HUB_STATE_IND=1 order by CAST(ROWID_OBJECT as INT)