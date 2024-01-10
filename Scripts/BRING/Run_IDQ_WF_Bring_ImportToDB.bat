@echo off
call D:\Informatica\10.2.0\server\bin\Infacmd updateGatewayInfo -dn Domain_MOLLER_PROD -dg no000010smdip2:6005
call D:\Informatica\10.2.0\server\bin\infacmd wfs startworkflow -sn DIS_PROD -dn Domain_MOLLER_PROD -un Administrator -pd !nfaAdmp0 -wf wf_Bring_Import_Til_Database -a app_wf_Bring_Import_Til_Database

