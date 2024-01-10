USE MDM_CM;
insert into MDM_CUSTOM..SAP_MDM_DEARLE_TOPID (VAT_NUMBER,top_id)
 select VAT.VAT_NUMBER, Concat('DO',NEXT VALUE FOR  MDM_CUSTOM..do_topid_seq) as top_id  from
    (select VAT_NUMBER from  C_B_ORGANIZATION org where HUB_STATE_IND=1 and VAT_NUMBER is not null
 and org.party_id in (select ROWID_OBJECT from MDM_CM..C_B_PARTY where  HUB_STATE_IND=1 and COUNTRY_CODE='NO' and TYPE='O') 
 and org.VAT_NUMBER not in (select VAT_NUMBER from MDM_CUSTOM..SAP_MDM_DEARLE_TOPID)
 and org.LAST_ROWID_SYSTEM='SAP'
 group by VAT_NUMBEr) as VAT;
 --------- new topId insertion in C_B_MDM_SAP_ORGANIZATION table
 Truncate table  C_S_MDM_SAP_ORG;
 insert into C_S_MDM_SAP_ORG(PKEY_SRC_OBJECT,VERSION_SEQ,SRC_ROWID,HUB_STATE_IND,LAST_UPDATE_DATE,TOP_ID,PARTY_ID,LEGAL_NAME,ALIAS_NAME,TYPE,VAT,ORGANIZATION_NUMBER)
select CONCAT(vat.VAT_NUMBER,vat.top_id,rtrim(org.PARTY_ID),'|MDM|INSERT|TESTDATA') as PKEY_SRC_OBJECT,1 as VERSION_SEQ,'SAP' as SRC_ROWID,1 as HUB_STATE_IND,GETDATE() as LAST_UPDATE_DATE,
vat.Top_id  as TOP_ID, org.PARTY_ID,org.LEGAL_NAME,org.ALIAS_NAME,'DO' as TYPE,org.VAT_NUMBER,org.ORGANIZATION_NUMBER
from C_B_ORGANIZATION org,MDM_Custom..SAP_MDM_DEARLE_TOPID as vat
where
exists(select 1 from C_B_PARTY where org.PARTY_ID=C_B_PARTY.ROWID_OBJECT and HUB_STATE_IND=1 and COUNTRY_CODE='NO'
        and exists(select 1 from C_B_PARTY_STATUS sts where sts.PARTY_ID=org.PARTY_ID and sts.HUB_STATE_IND=1 
		            and (sts.RELATION_END_DATE is null and sts.STATUS_TYPE in('A','I','L')))
		)--outerexists---
and org.LAST_ROWID_SYSTEM='SAP'
and org.VAT_NUMBER=vat.VAT_NUMBER
and  not exists (select 1 from C_B_MDM_SAP_ORGANIZATION sp   where  sp.PARTY_ID=org.PARTY_ID and sp.TYPE='DO');
