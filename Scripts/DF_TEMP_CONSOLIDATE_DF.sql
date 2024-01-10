drop table mdm_custom..DF_TEMP_CONSOLIDATED_DF;

select distinct r.*,p.OBJECT_IDENTITY as datafactory_id into mdm_custom..DF_TEMP_CONSOLIDATED_DF from MDM_CM..DF_TEMP_CONSOLIDATED_RD r
left join C_B_PERSON_DETAIL p on p.DETAILS_ID=r.DETAILS_ID
where exists(select 1 from C_B_PERSON per where per.PARTY_ID=r.PARTY_ID)
union
select distinct r.*,o.OBJECT_IDENTITY as datafactory_id from MDM_CM..DF_TEMP_CONSOLIDATED_RD r
left join C_B_COMPANY_DETAIL o on o.DETAILS_ID=r.DETAILS_ID
where exists(select 1 from C_B_ORGANIZATION org where org.PARTY_ID=r.PARTY_ID);