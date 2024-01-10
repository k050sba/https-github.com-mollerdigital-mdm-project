drop table MDM_Custom..closed_car_relation;
select * into  MDM_Custom..closed_car_relation  from
(select count(1) closed_car_relation,DATEADD(month, DATEDIFF(month, -1, getdate()) -1, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
and LAST_UPDATE_DATE<GETDATE()
and (RELATION_END_DATE is not null )
and role_code  in('B','L') 
union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -2, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
and role_code  in('B','L') 
union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -3, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
and role_code  in('B','L') 
union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -4, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) 
and role_code  in('B','L') 
union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -5, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
and role_code  in('B','L') 
union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -6, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
and role_code  in('B','L') 
union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -7, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
and role_code  in('B','L') 
union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -8, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
and role_code  in('B','L') 
union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -9, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
and role_code  in('B','L') 
union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -10, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
and role_code  in('B','L') 
union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -11, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
and role_code  in('B','L') 
union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -12, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 12, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
and role_code  in('B','L')
)x

---------------------  closed bring
drop table MDM_custom..closed_car_relation_bring;
select * into MDM_custom..closed_car_relation_bring from(
select count(1) closed_car_relation_bring,DATEADD(month, DATEDIFF(month, -1, getdate()) -1, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
and LAST_UPDATE_DATE<GETDATE()
and (RELATION_END_DATE is not null )
and LAST_ROWID_SYSTEM='BRING'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -2, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
and LAST_ROWID_SYSTEM='BRING'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -3, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
and LAST_ROWID_SYSTEM='BRING'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -4, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) 
and LAST_ROWID_SYSTEM='BRING'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -5, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
and LAST_ROWID_SYSTEM='BRING'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -6, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
and LAST_ROWID_SYSTEM='BRING'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -7, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
and LAST_ROWID_SYSTEM='BRING'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -8, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
and LAST_ROWID_SYSTEM='BRING'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -9, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
and LAST_ROWID_SYSTEM='BRING'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -10, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
and LAST_ROWID_SYSTEM='BRING'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -11, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
and LAST_ROWID_SYSTEM='BRING'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -12, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 12, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
and LAST_ROWID_SYSTEM='BRING'
and role_code  in('B','L')
)y

----------- closed DF
drop table MDM_Custom..closed_car_relation_Data_factory;
select * into MDM_Custom..closed_car_relation_Data_factory from(
select count(1) closed_car_relation_Data_factory,DATEADD(month, DATEDIFF(month, -1, getdate()) -1, 0) as date_of_month  
from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
and LAST_UPDATE_DATE<GETDATE()
and (RELATION_END_DATE is not null )
and LAST_ROWID_SYSTEM='DATAFACTORY'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -2, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
and LAST_ROWID_SYSTEM='DATAFACTORY'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -3, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
and LAST_ROWID_SYSTEM='DATAFACTORY'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -4, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) 
and LAST_ROWID_SYSTEM='DATAFACTORY'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -5, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
and LAST_ROWID_SYSTEM='DATAFACTORY'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -6, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
and LAST_ROWID_SYSTEM='DATAFACTORY'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -7, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
and LAST_ROWID_SYSTEM='DATAFACTORY'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -8, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
and LAST_ROWID_SYSTEM='DATAFACTORY'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -9, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
and LAST_ROWID_SYSTEM='DATAFACTORY'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -10, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
and LAST_ROWID_SYSTEM='DATAFACTORY'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -11, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
and LAST_ROWID_SYSTEM='DATAFACTORY'
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -12, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and LAST_UPDATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 12, 0) 
and RELATION_END_DATE is not null 
and LAST_UPDATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
and LAST_ROWID_SYSTEM='DATAFACTORY'
and role_code  in('B','L')
)DF

-------------------- create car
drop table MDM_Custom..create_car_relation;
select * into MDM_Custom..create_car_relation from
(select count(1) create_car_relation,DATEADD(month, DATEDIFF(month, -1, getdate()) -1, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
and CREATE_DATE<GETDATE()
--and (RELATION_END_DATE is not null )
and role_code  in('B','L') union all 
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -2, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -3, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) 
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -4, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -5, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -6, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -7, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -8, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -9, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -10, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -11, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -12, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 12, 0) 
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
and role_code  in('B','L')
)z

------------------- create bring--
drop table MDM_Custom..create_car_relation_BRING

select * into MDM_Custom..create_car_relation_BRING from
(select count(1) create_car_relation_BRING,DATEADD(month, DATEDIFF(month, -1, getdate()) -1, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
and CREATE_DATE<GETDATE()
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='BRING')
--and (RELATION_END_DATE is not null )
and role_code  in('B','L') union all 
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -2, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='BRING')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -3, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='BRING')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -4, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='BRING')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -5, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='BRING')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -6, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='BRING')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -7, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='BRING')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -8, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='BRING')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -9, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='BRING')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -10, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='BRING')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -11, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='BRING')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -12, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 12, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='BRING')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
and role_code  in('B','L')
)A


--------- create DF--
drop table MDM_Custom..create_car_relation_datafactory;
select * into MDM_Custom..create_car_relation_datafactory from
(select count(1) create_car_relation_datafactory,DATEADD(month, DATEDIFF(month, -1, getdate()) -1, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
and CREATE_DATE<GETDATE()
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='DATAFACTORY')
--and (RELATION_END_DATE is not null )
and role_code  in('B','L') union all 
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -2, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='DATAFACTORY')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -3, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='DATAFACTORY')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -4, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='DATAFACTORY')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -5, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='DATAFACTORY')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -6, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='DATAFACTORY')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -7, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='DATAFACTORY')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -8, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='DATAFACTORY')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -9, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='DATAFACTORY')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -10, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='DATAFACTORY')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -11, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='DATAFACTORY')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -12, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and CREATE_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 12, 0) 
and exists(select 1 from  C_REL_PARTY_CAR_HIST where C_REL_PARTY_CAR.ROWID_OBJECT=C_REL_PARTY_CAR_HIST.ROWID_OBJECT and C_REL_PARTY_CAR_HIST.LAST_ROWID_SYSTEM='DATAFACTORY')
--and RELATION_END_DATE is not null 
and CREATE_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
and role_code  in('B','L')
)B


-------- active car ovell
drop table MDM_Custom..active_car_relation;
select * into MDM_Custom..active_car_relation from
(select count(1) active_car_relation,DATEADD(month, DATEDIFF(month, -1, getdate()) -1, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and RELATION_START_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
and (RELATION_END_DATE is null )
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -2, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and RELATION_START_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
and (RELATION_END_DATE is null 
or RELATION_END_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 1, 0) 
)
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -3, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and RELATION_START_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) 
and (RELATION_END_DATE is null 
or RELATION_END_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
)
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -4, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and RELATION_START_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
and (RELATION_END_DATE is null 
or RELATION_END_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) 
)
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -5, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and RELATION_START_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
and (RELATION_END_DATE is null 
or RELATION_END_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) 
)
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -6, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and RELATION_START_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
and (RELATION_END_DATE is null 
or RELATION_END_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) 
)
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -7, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and RELATION_START_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
and (RELATION_END_DATE is null 
or RELATION_END_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) 
)
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -8, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and RELATION_START_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
and (RELATION_END_DATE is null 
or RELATION_END_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) 
)
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -9, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and RELATION_START_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
and (RELATION_END_DATE is null 
or RELATION_END_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) 
)
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -10, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and RELATION_START_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
and (RELATION_END_DATE is null 
or RELATION_END_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) 
)
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -11, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and RELATION_START_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
and (RELATION_END_DATE is null 
or RELATION_END_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) 
)
and role_code  in('B','L') union all
select count(1),DATEADD(month, DATEDIFF(month, -1, getdate()) -12, 0) as date_of_month  from C_REL_PARTY_CAR 
where exists(select 1 from C_B_PARTY where C_B_PARTY.ROWID_OBJECT=C_REL_PARTY_CAR.PARTY_ID and COUNTRY_CODE='NO')
and RELATION_START_DATE<DATEADD(month, DATEDIFF(month, -1, getdate()) - 12, 0) 
and (RELATION_END_DATE is null 
or RELATION_END_DATE>DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) 
)
and role_code  in('B','L') 
)C

--------final table

drop table MDM_Custom..CarRelation_Daily;

select * into MDM_Custom..CarRelation_Daily from(
select a.date_of_month ,a.active_car_relation as TOTAL_ACTIVE_CAR_REL,d.create_car_relation as CREATE_CAR_REL,c.create_car_relation_BRING as CREAT_CAR_BRING,b.create_car_relation_datafactory as CREAT_CAR_DF,f.closed_car_relation as TOTAL_CLOSED_CAR_REL,
 g.closed_car_relation_Data_factory as CLOSED_CAR_DF,0 as CLOSED_CAR_BRING
  from MDM_Custom..active_car_relation a
  INNER JOIN MDM_Custom..create_car_relation_datafactory b ON a.date_of_month = b.date_of_month
  INNER JOIN MDM_Custom..create_car_relation_BRING c ON a.date_of_month = c.date_of_month
  INNER JOIN MDM_Custom..create_car_relation d ON a.date_of_month = d.date_of_month
  INNER JOIN  MDM_Custom..closed_car_relation_bring e ON a.date_of_month = e.date_of_month
  INNER JOIN  MDM_Custom..closed_car_relation f  ON a.date_of_month = f.date_of_month
  INNER JOIN MDM_Custom..closed_car_relation_Data_factory g  ON a.date_of_month = g.date_of_month) finaltable;

------------ delete current month record if exist in the table

delete from MDM_Custom..CarRelation_Daily_Final_Report where date_of_month= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0);
  
------insert current month record

  insert into MDM_Custom..CarRelation_Daily_Final_Report select * from  MDM_Custom..CarRelation_Daily where date_of_month=DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0);

----- calculate the currenet mont Total_Active_car_rel

  update MDM_Custom..CarRelation_Daily_Final_Report
set TOTAL_ACTIVE_CAR_REL=
(select(
isnull(cast(prev.TOTAL_ACTIVE_CAR_REL as int),0)
+
isnull(cast(curr.CREATE_CAR_REL as int),0)
-
isnull(cast(curr.TOTAL_CLOSED_CAR_REL as int),0)
)  TOTAL_ACTIVE_CAR_REL
from
(
select * from MDM_Custom..CarRelation_Daily_Final_Report
where date_of_month =DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)
) as prev,
(select * from MDM_Custom..CarRelation_Daily_Final_Report
where date_of_month =DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
) as curr
)
where date_of_month=DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
