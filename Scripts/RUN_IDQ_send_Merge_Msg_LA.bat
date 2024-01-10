@echo off
REM Vi har fjernet Start foran linjen nedenfor
call D:\Informatica\10.2.0\server\bin\infacmd updateGatewayInfo -dn Domain_MOLLER_PROD -dg no000010smdip1:6005
call D:\Informatica\10.2.0\server\bin\infacmd ms runmapping -sn DIS_PROD -dn Domain_MOLLER_PROD -un Administrator -pd !nfaAdmp0 -m M_SEND_MERGE_MSG_LA -a app_mp_Sync_Partyid_Mnet