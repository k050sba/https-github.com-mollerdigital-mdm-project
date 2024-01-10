sqlcmd -S SQLP2AGMDM\MDMP2 -U SQLMDMP -P sQ!mdmPP -i "D:\Scripts\MDM_CAPI_Compare_Dump\C_B_DEALER.sql" -h -1 -f 65001 -o D:\Scripts\MDM_CAPI_Compare_Dump\C_B_DEALER_NoHeader.csv -w 2000 -W -s "~"
tail --bytes=+4 D:\Scripts\MDM_CAPI_Compare_Dump\C_B_DEALER_NoHeader.csv D:\Scripts\MDM_CAPI_Compare_Dump\C_B_DEALER_NoHeader.csv
type D:\Scripts\MDM_CAPI_Compare_Dump\C_B_DEALER_Header.csv  D:\Scripts\MDM_CAPI_Compare_Dump\C_B_DEALER_NoHeader.csv > D:\Scripts\MDM_CAPI_Compare_Dump\C_B_DEALER.csv
RoboCopy \\no000010smdip1\d$\Scripts\MDM_CAPI_Compare_Dump \\no000010smdmcu\Repository\MDMShared\Prod_extract_CAPI_Compare_01032022\Temp C_B_DEALER.csv /MOV
del D:\Scripts\MDM_CAPI_Compare_Dump\C_B_DEALER_NoHeader.csv