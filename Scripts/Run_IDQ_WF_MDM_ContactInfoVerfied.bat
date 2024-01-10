@echo off
Start D:\Informatica\9.6.1\server\bin\Infacmd updateGatewayInfo -dn Domain_MOLLER_PROD -dg no000010smdip2:6005
Start D:\Informatica\9.6.1\server\bin\infacmd wfs startworkflow -sn DIS_MOLLER_PROD -dn Domain_MOLLER_PROD -un Administrator -pd !nfaAdmp0 -wf wf_MDM_ContactInfoVerified -a app_wf_MDM_ContactInfoVerified