USE [MDM_CM]
--Total Parties
delete from   MDM_CUSTOM..Customer_Report_Detailed
where created_Month_Year=CONCAT(MONTH(GETDATE()),'-',YEAR(getdate()));

insert into MDM_Custom..Customer_Report_Detailed
select COUNTRY_CODE,TYPE,CONCAT(MONTH(GETDATE()),'-',YEAR(getdate())) as created_Month_Year
,count(1) as count,'Total Parties' as Category 
from MDM_CM..c_b_party P
where HUB_STATE_IND='1'
and TYPE in ('P','O')
and COUNTRY_CODE is not null
group by COUNTRY_CODE,TYPE
order by COUNTRY_CODE,TYPE;
----

--Created-Total

truncate table MDM_CM..CUSTOMER_CREATED_SRC_UPD

insert into MDM_CM..CUSTOMER_CREATED_SRC_UPD
select X.ROWID_OBJECT,X.HIST_CREATE_DATE
,case when CURRENT_PARTY_TYPE is null then X.PARTY_TYPE_CODE else CURRENT_PARTY_TYPE end as PARTY_TYPE_CODE
,X.COUNTRY_ISO2_CODE,X.LAST_ROWID_SYSTEM
from 
(SELECT  CUSTOMER_CREATED.* 
,(select top 1 TYPE from C_B_PARTY_HIST A where A.ROWID_OBJECT=CUSTOMER_CREATED.ROWID_OBJECT order by HIST_CREATE_DATE desc) as CURRENT_PARTY_TYPE
FROM  (
SELECT DISTINCT PHIST.ROWID_OBJECT,PHIST.HIST_CREATE_DATE,PARTY_TYPE_CODE,SRC.COUNTRY_ISO2_CODE,PHIST.LAST_ROWID_SYSTEM
FROM MDM_CUSTOM..C_B_PARTY_HIST PHIST LEFT JOIN MDM_CUSTOM..C_B_PARTY_SRC_COUNTRY_HIST SRC ON PHIST.ROWID_OBJECT=SRC.PARTY_ID AND SRC.HUB_STATE_IND='1'
WHERE PARTY_TYPE_CODE IN ('P','O')
AND EXISTS (SELECT 1 FROM 
                    (SELECT ROWID_OBJECT,MIN(HIST_CREATE_DATE) AS  HIST_CREATE_DATE
                     FROM MDM_CUSTOM..C_B_PARTY_HIST  
					 where   PARTY_TYPE_CODE IN ('P','O')
			         GROUP BY ROWID_OBJECT) HIST
					 WHERE HIST.HIST_CREATE_DATE=PHIST.HIST_CREATE_DATE
					 AND PHIST.ROWID_OBJECT=HIST.ROWID_OBJECT ) 
UNION
SELECT DISTINCT ROWID_OBJECT,HIST_CREATE_DATE,TYPE,COUNTRY_CODE,PHIST.LAST_ROWID_SYSTEM
FROM C_B_PARTY_HIST PHIST
WHERE TYPE  IN ('P','O')
AND EXISTS (SELECT 1 FROM 
                    (SELECT ROWID_OBJECT,MIN(HIST_CREATE_DATE) AS  HIST_CREATE_DATE
                     FROM C_B_PARTY_HIST  
			         GROUP BY ROWID_OBJECT) HIST
					 WHERE HIST.HIST_CREATE_DATE=PHIST.HIST_CREATE_DATE
					 AND PHIST.ROWID_OBJECT=HIST.ROWID_OBJECT )

)CUSTOMER_CREATED
where COUNTRY_ISO2_CODE IS NOT NULL

) X
ORDER BY X.HIST_CREATE_DATE;

insert into MDM_CUSTOM..Customer_Report_Detailed
select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(HIST_CREATE_DATE),'-',year(HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Created-Total' as Category 
from CUSTOMER_CREATED_SRC_UPD
where  HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
--where  HIST_CREATE_DATE>'2020-01-01'
group by year(HIST_CREATE_DATE),month(HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE
order by year(HIST_CREATE_DATE),month(HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE

---Created-Systems

insert into MDM_CUSTOM..Customer_Report_Detailed
select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(HIST_CREATE_DATE),'-',year(HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Created-Mittbilhold' as Category 
from CUSTOMER_CREATED_SRC_UPD
where  HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and LAST_ROWID_SYSTEM='MITTBILHOLD'
group by year(HIST_CREATE_DATE),month(HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE
--order by year(HIST_CREATE_DATE),month(HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE
union
select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(HIST_CREATE_DATE),'-',year(HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Created-CRM' as Category 
from CUSTOMER_CREATED_SRC_UPD
where  HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and LAST_ROWID_SYSTEM='CRM'
group by year(HIST_CREATE_DATE),month(HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE
--order by year(HIST_CREATE_DATE),month(HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE
union
select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(HIST_CREATE_DATE),'-',year(HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Created-Customer Search' as Category 
from CUSTOMER_CREATED_SRC_UPD
where  HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and LAST_ROWID_SYSTEM='CUSTOMERLOOKUP'
group by year(HIST_CREATE_DATE),month(HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE

---Updates from DF


insert into MDM_CUSTOM..Customer_Report_Detailed
select 
COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(X.HIST_CREATE_DATE),'-',year(X.HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Updates from DF' as Category 
from 
(
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_PERSON_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_B_PHONE_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) )
union
(select distinct PARTY_ID,cast(AD.HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_REL_PARTY_ADDRESS_HIST RL inner join C_B_ADDRESS_HIST AD on RL.ADDRESS_ID=AD.ROWID_OBJECT
where AD.LAST_ROWID_SYSTEM='DATAFACTORY' and AD.HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_ORGANIZATION_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
) X
inner join  CUSTOMER_CREATED_SRC_UPD Y on X.PARTY_ID=Y.ROWID_OBJECT
group by year(X.HIST_CREATE_DATE),month(X.HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE;

--Updates from DF not used

insert into MDM_CUSTOM..Customer_Report_Detailed
select COUNTRY_CODE,TYPE,concat(month(A.CREATE_DATE),'-',year(A.CREATE_DATE)) as created_Month_Year
,count(1) as count,'Updates from DF Not Used' as Category
from C_B_RECORD_DETAILS A inner join c_b_party P on A.UNIQUE_KEY=P.ROWID_OBJECT
where A.CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and UNIQUE_KEY not in (
select 
distinct PARTY_ID
from 
(
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_PERSON_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_B_PHONE_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(AD.HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_REL_PARTY_ADDRESS_HIST RL inner join C_B_ADDRESS_HIST AD on RL.ADDRESS_ID=AD.ROWID_OBJECT
where AD.LAST_ROWID_SYSTEM='DATAFACTORY' and AD.HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_ORGANIZATION_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
) X
inner join  CUSTOMER_CREATED_SRC_UPD Y on X.PARTY_ID=Y.ROWID_OBJECT
)
group by year(A.CREATE_DATE),month(A.CREATE_DATE),COUNTRY_CODE,TYPE


----updated DF systems


insert into MDM_CUSTOM..Customer_Report_Detailed
select 
COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(X.HIST_CREATE_DATE),'-',year(X.HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Updated DF-CRM' as Category 
from 
(
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_PERSON_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_B_PHONE_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(AD.HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_REL_PARTY_ADDRESS_HIST RL inner join C_B_ADDRESS_HIST AD on RL.ADDRESS_ID=AD.ROWID_OBJECT
where AD.LAST_ROWID_SYSTEM='DATAFACTORY' and AD.HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_ORGANIZATION_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
) X
inner join  CUSTOMER_CREATED_SRC_UPD Y on X.PARTY_ID=Y.ROWID_OBJECT
where Y.LAST_ROWID_SYSTEM='CRM'
group by year(X.HIST_CREATE_DATE),month(X.HIST_CREATE_DATE),Y.COUNTRY_ISO2_CODE,Y.PARTY_TYPE_CODE

union


select 
COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(X.HIST_CREATE_DATE),'-',year(X.HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Updated DF-Mittbilhold' as Category 
from 
(
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_PERSON_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_B_PHONE_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(AD.HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_REL_PARTY_ADDRESS_HIST RL inner join C_B_ADDRESS_HIST AD on RL.ADDRESS_ID=AD.ROWID_OBJECT
where AD.LAST_ROWID_SYSTEM='DATAFACTORY' and AD.HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_ORGANIZATION_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
) X
inner join  CUSTOMER_CREATED_SRC_UPD Y on X.PARTY_ID=Y.ROWID_OBJECT
where Y.LAST_ROWID_SYSTEM='MITTBILHOLD'
group by year(X.HIST_CREATE_DATE),month(X.HIST_CREATE_DATE),Y.COUNTRY_ISO2_CODE,Y.PARTY_TYPE_CODE

union


select 
Y.COUNTRY_ISO2_CODE,Y.PARTY_TYPE_CODE,concat(month(X.HIST_CREATE_DATE),'-',year(X.HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Updated DF-Customer Search' as Category 
from 
(
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_PERSON_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_B_PHONE_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(AD.HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_REL_PARTY_ADDRESS_HIST RL inner join C_B_ADDRESS_HIST AD on RL.ADDRESS_ID=AD.ROWID_OBJECT
where AD.LAST_ROWID_SYSTEM='DATAFACTORY' and AD.HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_ORGANIZATION_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
) X
inner join  CUSTOMER_CREATED_SRC_UPD Y on X.PARTY_ID=Y.ROWID_OBJECT
where Y.LAST_ROWID_SYSTEM='CUSTOMERLOOKUP'
group by year(X.HIST_CREATE_DATE),month(X.HIST_CREATE_DATE),Y.COUNTRY_ISO2_CODE,Y.PARTY_TYPE_CODE

union


select 
Y.COUNTRY_ISO2_CODE,Y.PARTY_TYPE_CODE,concat(month(X.HIST_CREATE_DATE),'-',year(X.HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Updated DF-Ecom' as Category 
from 
(
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_PERSON_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_B_PHONE_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(AD.HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_REL_PARTY_ADDRESS_HIST RL inner join C_B_ADDRESS_HIST AD on RL.ADDRESS_ID=AD.ROWID_OBJECT
where AD.LAST_ROWID_SYSTEM='DATAFACTORY' and AD.HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_ORGANIZATION_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
) X
inner join  CUSTOMER_CREATED_SRC_UPD Y on X.PARTY_ID=Y.ROWID_OBJECT
where Y.LAST_ROWID_SYSTEM='ECOMORDERBACKE'
group by year(X.HIST_CREATE_DATE),month(X.HIST_CREATE_DATE),Y.COUNTRY_ISO2_CODE,Y.PARTY_TYPE_CODE

union

select 
Y.COUNTRY_ISO2_CODE,Y.PARTY_TYPE_CODE,concat(month(X.HIST_CREATE_DATE),'-',year(X.HIST_CREATE_DATE)) as created_Month_Year
,count(distinct X.PARTY_ID) as count,'Updated DF-MDM' as Category 
from 
(
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_PERSON_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_B_PHONE_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(AD.HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_REL_PARTY_ADDRESS_HIST RL inner join C_B_ADDRESS_HIST AD on RL.ADDRESS_ID=AD.ROWID_OBJECT
where AD.LAST_ROWID_SYSTEM='DATAFACTORY' and AD.HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_ORGANIZATION_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
) X
inner join  CUSTOMER_CREATED_SRC_UPD Y on X.PARTY_ID=Y.ROWID_OBJECT
where Y.LAST_ROWID_SYSTEM='MDM'
group by year(X.HIST_CREATE_DATE),month(X.HIST_CREATE_DATE),Y.COUNTRY_ISO2_CODE,Y.PARTY_TYPE_CODE

union

select 
Y.COUNTRY_ISO2_CODE,Y.PARTY_TYPE_CODE,concat(month(X.HIST_CREATE_DATE),'-',year(X.HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Updated DF-MNET' as Category 
from 
(
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_PERSON_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_B_PHONE_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(AD.HIST_CREATE_DATE as date) as HIST_CREATE_DATE from C_REL_PARTY_ADDRESS_HIST RL inner join C_B_ADDRESS_HIST AD on RL.ADDRESS_ID=AD.ROWID_OBJECT
where AD.LAST_ROWID_SYSTEM='DATAFACTORY' and AD.HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
union
(select distinct PARTY_ID,cast(HIST_CREATE_DATE as date) as HIST_CREATE_DATE  from C_B_ORGANIZATION_HIST where LAST_ROWID_SYSTEM='DATAFACTORY' and HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
) X
inner join  CUSTOMER_CREATED_SRC_UPD Y on X.PARTY_ID=Y.ROWID_OBJECT
where Y.LAST_ROWID_SYSTEM='MNET'
group by year(X.HIST_CREATE_DATE),month(X.HIST_CREATE_DATE),Y.COUNTRY_ISO2_CODE,Y.PARTY_TYPE_CODE



----Updated-Total

insert into MDM_CUSTOM..Customer_Report_Detailed
select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(Z.HIST_CREATE_DATE),'-',year(Z.HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Updated-Total' as Category 
from (
select distinct X.*,PHIST.PARTY_TYPE_CODE,PHIST.COUNTRY_ISO2_CODE 
from (
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_PERSON_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_ORGANIZATION_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_PHONE_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE ,LAST_ROWID_SYSTEM 
from C_B_ELECTRONIC_ADDRESS_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct RL.PARTY_ID,cast(ad.HIST_CREATE_DATE as date) as HIST_CREATE_DATE,AD.LAST_ROWID_SYSTEM
from C_REL_PARTY_ADDRESS_HIST RL
inner join C_B_ADDRESS_HIST AD on RL.ADDRESS_ID=AD.ROWID_OBJECT
where AD.HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and RL.NON_LEGAL_SUBORG_ID is null
and cast(AD.LAST_UPDATE_DATE as datetime)<>cast(AD.CREATE_DATE as datetime)
)X inner join CUSTOMER_CREATED_SRC_UPD PHIST on X.PARTY_ID=PHIST.ROWID_OBJECT

) Z 
--where TYPE='P'
--and COUNTRY_CODE='NO'
group by year(HIST_CREATE_DATE),month(HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE
order by year(HIST_CREATE_DATE),month(HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE


---Updated systems


insert into MDM_CUSTOM..Customer_Report_Detailed

select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(Z.HIST_CREATE_DATE),'-',year(Z.HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Updated-CRM' as Category 
from (
select distinct X.*,PHIST.PARTY_TYPE_CODE,PHIST.COUNTRY_ISO2_CODE 
from (
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_PERSON_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_ORGANIZATION_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_PHONE_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE ,LAST_ROWID_SYSTEM 
from C_B_ELECTRONIC_ADDRESS_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct RL.PARTY_ID,cast(ad.HIST_CREATE_DATE as date) as HIST_CREATE_DATE,AD.LAST_ROWID_SYSTEM
from C_REL_PARTY_ADDRESS_HIST RL
inner join C_B_ADDRESS_HIST AD on RL.ADDRESS_ID=AD.ROWID_OBJECT
where AD.HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(AD.LAST_UPDATE_DATE as datetime)<>cast(AD.CREATE_DATE as datetime)
)X inner join CUSTOMER_CREATED_SRC_UPD PHIST on X.PARTY_ID=PHIST.ROWID_OBJECT
) Z 
where LAST_ROWID_SYSTEM='CRM'
group by year(HIST_CREATE_DATE),month(HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE

union

select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(Z.HIST_CREATE_DATE),'-',year(Z.HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Updated-Customer Search' as Category 
from (
select distinct X.*,PHIST.PARTY_TYPE_CODE,PHIST.COUNTRY_ISO2_CODE 
from (
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_PERSON_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_ORGANIZATION_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_PHONE_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE ,LAST_ROWID_SYSTEM 
from C_B_ELECTRONIC_ADDRESS_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct RL.PARTY_ID,cast(ad.HIST_CREATE_DATE as date) as HIST_CREATE_DATE,AD.LAST_ROWID_SYSTEM
from C_REL_PARTY_ADDRESS_HIST RL
inner join C_B_ADDRESS_HIST AD on RL.ADDRESS_ID=AD.ROWID_OBJECT
where AD.HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(AD.LAST_UPDATE_DATE as datetime)<>cast(AD.CREATE_DATE as datetime)
)X inner join CUSTOMER_CREATED_SRC_UPD PHIST on X.PARTY_ID=PHIST.ROWID_OBJECT
) Z 
where LAST_ROWID_SYSTEM='CUSTOMERLOOKUP'
group by year(HIST_CREATE_DATE),month(HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE

union


select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(Z.HIST_CREATE_DATE),'-',year(Z.HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Updated-MDM' as Category 
from (
select distinct X.*,PHIST.PARTY_TYPE_CODE,PHIST.COUNTRY_ISO2_CODE 
from (
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_PERSON_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_ORGANIZATION_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_PHONE_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE ,LAST_ROWID_SYSTEM 
from C_B_ELECTRONIC_ADDRESS_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct RL.PARTY_ID,cast(ad.HIST_CREATE_DATE as date) as HIST_CREATE_DATE,AD.LAST_ROWID_SYSTEM
from C_REL_PARTY_ADDRESS_HIST RL
inner join C_B_ADDRESS_HIST AD on RL.ADDRESS_ID=AD.ROWID_OBJECT
where AD.HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(AD.LAST_UPDATE_DATE as datetime)<>cast(AD.CREATE_DATE as datetime)
)X inner join CUSTOMER_CREATED_SRC_UPD PHIST on X.PARTY_ID=PHIST.ROWID_OBJECT
) Z 
where LAST_ROWID_SYSTEM='MDM'
group by year(HIST_CREATE_DATE),month(HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE

union

select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(Z.HIST_CREATE_DATE),'-',year(Z.HIST_CREATE_DATE)) as created_Month_Year
,count(1) as count,'Updated-Mittbilhold' as Category 
from (
select distinct X.*,PHIST.PARTY_TYPE_CODE,PHIST.COUNTRY_ISO2_CODE 
from (
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_PERSON_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_ORGANIZATION_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE,LAST_ROWID_SYSTEM 
from C_B_PHONE_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct PARTY_ID,cast (HIST_CREATE_DATE as date) as HIST_CREATE_DATE ,LAST_ROWID_SYSTEM 
from C_B_ELECTRONIC_ADDRESS_HIST
where HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(LAST_UPDATE_DATE as datetime)<>cast(CREATE_DATE as datetime)
union
select distinct RL.PARTY_ID,cast(ad.HIST_CREATE_DATE as date) as HIST_CREATE_DATE,AD.LAST_ROWID_SYSTEM
from C_REL_PARTY_ADDRESS_HIST RL
inner join C_B_ADDRESS_HIST AD on RL.ADDRESS_ID=AD.ROWID_OBJECT
where AD.HIST_CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and NON_LEGAL_SUBORG_ID is null
and cast(AD.LAST_UPDATE_DATE as datetime)<>cast(AD.CREATE_DATE as datetime)
)X inner join CUSTOMER_CREATED_SRC_UPD PHIST on X.PARTY_ID=PHIST.ROWID_OBJECT
) Z 
where LAST_ROWID_SYSTEM='MITTBILHOLD'
group by year(HIST_CREATE_DATE),month(HIST_CREATE_DATE),COUNTRY_ISO2_CODE,PARTY_TYPE_CODE;


--identified merged systems

insert into MDM_CUSTOM..Customer_Report_Detailed
select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(B.MERGE_DATE),'-',year(B.MERGE_DATE)) as created_Month_Year
,count(1) as count,'Identified Duplicates Merged-MNET' as Category
from CUSTOMER_CREATED_SRC_UPD X
inner join C_B_PARTY_HMRG B on X.ROWID_OBJECT=B.SRC_ROWID_OBJECT
where B.UNMERGE_DATE is null
and MERGE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and X.LAST_ROWID_SYSTEM='MNET'
group by year(B.MERGE_DATE),month(B.MERGE_DATE),X.PARTY_TYPE_CODE,X.COUNTRY_ISO2_CODE
union
select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(B.MERGE_DATE),'-',year(B.MERGE_DATE)) as created_Month_Year
,count(1) as count,'Identified Duplicates Merged-Customer Search' as Category
from CUSTOMER_CREATED_SRC_UPD X
inner join C_B_PARTY_HMRG B on X.ROWID_OBJECT=B.SRC_ROWID_OBJECT
where B.UNMERGE_DATE is null
and MERGE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and X.LAST_ROWID_SYSTEM='CUSTOMERLOOKUP'
group by year(B.MERGE_DATE),month(B.MERGE_DATE),X.PARTY_TYPE_CODE,X.COUNTRY_ISO2_CODE
union
select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(B.MERGE_DATE),'-',year(B.MERGE_DATE)) as created_Month_Year
,count(1) as count,'Identified Duplicates Merged-Mittbilhold' as Category
from CUSTOMER_CREATED_SRC_UPD X
inner join C_B_PARTY_HMRG B on X.ROWID_OBJECT=B.SRC_ROWID_OBJECT
where B.UNMERGE_DATE is null
and MERGE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and X.LAST_ROWID_SYSTEM='MITTBILHOLD'
group by year(B.MERGE_DATE),month(B.MERGE_DATE),X.PARTY_TYPE_CODE,X.COUNTRY_ISO2_CODE
union
select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(B.MERGE_DATE),'-',year(B.MERGE_DATE)) as created_Month_Year
,count(1) as count,'Identified Duplicates Merged-CRM' as Category
from CUSTOMER_CREATED_SRC_UPD X
inner join C_B_PARTY_HMRG B on X.ROWID_OBJECT=B.SRC_ROWID_OBJECT
where B.UNMERGE_DATE is null
and MERGE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and X.LAST_ROWID_SYSTEM='CRM'
group by year(B.MERGE_DATE),month(B.MERGE_DATE),X.PARTY_TYPE_CODE,X.COUNTRY_ISO2_CODE


--identified merged total systems


insert into MDM_CUSTOM..Customer_Report_Detailed
select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(Z.CREATE_DATE),'-',year(Z.CREATE_DATE)) as created_Month_Year
,count(1) as count,'Identified Duplicates-Customer Search' as Category
from 
(select X.*,B.CREATE_DATE
from CUSTOMER_CREATED_SRC_UPD X
inner join C_B_PARTY_MTCH B on X.ROWID_OBJECT=B.ROWID_OBJECT_MATCHED
where  B.CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
union
select X.*,B.CREATE_DATE
from CUSTOMER_CREATED_SRC_UPD X
inner join C_B_PARTY_MTCH B on X.ROWID_OBJECT=B.ROWID_OBJECT
where  B.CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
union
select X.*,B.MERGE_DATE
from CUSTOMER_CREATED_SRC_UPD X
inner join C_B_PARTY_HMRG B on X.ROWID_OBJECT=B.SRC_ROWID_OBJECT
where B.UNMERGE_DATE is null
and MERGE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
) Z
where Z.LAST_ROWID_SYSTEM='CUSTOMERLOOKUP'
group by year(Z.CREATE_DATE),month(Z.CREATE_DATE),Z.PARTY_TYPE_CODE,Z.COUNTRY_ISO2_CODE
union
select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(Z.CREATE_DATE),'-',year(Z.CREATE_DATE)) as created_Month_Year
,count(1) as count,'Identified Duplicates-CRM' as Category
from 
(select X.*,B.CREATE_DATE
from CUSTOMER_CREATED_SRC_UPD X
inner join C_B_PARTY_MTCH B on X.ROWID_OBJECT=B.ROWID_OBJECT_MATCHED
where  B.CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
union
select X.*,B.CREATE_DATE
from CUSTOMER_CREATED_SRC_UPD X
inner join C_B_PARTY_MTCH B on X.ROWID_OBJECT=B.ROWID_OBJECT
where  B.CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
union
select X.*,B.MERGE_DATE
from CUSTOMER_CREATED_SRC_UPD X
inner join C_B_PARTY_HMRG B on X.ROWID_OBJECT=B.SRC_ROWID_OBJECT
where B.UNMERGE_DATE is null
and MERGE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
) Z
where Z.LAST_ROWID_SYSTEM='CRM'
group by year(Z.CREATE_DATE),month(Z.CREATE_DATE),Z.PARTY_TYPE_CODE,Z.COUNTRY_ISO2_CODE
union
select COUNTRY_ISO2_CODE,PARTY_TYPE_CODE,concat(month(Z.CREATE_DATE),'-',year(Z.CREATE_DATE)) as created_Month_Year
,count(1) as count,'Identified Duplicates-Mittbilhold' as Category
from 
(select X.*,B.CREATE_DATE
from CUSTOMER_CREATED_SRC_UPD X
inner join C_B_PARTY_MTCH B on X.ROWID_OBJECT=B.ROWID_OBJECT_MATCHED
where  B.CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
union
select X.*,B.CREATE_DATE
from CUSTOMER_CREATED_SRC_UPD X
inner join C_B_PARTY_MTCH B on X.ROWID_OBJECT=B.ROWID_OBJECT
where  B.CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
union
select X.*,B.MERGE_DATE
from CUSTOMER_CREATED_SRC_UPD X
inner join C_B_PARTY_HMRG B on X.ROWID_OBJECT=B.SRC_ROWID_OBJECT
where B.UNMERGE_DATE is null
and MERGE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
) Z
where Z.LAST_ROWID_SYSTEM='MITTBILHOLD'
group by year(Z.CREATE_DATE),month(Z.CREATE_DATE),Z.PARTY_TYPE_CODE,Z.COUNTRY_ISO2_CODE

--Merged total


TRUNCATE TABLE MDM_CUSTOM..CUSTOMERS_MERGED ;

INSERT INTO MDM_CUSTOM..CUSTOMERS_MERGED 
SELECT DISTINCT MERGED.SRC_ROWID_OBJECT,PB.ROWID_OBJECT as TGT_ROWID_OBJECT,MERGED.MERGE_DATE
,PB.COUNTRY_CODE,PB.TYPE,ROWID_MATCH_RULE
FROM 
(SELECT SRC_ROWID_OBJECT,TGT_ROWID_OBJECT,MERGE_DATE  ,ROWID_MATCH_RULE
FROM C_B_PARTY_HMRG HMRG
WHERE MERGE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
AND UNMERGE_DATE IS NULL
AND NOT EXISTS (SELECT 1 FROM C_B_PARTY PB
            WHERE HMRG.SRC_ROWID_OBJECT=PB.ROWID_OBJECT)
AND (EXISTS (SELECT 1 FROM MDM_CUSTOM..C_B_PARTY_HIST HIST
            WHERE HMRG.SRC_ROWID_OBJECT=HIST.ROWID_OBJECT)
OR EXISTS  (SELECT 1 FROM C_B_PARTY_HIST HIST
            WHERE HMRG.SRC_ROWID_OBJECT=HIST.ROWID_OBJECT)
))MERGED
LEFT JOIN C_B_PARTY_XREF PX ON MERGED.TGT_ROWID_OBJECT=PX.ORIG_ROWID_OBJECT
LEFT JOIN C_B_PARTY PB ON  (PX.ROWID_OBJECT=PB.ROWID_OBJECT)
WHERE PB.HUB_STATE_IND='1';

-----Customer Merged
insert into MDM_CUSTOM..Customer_Report_Detailed
select Merged.COUNTRY_CODE,Merged.TYPE,concat(month(MERGE_DATE),'-',year(MERGE_DATE)) as Merged_Month_Year
,count(1) as count, 'Customer Merged' as Category 
from (
select * from 
MDM_Custom..Customers_Merged Merged
where MERGE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
) Merged
group by year(MERGE_DATE),month(MERGE_DATE),Merged.COUNTRY_CODE,Merged.TYPE;

---customer deleted


insert into MDM_CUSTOM..Customer_Report_Detailed
select COUNTRY_CODE,TYPE,concat(month(LAST_UPDATE_DATE),'-',year(LAST_UPDATE_DATE)) as created_Month_Year
,count(1) as count,'Customer Deleted' as Category
from (
select distinct ROWID_OBJECT,LAST_UPDATE_DATE,TYPE,COUNTRY_CODE from c_b_party 
where HUB_STATE_IND='-1'
and LAST_UPDATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and TYPE in ('P','O')
union
select distinct PHIST.ROWID_OBJECT ,PHIST.LAST_UPDATE_DATE,PARTY_TYPE_CODE,COUNTRY_ISO2_CODE
from MDM_CUSTOM..c_b_party PHIST
left join MDM_Custom..C_B_PARTY_SRC_COUNTRY SRC on PHIST.ROWID_OBJECT=SRC.PARTY_ID and SRC.HUB_STATE_IND='1' and COUNTRY_ISO2_CODE is not null
where PHIST.HUB_STATE_IND='-1'
and PHIST.LAST_UPDATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
and PARTY_TYPE_CODE in ('P','O')
)Deleted
where ROWID_OBJECT not in (select * from MDM_Custom..DELETE_PARTY_LIST)
group by year(LAST_UPDATE_DATE),month(LAST_UPDATE_DATE),COUNTRY_CODE,TYPE;

--------- Potential Duplicates

insert into MDM_CUSTOM..Customer_Report_Detailed
select P.COUNTRY_CODE,P.TYPE,concat(month(X.CREATE_DATE),'-',year(X.CREATE_DATE)) as Merged_Month_Year
,count(1) as count, 'Potential Duplicates' as Category 
--SELECT  YEAR(X.CREATE_DATE) AS YEAR,MONTH(X.CREATE_DATE) AS MONTH,P.COUNTRY_CODE,P.TYPE,COUNT(1) AS COUNT
FROM
(SELECT ROWID_OBJECT,MIN(CREATE_DATE) AS CREATE_DATE FROM (
SELECT ROWID_OBJECT,CREATE_DATE FROM C_B_PARTY_MTCH
UNION
SELECT ROWID_OBJECT_MATCHED,CREATE_DATE FROM C_B_PARTY_MTCH
)X GROUP BY ROWID_OBJECT
) X
INNER JOIN C_B_PARTY P ON X.ROWID_OBJECT=P.ROWID_OBJECT
where X.CREATE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
GROUP BY YEAR(X.CREATE_DATE),MONTH(X.CREATE_DATE),P.COUNTRY_CODE,P.TYPE
ORDER BY YEAR(X.CREATE_DATE),MONTH(X.CREATE_DATE),P.COUNTRY_CODE,P.TYPE



----------- Customer Merged Auto

insert into MDM_CUSTOM..Customer_Report_Detailed
  select Merged.COUNTRY_CODE,Merged.TYPE,concat(month(MERGE_DATE),'-',year(MERGE_DATE)) as Merged_Month_Year
,count(1) as count, 'Customer Merged Auto' as Category 
from (
select * from 
MDM_Custom..Customers_Merged Merged
where MERGE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
) Merged
where   (ROWID_MATCH_RULE  in (select ROWID_MATCH_RULE from C_REPAR_MATCH_RULE))
group by year(MERGE_DATE),month(MERGE_DATE),Merged.COUNTRY_CODE,Merged.TYPE;

-------------------- 'Customer Merged Semi Auto
insert into MDM_CUSTOM..Customer_Report_Detailed
  select Merged.COUNTRY_CODE,Merged.TYPE,concat(month(MERGE_DATE),'-',year(MERGE_DATE)) as Merged_Month_Year
,count(1) as count, 'Customer Merged Semi Auto' as Category 
from (
select * from 
MDM_Custom..Customers_Merged Merged
where MERGE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
) Merged
where   (ROWID_MATCH_RULE  in ('ML'))
group by year(MERGE_DATE),month(MERGE_DATE),Merged.COUNTRY_CODE,Merged.TYPE;

-------------------- Customer Merged Manual
insert into MDM_CUSTOM..Customer_Report_Detailed
  select Merged.COUNTRY_CODE,Merged.TYPE,concat(month(MERGE_DATE),'-',year(MERGE_DATE)) as Merged_Month_Year
,count(1) as count, 'Customer Merged Manual' as Category 
from (
select * from 
MDM_Custom..Customers_Merged Merged
where MERGE_DATE>DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
) Merged
where    (ROWID_MATCH_RULE  not in ('ML') and ROWID_MATCH_RULE not in (select ROWID_MATCH_RULE from C_REPAR_MATCH_RULE))
group by year(MERGE_DATE),month(MERGE_DATE),Merged.COUNTRY_CODE,Merged.TYPE;



-------------------- Total Parties
DECLARE 


 @SQL VARCHAR(MAX) = '',
 @orderByClause varchar(5000),
 @whereCluase varchar(5000),
 @categoryList varchar(5000);



BEGIN
drop table MDM_CUSTOM..Customer_Report_Detailed_Overall;
 set @categoryList='[Total Parties],
[Calls to DF],
[Created-Total],
[Created-CRM],
[Created-Customer Search],
[Created-Mittbilhold],
[Updates from DF],
[Updates from DF Not Used],
[Updated-Total],
[Updated-CRM],
[Updated-Customer Search],
[Updated-MDM],
[Updated-Mittbilhold],
[Updated DF-CRM],
[Updated DF-Customer Search],
[Updated DF-MDM],
[Updated DF-Mittbilhold],
[Updated DF-MNET],
[Customer Deleted],
[Accumulative Potential Duplicates],
[Potential Duplicates],
[Customer Merged],
[Customer Merged Auto],
[Customer Merged Manual],
[Customer Merged Semi Auto],
[Identified Duplicates-CRM],
[Identified Duplicates-Customer Search],
[Identified Duplicates-Mittbilhold],
[Identified Duplicates Merged-CRM],
[Identified Duplicates Merged-Customer Search],
[Identified Duplicates Merged-Mittbilhold],
[Identified Duplicates Merged-MNET],
[INCORRECT],
[INVALID],
[INCOMPLETE],
[DUPLICATE],
[OVERALL]';


set @whereCluase = 'where COUNTRY_ISO2_CODE is not null
and PARTY_TYPE_CODE in (''P'',''O'')';


set @orderByClause = 'order by  
               case when Country=''Norway'' then 1
               when Country=''Estonia'' then 2
			   when Country=''Latvia'' then 3
			   when Country=''Lithuania'' then 4
			   else 5 end ,
		      [Party Type] desc,
			   cast (Month as date) desc'



 SET @SQL ='
 select * into MDM_CUSTOM..Customer_Report_Detailed_Overall from (
 SELECT * FROM 
(SELECT concat(''01.'',case when len(substring(CREATED_MONTH_YEAR,0,charindex(''-'',CREATED_MONTH_YEAR)))=1 then concat(''0'',substring(CREATED_MONTH_YEAR,0,charindex(''-'',CREATED_MONTH_YEAR))) else substring(CREATED_MONTH_YEAR,0,charindex(''-'',CREATED_MONTH_YEAR)) end,''.'', substring(CREATED_MONTH_YEAR,charindex(''-'',CREATED_MONTH_YEAR)+1,len(CREATED_MONTH_YEAR))) as "Month"
  ,case when COUNTRY_ISO2_CODE=''NO'' then ''Norway''
   when COUNTRY_ISO2_CODE=''EE'' then ''Estonia''
  when COUNTRY_ISO2_CODE=''LV'' then ''Latvia''
   else ''Lithuania'' end  as Country,
case when PARTY_TYPE_CODE=''P'' then ''Person'' else ''Organization'' end as [Party Type]
,count,Category as Attribute
FROM MDM_CUSTOM..Customer_Report_Detailed '+@whereCluase+'
)AS SOURCETABLE PIVOT(MAX([COUNT]) FOR [Attribute] IN (' + @categoryList + ')) AS PIVOTTABLE )X where cast(Month as date)>=''2020-01-01'''+@orderByClause;

exec(@sql);



END



-----------------------------job load dtae-----------

Alter table  MDM_CUSTOM..Customer_Report_Detailed_Overall ADD JOBLOADDATE DATE;



----------------- inserting the 2020 2021 data--------
delete from MDM_CUSTOM..Customer_Report_Detailed_Overall where month like'%2020' or  month like'%2021';

insert into MDM_CUSTOM..Customer_Report_Detailed_Overall select * from MDM_Custom..Customer_Report_Detailed_Overall_old;

UPDATE MDM_Custom..Customer_Report_Detailed_Overall SET JOBLOADDATE=getdate();

------insert the current months record in the temp table
delete  from MDM_Custom..Customer_Report_Detailed_Exists where month=format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy');

insert into MDM_Custom..Customer_Report_Detailed_Exists 
select MONTH,Country,[Party Type],[Accumulative Potential Duplicates],[Potential Duplicates],[Customer Merged],[Customer Merged Auto],[Customer Merged Manual],[Customer Merged Semi Auto] from MDM_Custom..Customer_Report_Detailed_Overall where month=format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy') order by CAST(MONTH as date) desc,Country ;

--------Calculate Accumulative Potential Duplicates


update MDM_Custom..Customer_Report_Detailed_Exists
set [Accumulative Potential Duplicates] =
(
select
(
isnull(cast(prev.[Accumulative Potential Duplicates] as int),0)
+
isnull(cast(curr.[Potential Duplicates] as int),0)
-
isnull(cast(curr.[Customer Merged Manual] as int),0)
-
isnull(cast(curr.[Customer Merged Semi Auto] as int),0)
)  [Accumulative Potential Duplicates]
from
(
select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Norway'
and [Party Type]='Person'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),'dd.MM.yyyy')
) AS prev,
(select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Norway'
and [Party Type]='Person'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy')
)AS curr
)
where country='Norway'
and [Party Type]='Person'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy');

------orga


update MDM_Custom..Customer_Report_Detailed_Exists
set [Accumulative Potential Duplicates] =
(
select
(
isnull(cast(prev.[Accumulative Potential Duplicates] as int),0)
+
isnull(cast(curr.[Potential Duplicates] as int),0)
-
isnull(cast(curr.[Customer Merged Manual] as int),0)
-
isnull(cast(curr.[Customer Merged Semi Auto] as int),0)
)  [Accumulative Potential Duplicates]
from
(
select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Norway'
and [Party Type]='Organization'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),'dd.MM.yyyy')
) prev,
(select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Norway'
and [Party Type]='Organization'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy')
) as curr
)
where country='Norway'
and [Party Type]='Organization'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy');

-----
update MDM_Custom..Customer_Report_Detailed_Exists
set [Accumulative Potential Duplicates] =
(
select
(
isnull(cast(prev.[Accumulative Potential Duplicates] as int),0)
+
isnull(cast(curr.[Potential Duplicates] as int),0)
-
isnull(cast(curr.[Customer Merged Manual] as int),0)
-
isnull(cast(curr.[Customer Merged Semi Auto] as int),0)
)  [Accumulative Potential Duplicates]
from
(
select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Estonia'
and [Party Type]='Person'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),'dd.MM.yyyy')
) prev,
(select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Estonia'
and [Party Type]='Person'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy')
) as curr
)
where country='Estonia'
and [Party Type]='Person'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy');

------- Estonia Oraganization
update MDM_Custom..Customer_Report_Detailed_Exists
set [Accumulative Potential Duplicates]=
(
select
(
isnull(cast(prev.[Accumulative Potential Duplicates] as int),0)
+
isnull(cast(curr.[Potential Duplicates] as int),0)
-
isnull(cast(curr.[Customer Merged Manual] as int),0)
-
isnull(cast(curr.[Customer Merged Manual] as int),0)
)  [Accumulative Potential Duplicates]
from
(
select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Estonia'
and [Party Type]='Organization'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),'dd.MM.yyyy')
) as prev,
(select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Estonia'
and [Party Type]='Organization'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy')
) as curr
)
where country='Estonia'
and [Party Type]='Organization'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy');
-------- Latvia Person----
update MDM_Custom..Customer_Report_Detailed_Exists
set [Accumulative Potential Duplicates]=
(
select
(
isnull(cast(prev.[Accumulative Potential Duplicates] as int),0)
+
isnull(cast(curr.[Potential Duplicates] as int),0)
-
isnull(cast(curr.[Customer Merged Manual] as int),0)
-
isnull(cast(curr.[Customer Merged Manual] as int),0)
)  [Accumulative Potential Duplicates]
from
(
select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Latvia'
and [Party Type]='Person'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),'dd.MM.yyyy')
) as prev,
(select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Latvia'
and [Party Type]='Person'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy')
) as curr
)
where country='Latvia'
and [Party Type]='Person'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy');

------Latvia ORGANIZATION
update MDM_Custom..Customer_Report_Detailed_Exists
set [Accumulative Potential Duplicates]=
(
select
(
isnull(cast(prev.[Accumulative Potential Duplicates] as int),0)
+
isnull(cast(curr.[Potential Duplicates] as int),0)
-
isnull(cast(curr.[Customer Merged Manual] as int),0)
-
isnull(cast(curr.[Customer Merged Manual] as int),0)
)  [Accumulative Potential Duplicates]
from
(
select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Latvia'
and [Party Type]='Organization'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),'dd.MM.yyyy')
) as prev,
(select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Latvia'
and [Party Type]='Organization'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy')
) as curr
)
where country='Latvia'
and [Party Type]='Organization'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy');

---Lithuania Person----
update MDM_Custom..Customer_Report_Detailed_Exists
set [Accumulative Potential Duplicates]=
(
select
(
isnull(cast(prev.[Accumulative Potential Duplicates] as int),0)
+
isnull(cast(curr.[Potential Duplicates] as int),0)
-
isnull(cast(curr.[Customer Merged Manual] as int),0)
-
isnull(cast(curr.[Customer Merged Manual] as int),0)
)  [Accumulative Potential Duplicates]
from
(
select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Lithuania'
and [Party Type]='Person'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),'dd.MM.yyyy')
) as prev,
(select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Lithuania'
and [Party Type]='Person'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy')
) as curr
)
where country='Lithuania'
and [Party Type]='Person'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy');
-----Lithuania ORGANIZATION
update MDM_Custom..Customer_Report_Detailed_Exists
set [Accumulative Potential Duplicates]=
(
select
(
isnull(cast(prev.[Accumulative Potential Duplicates] as int),0)
+
isnull(cast(curr.[Potential Duplicates] as int),0)
-
isnull(cast(curr.[Customer Merged Manual] as int),0)
-
isnull(cast(curr.[Customer Merged Manual] as int),0)
)  [Accumulative Potential Duplicates]
from
(
select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Lithuania'
and [Party Type]='Organization'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),'dd.MM.yyyy')
) AS prev,
(select * from MDM_Custom..Customer_Report_Detailed_Exists
where country='Lithuania'
and [Party Type]='Organization'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy')
) AS curr
)
where country='Lithuania'
and [Party Type]='Organization'
and Month =format(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),'dd.MM.yyyy');

----Final report table Update the Accumulative Potential Duplicates

UPDATE MDM_Custom..Customer_Report_Detailed_Overall 
SET    [Accumulative Potential Duplicates]= t1.[Accumulative Potential Duplicates]
FROM MDM_Custom..Customer_Report_Detailed_Exists t1
INNER JOIN MDM_Custom..Customer_Report_Detailed_Overall T2
  ON  T2.Month = t1.Month 
and T2.Country=t1.Country
and T2.[Party Type]=t1.[Party Type];

----------------------------------- INCOMPLETE-------------------

UPDATE MDM_Custom..Customer_Report_Detailed_Overall
SET INCOMPLETE = dash.Total-dash.Count1
FROM MDM_Custom..Customer_Report_Detailed_Overall bck
INNER JOIN (
select distinct format(DATEADD(MONTH, DATEDIFF(MONTH, 0, d.load_date), 0),'dd.MM.yyyy') Month,t.DESCRIPTION as type,c.DESCRIPTION as country
,d.Count1,d.Total
from mdm_custom..Data_Quality_dashboard d, MDM_CM..C_LU_PARTY_TYPE t,MDM_CM..C_LU_COUNTRY c,
(
select distinct format(DATEADD(MONTH, DATEDIFF(MONTH, 0, max(load_date)), 0),'dd.MM.yyyy') Month,Type,Country_Code
from mdm_custom..Data_Quality_dashboard
where Subject_Area='COMPLETENESS'
group by Type,Country_Code,load_date
) d1
where
d.Subject_Area='COMPLETENESS'
and d1.Country_Code=d.Country_Code
and d1.Type=d.Type
and (format(d.load_date,'dd.MM.yyyy') =d1.Month
or format(d.load_date,'dd.MM.yyyy') ='31.01.2022')
and d.Type=t.CODE
and d.Country_Code=c.CODE
and d.Type=t.CODE
and d.Country_Code=c.CODE) as dash
ON (bck.[Party Type] = dash.type and bck.Country=dash.country and bck.Month=dash.Month);

------------  DUPLICATE ---------------

UPDATE MDM_Custom..Customer_Report_Detailed_Overall
SET DUPLICATE = dash.Total-dash.Count1
FROM MDM_Custom..Customer_Report_Detailed_Overall bck
INNER JOIN (
select distinct format(DATEADD(MONTH, DATEDIFF(MONTH, 0, d.load_date), 0),'dd.MM.yyyy') Month,t.DESCRIPTION as type,c.DESCRIPTION as country
,d.Count1,d.Total
from mdm_custom..Data_Quality_dashboard d, MDM_CM..C_LU_PARTY_TYPE t,MDM_CM..C_LU_COUNTRY c,
(
select distinct format(DATEADD(MONTH, DATEDIFF(MONTH, 0, max(load_date)), 0),'dd.MM.yyyy') Month,Type,Country_Code
from mdm_custom..Data_Quality_dashboard
where Subject_Area='UNIQUENESS'
group by Type,Country_Code,load_date
) d1
where
d.Subject_Area='UNIQUENESS'
and d1.Country_Code=d.Country_Code
and d1.Type=d.Type
and (format(d.load_date,'dd.MM.yyyy') =d1.Month
or format(d.load_date,'dd.MM.yyyy') ='31.01.2022')
and d.Type=t.CODE
and d.Country_Code=c.CODE
and d.Type=t.CODE
and d.Country_Code=c.CODE) as dash
ON (bck.[Party Type] = dash.type and bck.Country=dash.country and bck.Month=dash.Month);

----------------- INVALID------------

UPDATE MDM_Custom..Customer_Report_Detailed_Overall
SET INVALID = dash.Total-dash.Count1
FROM MDM_Custom..Customer_Report_Detailed_Overall bck
INNER JOIN (
select distinct format(DATEADD(MONTH, DATEDIFF(MONTH, 0, d.load_date), 0),'dd.MM.yyyy') Month,t.DESCRIPTION as type,c.DESCRIPTION as country
,d.Count1,d.Total
from mdm_custom..Data_Quality_dashboard d, MDM_CM..C_LU_PARTY_TYPE t,MDM_CM..C_LU_COUNTRY c,
(
select distinct format(DATEADD(MONTH, DATEDIFF(MONTH, 0, max(load_date)), 0),'dd.MM.yyyy') Month,Type,Country_Code
from mdm_custom..Data_Quality_dashboard
where Subject_Area='VALIDITY'
group by Type,Country_Code,load_date
) d1
where
d.Subject_Area='VALIDITY'
and d1.Country_Code=d.Country_Code
and d1.Type=d.Type
and (format(d.load_date,'dd.MM.yyyy') =d1.Month
or format(d.load_date,'dd.MM.yyyy') ='31.01.2022')
and d.Type=t.CODE
and d.Country_Code=c.CODE
and d.Type=t.CODE
and d.Country_Code=c.CODE) as dash
ON (bck.[Party Type] = dash.type and bck.Country=dash.country and bck.Month=dash.Month);

--------------------  INCORRECT-----------------

UPDATE MDM_Custom..Customer_Report_Detailed_Overall
SET INCORRECT = dash.Total-dash.Count1
FROM MDM_Custom..Customer_Report_Detailed_Overall bck
INNER JOIN (
select distinct format(DATEADD(MONTH, DATEDIFF(MONTH, 0, d.load_date), 0),'dd.MM.yyyy') Month,t.DESCRIPTION as type,c.DESCRIPTION as country
,d.Count1,d.Total
from mdm_custom..Data_Quality_dashboard d, MDM_CM..C_LU_PARTY_TYPE t,MDM_CM..C_LU_COUNTRY c,
(
select distinct format(DATEADD(MONTH, DATEDIFF(MONTH, 0, max(load_date)), 0),'dd.MM.yyyy') Month,Type,Country_Code
from mdm_custom..Data_Quality_dashboard
where Subject_Area='CORRECTNESS'
group by Type,Country_Code,load_date
) d1
where
d.Subject_Area='CORRECTNESS'
and d1.Country_Code=d.Country_Code
and d1.Type=d.Type
and (format(d.load_date,'dd.MM.yyyy') =d1.Month
or format(d.load_date,'dd.MM.yyyy') ='31.01.2022')
and d.Type=t.CODE
and d.Country_Code=c.CODE
and d.Type=t.CODE
and d.Country_Code=c.CODE) as dash
ON (bck.[Party Type] = dash.type and bck.Country=dash.country and bck.Month=dash.Month);

------------- OVERALL---------

UPDATE MDM_Custom..Customer_Report_Detailed_Overall
SET OVERALL = dash.Total-dash.Count1
FROM MDM_Custom..Customer_Report_Detailed_Overall bck
INNER JOIN (
select distinct format(DATEADD(MONTH, DATEDIFF(MONTH, 0, d.load_date), 0),'dd.MM.yyyy') Month,t.DESCRIPTION as type,c.DESCRIPTION as country
,d.Count1,d.Total
from mdm_custom..Data_Quality_dashboard d, MDM_CM..C_LU_PARTY_TYPE t,MDM_CM..C_LU_COUNTRY c,
(
select distinct format(DATEADD(MONTH, DATEDIFF(MONTH, 0, max(load_date)), 0),'dd.MM.yyyy') Month,Type,Country_Code
from mdm_custom..Data_Quality_dashboard
where Subject_Area='OVERALL'
group by Type,Country_Code,load_date
) d1
where
d.Subject_Area='OVERALL'
and d1.Country_Code=d.Country_Code
and d1.Type=d.Type
and (format(d.load_date,'dd.MM.yyyy') =d1.Month
or format(d.load_date,'dd.MM.yyyy') ='31.01.2022')
and d.Type=t.CODE
and d.Country_Code=c.CODE
and d.Type=t.CODE
and d.Country_Code=c.CODE) as dash
ON (bck.[Party Type] = dash.type and bck.Country=dash.country and bck.Month=dash.Month);

------ Consent report----
delete from MDM_custom..report_consent where date_field=cast(getdate() as date) ;

insert into MDM_custom..report_consent
select prty.COUNTRY_CODE, cnst.ACTIVE_CONSENT_FLAG,
count(prty.rowid_object) as count_of_party,cast(getdate() as date) as date_field
from MDM_CM..C_B_PARTY prty
inner join MDM_CM..C_B_PERSON per on prty.ROWID_OBJECT=per.PARTY_ID
inner join MDM_CM..C_B_CONSENT cnst on per.ROWID_OBJECT=cnst.PERSON_ID
where prty.HUB_STATE_IND=1 and COUNTRY_CODE is not null
group by prty.COUNTRY_CODE, cnst.ACTIVE_CONSENT_FLAG ;



----------------------Communication Preparation---
delete from MDM_custom..report_COMMUNICATION_PREF where date_field=cast(getdate() as date) ;


insert into MDM_custom..report_COMMUNICATION_PREF
select
prty.COUNTRY_CODE, per.ACTIVE_PREFERENCE_FLAG,
(select DESCRIPTION from MDM_CM..C_LU_BRAND where CODE=per.BRAND_ID) as brand,
(select DESCRIPTION from MDM_CM..C_LU_COMM_CHANNEL where CODE=per.COMMUNICATION_CHANNEL_ID) as COMMUNICATION_CHANNEL_ID,
count(prty.rowid_object) as count_of_party,cast(getdate() as date) as DATE_FIELD
from C_B_PARTY prty
inner join C_B_COMMUNICATION_PREF per on prty.ROWID_OBJECT=per.PARTY_ID
where prty.HUB_STATE_IND=1 and COUNTRY_CODE is not null and per.ACTIVE_PREFERENCE_FLAG is not null
group by prty.COUNTRY_CODE, per.ACTIVE_PREFERENCE_FLAG,per.BRAND_ID,per.COMMUNICATION_CHANNEL_ID ;


