SET NOCOUNT ON; select * from C_B_ADDRESS  where HUB_STATE_IND=1  order by CAST(ROWID_OBJECT as INT)