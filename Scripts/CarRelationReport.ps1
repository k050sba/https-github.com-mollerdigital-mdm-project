$contentFile = "D:\Informatica\10.2.0\tomcat\bin\target\activateCarRelMailContent.csv"
#$rejectRecFile = "D:\Informatica\10.2.0\tomcat\bin\target\actCarRelMailRejectPartyRec.csv"

$mSubject = "Load Statistics: Car Relation Addition"

$loadStat = Get-Content -Path $contentFile |select-object -skip 1| Out-String
$mBody = $mBody + $loadStat

#$rejRecList = Get-Content -Path $rejectRecFile |select-object -skip 1| Out-String
#$mBody = $mBody + "`nRecords rejected as party id not associated to any active felles id in MDM:`n"
#$mBody = $mBody + $rejRecList

$From = "automation-monitor@moller.no"
$To = @("<shivadas.bayam@moller.no>","<Sridhar.s@moller.no>","<raman.srivastava@moller.no>","<abhijith.chalilmullath.janardhanan@moller.no>")
#$To = @("<pintu.santra@moller.no>")
$SMTPServer = "smtp.moller.no"
$SMTPPort = "40"
Send-MailMessage -To $To -from $From -Subject $msubject -Body $mBody -SmtpServer $SMTPServer
