USE MDM_CM;
insert into MDM_CUSTOM..SAP_MDM_FORORG_TOPID (ORGANIZATIOn_NUMBER,top_id)
 select FORG.ORGANIZATION_NUMBER, Concat('U',NEXT VALUE FOR  MDM_CUSTOM..U_topid_seq) as top_id  from
(select co.ORGANIZATION_NUMBER as ORGANIZATION_NUMBER from c_b_party cp join c_b_party_status cs on (cp.ROWID_OBJECT = cs.PARTY_ID and cs.HUB_STATE_IND = 1 and cs.RELATION_END_DATE is null and  cs.STATUS_TYPE in('A','I','L'))
join C_REL_PARTY_ADDRESS cra on (cra.PARTY_ID = cp.ROWID_OBJECT and cra.HUB_STATE_IND = 1 and cra.RELATION_END_DATE is null)
join C_B_ADDRESS ca on (ca.ROWID_OBJECT = cra.ADDRESS_ID)
join C_B_ORGANIZATION co on (co.PARTY_ID = cp.ROWID_OBJECT and co.HUB_STATE_IND = 1)
where cp.COUNTRY_CODE = 'NO'
and cp.HUB_STATE_IND = 1 
and cra.ADDRESS_TYPE = 'ST'
and ca.COUNTRY_ISO2_CODE != 'NO'
and cp.TYPE = 'O' and co.ORGANIZATION_NUMBER is not null
and not exists (select 1 from C_B_BRREG_ORGANIZATIONS bo where bo.ORGANISASJONSNUMMER=co.ORGANIZATION_NUMBER)
and co.ORGANIZATION_NUMBER not in (select ORGANIZATION_NUMBER from MDM_CUSTOM..SAP_MDM_FORORG_TOPID)
 group by co.ORGANIZATION_NUMBER) as FORG;


 Truncate table  C_S_MDM_SAP_ORG;
insert into C_S_MDM_SAP_ORG(PKEY_SRC_OBJECT,VERSION_SEQ,SRC_ROWID,HUB_STATE_IND,LAST_UPDATE_DATE,TOP_ID,PARTY_ID,LEGAL_NAME,ALIAS_NAME,TYPE,VAT,ORGANIZATION_NUMBER)
select CONCAT(forg.ORGANIZATION_NUMBER,forg.top_id,rtrim(org.PARTY_ID),'|MDM|INSERT|TESTDATA') as PKEY_SRC_OBJECT,1 as VERSION_SEQ,'MDM' as SRC_ROWID,1 as HUB_STATE_IND,GETDATE() as LAST_UPDATE_DATE,
forg.Top_id  as TOP_ID, org.PARTY_ID,org.LEGAL_NAME,org.ALIAS_NAME,'U' as TYPE,org.VAT_NUMBER,org.ORGANIZATION_NUMBER
from C_B_ORGANIZATION org,MDM_CUSTOM..SAP_MDM_FORORG_TOPID as forg
where
exists(	select 1 from c_b_party cp 
join c_b_party_status cs on (cp.ROWID_OBJECT = cs.PARTY_ID and cs.HUB_STATE_IND = 1 and cs.RELATION_END_DATE is null and  cs.STATUS_TYPE in('A','I','L'))
join C_REL_PARTY_ADDRESS cra on (cra.PARTY_ID = cp.ROWID_OBJECT and cra.HUB_STATE_IND = 1 and cra.RELATION_END_DATE is null)
join C_B_ADDRESS ca on (ca.ROWID_OBJECT = cra.ADDRESS_ID and ca.HUB_STATE_IND = 1)
join C_B_ORGANIZATION co on (co.PARTY_ID = cp.ROWID_OBJECT and co.HUB_STATE_IND = 1)
where cp.COUNTRY_CODE = 'NO'
--and cs.STATUS_TYPE in ( 'A','I','L')
--not in ('NO','LT','EE','LV')
--and cp.ROWID_OBJECT = '31730636'
and cp.HUB_STATE_IND = 1 
and cra.ADDRESS_TYPE = 'ST'
and ca.COUNTRY_ISO2_CODE != 'NO'
and cp.TYPE = 'O' and co.ORGANIZATION_NUMBER is not null and co.PARTY_ID=org.PARTY_ID
and not exists (select 1 from C_B_BRREG_ORGANIZATIONS bo where bo.ORGANISASJONSNUMMER=co.ORGANIZATION_NUMBER)
		)--outerexists---
and org.ORGANIZATION_NUMBER=forg.ORGANIZATION_NUMBER
and not exists  (select TOP_ID from C_B_MDM_SAP_ORGANIZATION sap where sap.PARTY_ID=org.PARTY_ID);