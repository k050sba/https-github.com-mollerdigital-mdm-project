USE MDM_CM;
Truncate table C_S_MDM_SAP_DEALER_INTGR;
insert into C_S_MDM_SAP_DEALER_INTGR(PKEY_SRC_OBJECT,VERSION_SEQ,SRC_ROWID,HUB_STATE_IND,LAST_UPDATE_DATE,Dealer_number,Party_id,top_id,Type,SAP_ID)
select CONCAT(rtrim(per_sap.TOP_ID),'|',rtrim(per_sap.PARTY_ID),'|',rtrim(delnam.DEALER_NUMBER),'|MDM|INSERT|TESTDATA') as PKEY_SRC_OBJECT,1,'MDM',1,GETDATE(),
delnam.DEALER_NUMBER,per_sap.PARTY_ID,per_sap.TOP_ID,'P' as TYPE,NULL as SAP_ID
from C_B_MDM_SAP_PERSON per_sap
inner join C_REL_PARTY_DEALER del on del.PARTY_ID=per_sap.PARTY_ID and del.HUB_STATE_IND=1 and del.RELATION_END_DATE is null
inner join C_B_DEALER delnam on (del.DEALER_ID=delnam.ROWID_OBJECT and del.HUB_STATE_IND=1 and delnam.DEALER_NUMBER in(select Dealer_number from C_B_SAP_Dealer))
and not exists ( select 1 From C_B_MDM_SAP_DEALER_INTGR  where DEALER_NUMBER=delnam.DEALER_NUMBER and per_sap.PARTY_ID=PARTY_ID);
