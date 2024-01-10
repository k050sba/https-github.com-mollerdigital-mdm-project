sqlcmd -S SQLP2AGMDM\MDMP2 -U SQLMDMP -P sQ!mdmPP -i "D:\Scripts\DealerRelation\DealerRelationExport.sql" -h -1 -o D:\Scripts\DealerRelation\CustomerResellerRelation_Noheaders.csv -W -s ";"
type D:\Scripts\DealerRelation\CustomerResellerRelation_Header.csv D:\Scripts\DealerRelation\CustomerResellerRelation_Noheaders.csv > D:\Scripts\DealerRelation\CustomerResellerRelation.csv
RoboCopy \\no000010smdip1\d$\Scripts\DealerRelation \\NO000010sMDMCU\PROD_CACHE_BCK\DealerRelationExport CustomerResellerRelation.csv /MOV
copy \\NO000010sMDMCU\PROD_CACHE_BCK\DealerRelationExport\CustomerResellerRelation.csv "\\NO000010sMDMCU\PROD_CACHE_BCK\DealerRelationExport\Archieve"
ren \\NO000010sMDMCU\PROD_CACHE_BCK\DealerRelationExport\Archieve\CustomerResellerRelation.csv "CustomerResellerRelation_%date:/=-% %time::=-%.csv"
del D:\Scripts\DealerRelation\CustomerResellerRelation_Noheaders.csv