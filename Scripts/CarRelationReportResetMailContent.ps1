$contentFile = "D:\Informatica\10.2.0\tomcat\bin\target\activateCarRelMailContent.csv"
(Get-Content $contentFile -TotalCount 1) | Set-Content $contentFile
$rejectRecFile = "D:\Informatica\10.2.0\tomcat\bin\target\actCarRelMailRejectPartyRec.csv"
(Get-Content $rejectRecFile -TotalCount 1) | Set-Content $rejectRecFile