USE MDM_CM;
truncate table C_S_MDM_SAP_DEALER_INTGR;
insert into C_S_MDM_SAP_DEALER_INTGR(ROWID_OBJECT,PKEY_SRC_OBJECT,VERSION_SEQ,SRC_ROWID,HUB_STATE_IND,LAST_UPDATE_DATE,Dealer_number,Party_id,top_id,Type,SAP_ID)
select ing.ROWID_OBJECT,CONCAT(rtrim(ing.ROWID_OBJECT),'|',rtrim(ing.TOP_ID),'|',rtrim(ing.PARTY_ID),'|',rtrim(ing.DEALER_NUMBER),'|MDM|INSERT|TESTDATA') as PKEY_SRC_OBJECT,1,'MDM',1,GETDATE(),
ing.DEALER_NUMBER,per_sap.PARTY_ID,per_sap.TOP_ID,ing.TYPE as TYPE,ing.SAP_ID as SAP_ID
 from  C_B_MDM_SAP_DEALER_INTGR ing ,
C_B_MDM_SAP_PERSON per_sap
where (per_sap.PARTY_ID=ing.PARTY_ID
and per_sap.TOP_ID!=ing.TOP_ID)
and per_sap.MDM_ID_STATUS='WINNING';