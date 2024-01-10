USE MDM_CM

truncate table C_S_MDM_ADDRESS
insert into C_S_MDM_ADDRESS(ROWID_OBJECT,PKEY_SRC_OBJECT,SRC_ROWID,VERSION_SEQ,LAST_UPDATE_DATE,ADDRESS_LINE_1,CITY_NAME,POSTAL_CODE,COUNTRY_ISO2_CODE)
select addr.ROWID_OBJECT,CONCAT(RTRIM(addr.ROWID_OBJECT),CONCAT('|',hist.COUNTRY_ISO2_CODE)),addr.ROWID_OBJECT,'1',CURRENT_TIMESTAMP,
hist.ADDRESS_LINE_1,hist.CITY_NAME,hist.POSTAL_CODE,hist.COUNTRY_ISO2_CODE
from C_B_ADDRESS addr left join  (
 select address_hist.* from C_B_ADDRESS_hist address_hist inner join 
 (select ROWID_OBJECT,max(HIST_CREATE_DATE) as HIST_CREATE_DATE
 from C_B_ADDRESS_hist 
 where CITY_NAME is not null
 and POSTAL_CODE is not null
 --and LAST_ROWID_SYSTEM<>'MNET'
 group by ROWID_OBJECT) addr_hist on (address_hist.ROWID_OBJECT=addr_hist.ROWID_OBJECT and address_hist.HIST_CREATE_DATE=addr_hist.HIST_CREATE_DATE)
 ) hist on addr.ROWID_OBJECT=hist.ROWID_OBJECT
where addr.HUB_STATE_IND='1'
and addr.CREATE_DATE > GETDATE()-15
and addr.ADDRESS_LINE_1 is null
and addr.CITY_NAME is null
and addr.POSTAL_CODE is null 
and addr.CO_NAME is null
and exists (select 1 from C_REL_PARTY_ADDRESS addrel 
                     where addrel.ADDRESS_ID=addr.ROWID_OBJECT 
                     and addrel.HUB_STATE_IND='1' 
                     and addrel.ADDRESS_TYPE='P'
                     and exists (select 1 from c_b_party party 
                                          where party.ROWID_OBJECT=addrel.PARTY_ID
                                          and party.HUB_STATE_IND='1'
                     ))
and hist.ROWID_OBJECT is not null;

truncate table C_S_MDM_PARTY_PHONE

insert into C_S_MDM_PARTY_PHONE(ROWID_OBJECT,PKEY_SRC_OBJECT,VERSION_SEQ,SRC_ROWID,LAST_UPDATE_DATE,PHONE_NUMBER)
select phone.ROWID_OBJECT,CONCAT(RTRIM(phone.ROWID_OBJECT),CONCAT('|',RTRIM(phone.PARTY_ID))),'1',phone.ROWID_OBJECT,CURRENT_TIMESTAMP,hist.PHONE_NUMBER
from C_B_PARTY_PHONE phone left join  (
 select phone_hist1.* from C_B_PARTY_PHONE_hist phone_hist1 inner join 
 (select ROWID_OBJECT,max(HIST_CREATE_DATE) as HIST_CREATE_DATE
 from C_B_PARTY_PHONE_hist 
 where PHONE_NUMBER is not null
 --and PHONE_TYPE is not null
 group by ROWID_OBJECT) phone_hist2 on (phone_hist1.ROWID_OBJECT=phone_hist2.ROWID_OBJECT and phone_hist1.HIST_CREATE_DATE=phone_hist2.HIST_CREATE_DATE)
 ) hist on phone.ROWID_OBJECT=hist.ROWID_OBJECT
where phone.HUB_STATE_IND='1'
and phone.CREATE_DATE > GETDATE()-15
and phone.PHONE_NUMBER is null
--and phone.PHONE_TYPE is null
and exists (select 1 from c_b_party party 
                      where party.ROWID_OBJECT=phone.PARTY_ID
                      and party.HUB_STATE_IND='1'
                     )
and hist.ROWID_OBJECT is not null
and phone.PARTY_ID=hist.PARTY_ID
and phone.COUNTRY_ISO2_CODE=hist.COUNTRY_ISO2_CODE
and phone.PHONE_TYPE=hist.PHONE_TYPE
and hist.PHONE_NUMBER not like '%U%';

truncate table C_S_MDM_EMAIL_TYPE

insert into C_S_MDM_EMAIL_TYPE(ROWID_OBJECT,PKEY_SRC_OBJECT,VERSION_SEQ,SRC_ROWID,LAST_UPDATE_DATE,ELECTRONIC_ADDRESS)
select email.ROWID_OBJECT,CONCAT(RTRIM(email.ROWID_OBJECT),CONCAT('|',RTRIM(email.PARTY_ID))),'1',email.ROWID_OBJECT,CURRENT_TIMESTAMP,hist.ELECTRONIC_ADDRESS
from C_B_PARTY_el_address email left join  (
 select email_hist1.* from C_B_PARTY_el_address_hist email_hist1 inner join 
 (select ROWID_OBJECT,max(HIST_CREATE_DATE) as HIST_CREATE_DATE
 from C_B_PARTY_el_address_hist 
 where ELECTRONIC_ADDRESS is not null
 --and PHONE_TYPE is not null
 group by ROWID_OBJECT) email_hist2 on (email_hist1.ROWID_OBJECT=email_hist2.ROWID_OBJECT and email_hist1.HIST_CREATE_DATE=email_hist2.HIST_CREATE_DATE)
 ) hist on email.ROWID_OBJECT=hist.ROWID_OBJECT
where email.HUB_STATE_IND='1'
and email.CREATE_DATE > GETDATE()-15
and email.ELECTRONIC_ADDRESS is null
--and phone.PHONE_TYPE is null
and exists (select 1 from c_b_party party 
                      where party.ROWID_OBJECT=email.PARTY_ID
                      and party.HUB_STATE_IND='1'
                     )
and hist.ROWID_OBJECT is not null
and email.PARTY_ID=hist.PARTY_ID
and email.ELECTRONIC_ADDRESS_TYPE=hist.ELECTRONIC_ADDRESS_TYPE