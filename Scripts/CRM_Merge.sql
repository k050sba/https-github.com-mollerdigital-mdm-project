/*alter table MDM_Custom..CRM_Merge
add Processed varchar(1)

update MDM_Custom..CRM_Merge set Processed='0'
*/
USE MDM_CM;

update top(500) MDM_Custom..CRM_Merge
set Processed='2'
where Processed='0' and TYPE='O';

insert into C_REPOS_MQ_DATA_CHANGE(ROWID_MQ_DATA_CHANGE,ROWID_MQ_RULE,ROWID_TABLE,ROWID_OBJECT,SENT_STATE_ID,CREATOR,CREATE_DATE,UPDATED_BY,LAST_UPDATE_DATE,CHANGE_TYPE,
PKEY_SRC_OBJECT,SRC_ROWID_SYSTEM,SRC_PKEY_SRC_OBJECT,TGT_ROWID_SYSTEM,MERGE_SRC_ROWID_OBJECT)
select NEXT VALUE FOR MDM_Custom..ROWID_MQ_DATA_CHANGE AS ROWID_MQ_DATA_CHANGE,
 (select ROWID_MQ_RULE from C_REPOS_MQ_RULE where ROWID_TABLE='SVR1.1NNK     ' and RULE_NAME='Delta on Party'),
 'SVR1.1NNK     ',
ROWID_OBJECT ,
 '0',
 'admin',
 CURRENT_TIMESTAMP,
 'CMX',
 CURRENT_TIMESTAMP,
 '4',
 CONCAT('MDM|',RTRIM(ROWID_OBJECT)),
 'MDM',
 CONCAT('MDM|',RTRIM(ROWID_OBJECT)),
 'MDM',
mb_mdmcustomerid from(select * from MDM_CUstom..CRM_Merge where Processed='2' and 
(select rowid_object from C_B_PARTY_XREF where orig_rowid_object=mb_mdmcustomerid)=(select rowid_object from C_B_PARTY_XREF where orig_rowid_object=CRM_Merge.ROWID_OBJECT))X;

update MDM_Custom..CRM_Merge
set Processed='1'
where Processed='2'