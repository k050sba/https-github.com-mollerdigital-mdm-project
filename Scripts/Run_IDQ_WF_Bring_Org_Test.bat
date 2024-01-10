@echo off
call D:\Informatica\9.6.1\server\bin\infacmd updateGatewayInfo -dn Domain_MOLLER_PROD -dg no000010smdip1:6005
call D:\Informatica\9.6.1\server\bin\infacmd wfs startworkflow -sn DIS_MOLLER_PROD -dn Domain_MOLLER_PROD -un Administrator -pd !nfaAdmp0 -wf wf_Bring_Org_Test -a app_wf_Bring_Org_Test