@echo off
REM change CHCP to UTF-8
CHCP 65001>nul
type D:\Informatica\10.2.0\tomcat\bin\target\CARS_MOVED_Daily.out
echo.
echo Retailers for which cars were moved :
type D:\Informatica\10.2.0\tomcat\bin\target\CARS_MOVED_RETAILERS.out