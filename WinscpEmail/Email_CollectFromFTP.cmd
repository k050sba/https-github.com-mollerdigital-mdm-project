
echo off
D:\WinscpEmail\WinSCP.com /script=D:\WinscpEmail\Email_CollectFromFTP.txt
sleep 45 

copy /b D:\WinscpEmail\BouncedEmailDownloaded\full_bouncedEmailsList_%date:~-4,4%%date:~-7,2%%date:~-10,2%*.csv D:\WinscpEmail\BouncedEmailRenamed\full_bouncedEmailsList.csv

exit