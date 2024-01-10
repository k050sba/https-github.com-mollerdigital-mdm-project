--	Uniqueness: % suspected duplicates to be analysed for merge versus % that has been verified as unique or duplicate (and already merged)
USE MDM_CM;
select * from   MDM_CUSTOM..Data_Quality_dashboard where Load_Date>getdate()-1;
insert into MDM_Custom..Data_Quality_dashboard
select A.COUNTRY_CODE as Country_Code,A.TYPE as Type,UNIQUENESS as Count1,B.total as Total,
(cast(UNIQUENESS as decimal(9,2))/cast(B.total as decimal(9,2))) *100 as Percent_score,
A.Subject_Area,A.Load_Date from (select  COUNTRY_CODE, TYPE,count(1) as UNIQUENESS,'UNIQUENESS' as 'Subject_Area',getdate() as Load_Date from  C_B_PARTY prty 
where prty.HUB_STATE_IND=1 and prty.TYPE in('P','O') and prty.COUNTRY_CODE in('NO','LT','LV','EE')
and (not exists( select 1 from C_B_PARTY_MTCH mtch where mtch.ROWID_OBJECT=prty.ROWID_OBJECT)
and not exists( select 1 from C_B_PARTY_MTCH mtch where mtch.ROWID_OBJECT_MATCHED=prty.ROWID_OBJECT))
group by COUNTRY_CODE, TYPE) A,
--order by COUNTRY_CODE, TYPE
(select  COUNTRY_CODE, TYPE,count(1) total from  C_B_PARTY prty 
where prty.HUB_STATE_IND=1 and prty.TYPE in('P','O') and prty.COUNTRY_CODE in('NO','LT','LV','EE')
group by COUNTRY_CODE, TYPE) B
where A.COUNTRY_CODE=B.COUNTRY_CODE
and A.TYPE=B.TYPE
order by A.COUNTRY_CODE, A.TYPE
--	Completeness: % of fields meeting mandatory data requirements that are set by Data Governance in 2020 versus % fields that are mandatory but empty
---Modified Query using table
truncate table MDM_Custom..Completeness
--Organization Non Lead ----- Added the RELATION_END_DATE is null--
insert into  MDM_Custom..Completeness
select A.COUNTRY_CODE as Country_Code,A.TYPE as Type,A.count_of_total as Count1,outB.total as Total,
(cast(count_of_total as decimal(9,2))/cast(total as decimal(9,2))) *100 as Percent_score,
'COMPLETENESS' as Subject_Area,getdate() as Load_Date 
from
(select  COUNTRY_CODE, TYPE,count(1) count_of_total 
from  C_B_PARTY prty 
where prty.HUB_STATE_IND=1 and prty.TYPE in('O') 
and prty.COUNTRY_CODE in('NO','LT','LV','EE')
and exists( select 1 from C_B_PARTY_STATUS sts where sts.PARTY_ID=prty.ROWID_OBJECT and STATUS_TYPE in('A','I','D')and RELATION_END_DATE is null)
and prty.ROWID_OBJECT in(select PARTY_ID from C_B_ORGANIZATION where (ALIAS_NAME is not null or LEGAL_NAME is not null or ORGANIZATION_NUMBER is not null) )
and (exists(select 1 from C_B_PHONE phone where phone.PARTY_ID=prty.ROWID_OBJECT and phone.PHONE_NUMBER is not null and phone.HUB_STATE_IND=1)
and exists(select 1 from C_REL_PARTY_ADDRESS rela where rela.PARTY_ID=prty.ROWID_OBJECT and rela.ADDRESS_TYPE='ST' and rela.HUB_STATE_IND=1))
group by COUNTRY_CODE, TYPE) as A,
(select  COUNTRY_CODE, TYPE,count(1) total from  C_B_PARTY prty 
where prty.HUB_STATE_IND=1 and prty.TYPE in('O') and prty.COUNTRY_CODE in('NO','LT','LV','EE')
group by COUNTRY_CODE, TYPE) as outB
where A.COUNTRY_CODE=outB.COUNTRY_CODE
and A.TYPE=outB.TYPE
--Organization  Lead
insert into  MDM_Custom..Completeness
select outA.COUNTRY_CODE as Country_Code,outA.TYPE as Type,outA.count_of_total as Count1,outB.total as Total,
(cast(count_of_total as decimal(9,2))/cast(total as decimal(9,2))) *100 as Percent_score,
'COMPLETENESS' as Subject_Area,getdate() as Load_Date from
(
select  COUNTRY_CODE, TYPE,count(1) count_of_total 
from  C_B_PARTY prty 
where prty.HUB_STATE_IND=1 and prty.TYPE in('O') 
and prty.COUNTRY_CODE in('NO','LT','LV','EE')
and exists( select 1 from C_B_PARTY_STATUS sts where sts.PARTY_ID=prty.ROWID_OBJECT and STATUS_TYPE='L' and RELATION_END_DATE is null)
and prty.ROWID_OBJECT in(select PARTY_ID from C_B_ORGANIZATION where (ALIAS_NAME is not null or LEGAL_NAME is not null or ORGANIZATION_NUMBER is not null) )
group by COUNTRY_CODE, TYPE
) as outA,
(select  COUNTRY_CODE, TYPE,count(1) total from  C_B_PARTY prty 
where prty.HUB_STATE_IND=1 and prty.TYPE in('P','O') and prty.COUNTRY_CODE in('NO','LT','LV','EE')
group by COUNTRY_CODE, TYPE) as outB
where outA.COUNTRY_CODE=outB.COUNTRY_CODE
and outA.TYPE=outB.TYPE
--Person_lead
insert into  MDM_Custom..Completeness
select outA.COUNTRY_CODE as Country_Code,outA.TYPE as Type,outA.count_of_total as Count1,outB.total as Total,
(cast(count_of_total as decimal(9,2))/cast(total as decimal(9,2))) *100 as Percent_score,
'COMPLETENESS' as Subject_Area,getdate() as Load_Date from
(select A.COUNTRY_CODE, A.TYPE,sum(A.count_of_total) count_of_total from (select  COUNTRY_CODE, TYPE,count(1) count_of_total 
from  C_B_PARTY prty 
where prty.HUB_STATE_IND=1 and prty.TYPE in('P') 
and prty.COUNTRY_CODE in('NO','LT','LV','EE')
and exists( select 1 from C_B_PARTY_STATUS sts where sts.PARTY_ID=prty.ROWID_OBJECT and STATUS_TYPE='L' and RELATION_END_DATE is null)
and exists(select 1 from C_B_PERSON per where per.PARTY_ID=prty.ROWID_OBJECT and per.FIRST_NAME is not null and per.SURNAME is not null)
and (exists(select 1 from C_B_PHONE phone where phone.PARTY_ID=prty.ROWID_OBJECT and phone.PHONE_NUMBER is not null and phone.HUB_STATE_IND=1)
or exists(select 1 from C_REL_PARTY_ADDRESS rela where rela.PARTY_ID=prty.ROWID_OBJECT and rela.ADDRESS_TYPE='ST' and rela.HUB_STATE_IND=1))
group by COUNTRY_CODE, TYPE) as A
group by COUNTRY_CODE, TYPE
) as outA,
(select  COUNTRY_CODE, TYPE,count(1) total from  C_B_PARTY prty 
where prty.HUB_STATE_IND=1 and prty.TYPE in('P','O') and prty.COUNTRY_CODE in('NO','LT','LV','EE')
group by COUNTRY_CODE, TYPE) as outB
where outA.COUNTRY_CODE=outB.COUNTRY_CODE
and outA.TYPE=outB.TYPE
--Person_Non Lead
insert into  MDM_Custom..Completeness
select outA.COUNTRY_CODE as Country_Code,outA.TYPE as Type,outA.count_of_total as Count1,outB.total as Total,
(cast(count_of_total as decimal(9,2))/cast(total as decimal(9,2))) *100 as Percent_score,
'COMPLETENESS' as Subject_Area,getdate() as Load_Date from
(select A.COUNTRY_CODE, A.TYPE,sum(A.count_of_total) count_of_total from (select  COUNTRY_CODE, TYPE,count(1) count_of_total 
from  C_B_PARTY prty  
where prty.HUB_STATE_IND=1 and prty.TYPE in('P') 
and prty.COUNTRY_CODE in('NO','LT','LV','EE')
and exists( select 1 from C_B_PARTY_STATUS sts where sts.PARTY_ID=prty.ROWID_OBJECT and STATUS_TYPE in('A','I','D') and RELATION_END_DATE is null)
and exists(select 1 from C_B_PERSON per where per.PARTY_ID=prty.ROWID_OBJECT and per.FIRST_NAME is not null and per.SURNAME is not null)
and (exists(select 1 from C_B_PHONE phone where phone.PARTY_ID=prty.ROWID_OBJECT and phone.PHONE_NUMBER is not null and phone.HUB_STATE_IND=1)
and exists(select 1 from C_REL_PARTY_ADDRESS rela where rela.PARTY_ID=prty.ROWID_OBJECT and rela.ADDRESS_TYPE='ST' and rela.HUB_STATE_IND=1))
group by COUNTRY_CODE, TYPE
) as A
group by COUNTRY_CODE, TYPE
) as outA,
(select  COUNTRY_CODE, TYPE,count(1) total from  C_B_PARTY prty 
where prty.HUB_STATE_IND=1 and prty.TYPE in('P','O') and prty.COUNTRY_CODE in('NO','LT','LV','EE')
group by COUNTRY_CODE, TYPE) as outB
where outA.COUNTRY_CODE=outB.COUNTRY_CODE
and outA.TYPE=outB.TYPE
--Total Query
insert into MDM_Custom..Data_Quality_dashboard
select country_code,type, sum(Count1) as Count1,max(Total) as Total,
(cast(sum(Count1) as decimal(9,2))/cast(max(Total) as decimal(9,2))) *100 as Percent_score,
subject_area,
getdate() as Load_Date from MDM_Custom..Completeness
group by country_code,type,subject_area
--	Validity: % of fields with data format according to requirements versus % with junk data 
 insert into MDM_Custom..Data_Quality_dashboard
 select B.COUNTRY_CODE as Country_Code,B.TYPE as Type,
convert(int,(cast(A.SCORE as decimal(9,2))*cast(B.total as decimal(9,2)))/100)  Count1,B.total as Total,
SCORE as Percent_score,
'VALIDITY' as Subject_Area,getdate()  Load_Date 
from ( select COUNTRY AS COUNTRY_CODE,SUBJECT_AREA as TYPE,SCORE from mdm_custom..DQ_SCORECARD_HS_DIMENSION
 where DOMAIN='JUNK_SPECIAL_FORMAT'
 and SUBJECT_AREA in('ORGANIZATION','PERSON')
 and LOADTIME=(select max(LOADTIME) from  mdm_custom..DQ_SCORECARD_HS_DIMENSION)) A,
--order by COUNTRY_CODE, TYPE
(select  COUNTRY_CODE, TYPE,count(1) total from  C_B_PARTY prty 
where prty.HUB_STATE_IND=1 and prty.TYPE in('P','O') and prty.COUNTRY_CODE in('NO','LT','LV','EE')
group by COUNTRY_CODE, TYPE) B
where A.COUNTRY_CODE=(select description from C_LU_COUNTRY where B.COUNTRY_CODE=CODE)
and A.TYPE=(select DESCRIPTION from C_LU_PARTY_TYPE where code= B.TYPE)
order by A.COUNTRY_CODE, A.TYPE
--	Correctness: % fields that has been verified either automatically by external registry, or manually through updates versus % that has not been verified

--Temp Table preparation for 9 month
TRUNCATE TABLE MDM_CUSTOM..C_B_PARTY_9MONTH ;
INSERT INTO MDM_CUSTOM..C_B_PARTY_9MONTH 
   SELECT
      * 
   FROM
      MDM_CM..C_B_PARTY 
   WHERE
      ROWID_OBJECT IN 
      (
         SELECT
            ROWID_OBJECT 
         FROM
            MDM_CM..C_B_PARTY_XREF 
         WHERE
            ORIG_ROWID_OBJECT IN 
            (
               SELECT
                  * 
               FROM
                  (
                     SELECT DISTINCT
                        PARTY_ID 
                     FROM
                        MDM_CM..C_B_PERSON_HIST 
                     WHERE
                        HIST_CREATE_DATE > GETDATE()-270 
                     UNION
                     SELECT DISTINCT
                        PARTY_ID 
                     FROM
                        MDM_CM..C_B_ORGANIZATION_HIST 
                     WHERE
                        HIST_CREATE_DATE > GETDATE()-270 
                     UNION
                     SELECT DISTINCT
                        PARTY_ID 
                     FROM
                        MDM_CM..C_B_PHONE_HIST 
                     WHERE
                        HIST_CREATE_DATE > GETDATE()-270
                        AND NON_LEGAL_SUBORG_ID IS NULL 
                     UNION
                     SELECT DISTINCT
                        PARTY_ID 
                     FROM
                        MDM_CM..C_B_ELECTRONIC_ADDRESS_HIST 
                     WHERE
                        HIST_CREATE_DATE > GETDATE()-270 
                        AND NON_LEGAL_SUBORG_ID IS NULL 
                     UNION
                     SELECT DISTINCT
                        RL.PARTY_ID 
                     FROM
                        MDM_CM..C_REL_PARTY_ADDRESS_HIST RL 
                        INNER JOIN
                           MDM_CM..C_B_ADDRESS_HIST AD 
                           ON RL.ADDRESS_ID = AD.ROWID_OBJECT 
                     WHERE
                        AD.HIST_CREATE_DATE >GETDATE()-270
                        AND RL.NON_LEGAL_SUBORG_ID IS NULL 
                  )
                  X 
            )
      );


insert into MDM_Custom..Data_Quality_dashboard
select A.COUNTRY_CODE as Country_Code,A.TYPE as Type,Correctness as Count1,B.total as Total,
(cast(Correctness as decimal(9,2))/cast(B.total as decimal(9,2))) *100 as Percent_score,
'CORRECTNESS' as Subject_Area,getdate() Load_Date from
( select COUNTRY_CODE, TYPE,count(1) as Correctness from C_B_PARTY prty where 
(prty.ROWID_OBJECT  in(select PARTY_ID from DF_TEMP_CONSOLIDATED_RD)
  or prty.ROWID_OBJECT  in(select ROWID_OBJECT from MDM_CUSTOM..C_B_PARTY_1YEAR where type='P' )
  or prty.ROWID_OBJECT  in(select ROWID_OBJECT from MDM_CUSTOM..C_B_PARTY_1YEAR where type='O' )
  )
 and prty.HUB_STATE_IND=1 and prty.TYPE in('P','O') and prty.COUNTRY_CODE in('NO','LT','LV','EE')
 group by COUNTRY_CODE, TYPE) A,
 (select  COUNTRY_CODE, TYPE,count(1) total from  C_B_PARTY prty 
where prty.HUB_STATE_IND=1 and prty.TYPE in('P','O') and prty.COUNTRY_CODE in('NO','LT','LV','EE')
group by COUNTRY_CODE, TYPE) B
where A.COUNTRY_CODE= B.COUNTRY_CODE
and A.TYPE=B.TYPE
order by A.COUNTRY_CODE, A.TYPE