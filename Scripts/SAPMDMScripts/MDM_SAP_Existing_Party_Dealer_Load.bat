sqlcmd -S SQLP2AGMDM\MDMP2 -U SQLMDMP -P sQ!mdmPP -i  "D:\Scripts\SAPMDMScripts\MDM_SAP_Existing_Party_Dealer_Load.sql" & call D:\Scripts\Migration\resourcekit\automation\ExecuteBatchCommandLineTool\MDMExecuteBatch_resourcekit\scripts\mdm_exec_batch_proc.cmd -username admin -password 295BFDA62A76725D -action load -tablename C_S_MDM_SAP_DEALER_INTGR