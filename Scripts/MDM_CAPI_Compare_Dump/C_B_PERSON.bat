﻿sqlcmd -S SQLP2AGMDM\MDMP2 -U SQLMDMP -P sQ!mdmPP -i "D:\Scripts\MDM_CAPI_Compare_Dump\C_B_PERSON.sql" -h -1 -f 65001 -o D:\Scripts\MDM_CAPI_Compare_Dump\C_B_PERSON_NoHeader.csv -w 2000 -W -s "~"
type D:\Scripts\MDM_CAPI_Compare_Dump\C_B_PERSON_Header.csv  D:\Scripts\MDM_CAPI_Compare_Dump\C_B_PERSON_NoHeader.csv > D:\Scripts\MDM_CAPI_Compare_Dump\C_B_PERSON.csv
RoboCopy \\no000010smdip1\d$\Scripts\MDM_CAPI_Compare_Dump \\no000010smdmcu\Repository\MDMShared\Prod_extract_CAPI_Compare_01032022 C_B_PERSON.csv /MOV
del D:\Scripts\MDM_CAPI_Compare_Dump\C_B_PERSON_NoHeader.csv