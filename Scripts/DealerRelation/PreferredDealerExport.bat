sqlcmd -S SQLP2AGMDM\MDMP2 -U SQLMDMP -P sQ!mdmPP -i "D:\Scripts\DealerRelation\PreferredDealerExport.sql" -h -1 -o D:\Scripts\DealerRelation\PreferredDealerExport_NoHeader.csv -w 2000 -W -s ";"
type D:\Scripts\DealerRelation\PreferredDealerExport_Header.csv  D:\Scripts\DealerRelation\PreferredDealerExport_NoHeader.csv > D:\Scripts\DealerRelation\PreferredDealerExport.csv
RoboCopy \\no000010smdip1\d$\Scripts\DealerRelation \\NO000010sMDMCU\PROD_CACHE_BCK\PreferredDealerExport PreferredDealerExport.csv /MOV
copy \\NO000010sMDMCU\PROD_CACHE_BCK\PreferredDealerExport\PreferredDealerExport.csv "\\NO000010sMDMCU\PROD_CACHE_BCK\PreferredDealerExport\Archieve"
ren \\NO000010sMDMCU\PROD_CACHE_BCK\PreferredDealerExport\Archieve\PreferredDealerExport.csv "PreferredDealerExport_%date:/=-% %time::=-%.csv"
del D:\Scripts\DealerRelation\PreferredDealerExport_NoHeader.csv