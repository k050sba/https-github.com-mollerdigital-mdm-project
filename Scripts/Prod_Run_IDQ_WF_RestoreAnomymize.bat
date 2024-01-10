@echo off
REM Vi har fjernet Start foran linjen nedenfor
call D:\Informatica\10.2.0\server\bin\infacmd wfs startworkflow -sn DIS_PROD -dn Domain_MOLLER_PROD -un Administrator -pd !nfaAdmp0 -wf DataRestoreAnonymProcess -a DataRestoreAnonymProcessNewModel