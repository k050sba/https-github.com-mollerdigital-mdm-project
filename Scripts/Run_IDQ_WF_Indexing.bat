@echo off
REM Vi har fjernet Start foran linjen nedenfor
call D:\Informatica\10.2.0\server\bin\infacmd updateGatewayInfo -dn Domain_MOLLER_PROD -dg no000010smdip1:6005
call D:\Informatica\10.2.0\server\bin\infacmd wfs startworkflow -sn DIS_PROD -dn Domain_MOLLER_PROD -un Administrator -pd !nfaAdmp0 -wf wf_Batch_Indexing -a app_wf_Batch_Indexing >>D:\Scripts\Batch_Indexing.log
echo %date% %time%>>D:\Scripts\Batch_Indexing.log