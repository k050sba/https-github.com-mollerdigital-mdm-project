USE MDM_CM;
Truncate table MDM_CUSTOM..C_B_PARTY_HMRG;
insert into  MDM_CUSTOM..C_B_PARTY_HMRG 
select * from C_B_PARTY_HMRG where MERGE_DATE>GETDATE()-1
and exists(select 1 from C_B_MDM_SAP_PERSON where MDM_ID_STATUS='WINNING' and C_B_MDM_SAP_PERSON.PARTY_ID=C_B_PARTY_HMRG.TGT_ROWID_OBJECT);

--Create Winning Rows- and insert into stage
Truncate table C_S_MDM_SAP_PERSON;
insert into C_S_MDM_SAP_PERSON(pkey_src_object,rowid_object,version_seq,SRC_ROWID,last_update_date,updated_by,PARTY_ID,TOP_ID,MDM_ID_STATUS)
select Distinct concat(CONCAT(top_id,party_id),MDM_ID_STATUS),C_B_MDM_SAP_PERSON.ROWID_OBJECT,1,'MDM',getdate(),'SYSTEM',hmrg.TGT_ROWID_OBJECT, TOP_ID,'WINNING' 
from MDM_CUSTOM..C_B_PARTY_HMRG hmrg,C_B_MDM_SAP_PERSON where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=hmrg.TGT_ROWID_OBJECT)
and  C_B_MDM_SAP_PERSON.party_id=hmrg.TGT_ROWID_OBJECT;

--Create loosing Record
insert into C_S_MDM_SAP_PERSON(pkey_src_object,rowid_object,version_seq,SRC_ROWID,last_update_date,updated_by,PARTY_ID,TOP_ID,MDM_ID_STATUS)
select concat(CONCAT(bo.top_id,bo.party_id),bo.MDM_ID_STATUS) as pkey_src_object,bo.ROWID_OBJECT,1,'MDM',getdate(),'SYSTEM',xref.ORIG_ROWID_OBJECT, bo.TOP_ID,'LOOSING' 
 from C_B_PARTY_XREF xref
 inner join C_S_MDM_SAP_PERSON stg on stg.PARTY_ID=xref.ROWID_OBJECT 
 and stg.PARTY_ID<>xref.ORIG_ROWID_OBJECT
inner join  C_B_MDM_SAP_PERSON bo on bo.PARTY_ID=xref.ORIG_ROWID_OBJECT;

 truncate table MDM_CUSTOM..TOP_ID;
--select * from MDM_CUSTOM..TOP_ID
--Create Dummy Table to find the top ID of winning and truncate and load TOP_ID
insert into  MDM_CUSTOM..TOP_ID
select case when CAST(SUBSTRING(win.top_id,CHARINDEX('P',win.top_id)+1,LEN(win.top_id)) as BIGINT)>CAST(SUBSTRING(los.TOP_ID,CHARINDEX('P',los.TOP_ID)+1,LEN(los.TOP_ID)) as BIGINT) then los.TOP_ID
else win.TOP_ID end as topID,win.PARTY_ID wining,los.PARTY_ID loosing
 from MDM_CUSTOM..C_B_PARTY_HMRG hmrg 
inner join C_B_MDM_SAP_PERSON win on win.PARTY_ID=hmrg.TGT_ROWID_OBJECT
inner join C_B_MDM_SAP_PERSON los on los.PARTY_ID=hmrg.SRC_ROWID_OBJECT;

--Update the correct Top ID for winning
update C_S_MDM_SAP_PERSON set TOP_ID=topIDout
from 
(select per.rowid_object,( Select concat('P',
min(CAST(SUBSTRING(topI.topid,charindex('P',topI.topid)+1,LEN(topI.topid)) as BIGINT)))  from MDM_CUSTOM..TOP_ID topI 
where topI.wining=per.PARTY_ID ) as topIDout,per.TOP_ID as old_TOP 
from C_S_MDM_SAP_PERSON per where per.TOP_ID like 'P%') as pers
inner join C_S_MDM_SAP_PERSON on pers.rowid_object=C_S_MDM_SAP_PERSON.rowid_object
where pers.topIDout is not null and pers.topIDout <>'P';

update C_S_MDM_SAP_PERSON set TOP_ID=topIDout
from 
(select per.rowid_object,( Select 
min(topI.topID)  from MDM_CUSTOM..TOP_ID topI 
where topI.wining=per.PARTY_ID ) as topIDout,per.TOP_ID as old_TOP 
from C_S_MDM_SAP_PERSON per where per.TOP_ID not like 'P%') as pers
inner join C_S_MDM_SAP_PERSON on pers.rowid_object=C_S_MDM_SAP_PERSON.rowid_object
where pers.topIDout is not null and pers.topIDout <>'P';


-- Update the correct TopID for loosing
update C_S_MDM_SAP_PERSON  set TOP_ID=pers.TOP_ID
from 
(select stg2.ROWID_OBJECT,stg.TOP_ID from C_S_MDM_SAP_PERSON stg2
inner join C_B_PARTY_XREF xref on stg2.PARTY_ID=xref.ORIG_ROWID_OBJECT
inner join C_S_MDM_SAP_PERSON stg on  stg.PARTY_ID=xref.ROWID_OBJECT
where stg.MDM_ID_STATUS='WINNING'
and stg2.MDM_ID_STATUS='LOOSING') pers
inner join C_S_MDM_SAP_PERSON on pers.rowid_object=C_S_MDM_SAP_PERSON.rowid_object;


---------------------------Incremental data load for new Party_ids  in person after match and merg job execution

insert into C_S_MDM_SAP_PERSON(PKEY_SRC_OBJECT,VERSION_SEQ,HUB_STATE_IND,LAST_UPDATE_DATE,SRC_ROWID,FIRST_NAME,SURNAME,TOP_ID,PARTY_ID,MDM_ID_STATUS)
select CONCAT(RTRIM(per.ROWID_OBJECT),'|',RTRIM(per.PARTY_ID),'|','WINNING') as PKEY_SRC_OBJECT,1 as VERSION_SEQ ,1 as HUB_STATE_IND,getdate() as LAST_UPDATE_DATE,'MDM' as SRC_ROWID,per.FIRST_NAME,per.SURNAME,
  concat('P',NEXT VALUE FOR MDM_CUSTOM..TopID_seq) as top_id, per.PARTY_ID,'WINNING' as MDM_Id_status 
from MDM_CM..C_B_PERSON per
where
 per.HUB_STATE_IND =1
and 
exists(select 1 from MDM_CM..C_B_PARTY where per.PARTY_ID=C_B_PARTY.ROWID_OBJECT and HUB_STATE_IND=1 and COUNTRY_CODE='NO' and TYPE='P')
and exists(select 1 from MDM_CM..C_B_PARTY_STATUS sts where sts.PARTY_ID=per.PARTY_ID and sts.HUB_STATE_IND=1
 and (sts.RELATION_END_DATE is null and sts.STATUS_TYPE in('A','I','L') )
 )
 and (per.DECEASED_FLAG=0 or per.DECEASED_FLAG is null )
 and not exists(select 1 from  C_B_MDM_SAP_PERSON sp where sp.PARTY_ID=per.PARTY_ID);