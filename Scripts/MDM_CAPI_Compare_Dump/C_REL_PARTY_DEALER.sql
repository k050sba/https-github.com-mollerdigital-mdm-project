SET NOCOUNT ON; select  * from C_REL_PARTY_DEALER where exists(select 1 from C_B_PARTY where TYPE in('P','O') and COUNTRY_CODE in('NO', 'EE', 'LV', 'LT') and HUB_STATE_IND=1 and C_REL_PARTY_DEALER.PARTY_ID=C_B_PARTY.ROWID_OBJECT) and HUB_STATE_IND=1 and STATUS_CODE=1 ORDER BY CAST(ROWID_OBJECT AS INT)