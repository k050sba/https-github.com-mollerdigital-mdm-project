IF EXIST "\\no000010smdmcu\Car_Relation\Add new Relation\Car Relation Addition Template.csv" ( copy "\\no000010smdmcu\Car_Relation\Add new Relation\Car Relation Addition Template.csv" "\\no000010smdmcu\Repository\MDMShared\Car Relation Addition Template Archive" & ren "\\no000010smdmcu\Repository\MDMShared\Car Relation Addition Template Archive\Car Relation Addition Template.csv" "Car Relation Addition Template_%date:/=-% %time::=-%.csv" & "D:\Scripts\Run_IDQ_WF_ActiveCarRelationNewModel.bat" & timeout 120 & del "\\no000010smdmcu\Car_Relation\Add new Relation\Car Relation Addition Template.csv" )