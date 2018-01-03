#! /bin/bash
# Das Programm ruft die Unterprogramme zum Aufraeumen und Archivieren auf
echo "-------------------------------------------------------"
echo "A:   Programm aufraeumen.sh ist gestartet"
echo "     Paramter 1 = " $1 " (aus Programm aufraeumen.sh)"
echo " "
echo " "
echo "-------------------------------------------------------"
echo "B: Jetzt startet/home/rarents/delkruschtX.sh $1"
bash /home/rarents/delkruschtX.sh $1
echo  "delkruschtX.sh ist mit Parameter=" $1 " gelaufen. Exit=" $?
echo " "
echo " "
sleep 3
echo "-------------------------------------------------------"
echo "C: Jetzt startet /home/rarents/deloldarchivX.sh $1"
bash /home/rarents/deloldarchivX.sh $1
echo  "deloldarchivX.sh ist mit Parameter=" $1 " gelaufen. Exit=" $?
echo " "
echo " "
sleep 5
echo "-------------------------------------------------------"
echo "D: Jetzt startet /home/rarents/archivierenX.sh $1"
bash /home/rarents/archivierenX.sh $1
echo  "archivierenX ist mit Parameter=" $1 " gelaufen. Exit=" $?
