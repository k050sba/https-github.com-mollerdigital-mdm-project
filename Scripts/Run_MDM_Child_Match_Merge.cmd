cmdkey.exe /add:no000010smdmp2 /user:no000010smdmp2\cmxserviceprod /pass:!cmX5erviceP && d:\scripts\psexec.exe -i -s -d \\no000010smdmp2  -u cmxserviceprod -p !cmX5erviceP  "D:\scripts\RunMDMJob_Batch_Child_Match_Merge.bat" & cmdkey.exe /delete:no000010smdmp2 