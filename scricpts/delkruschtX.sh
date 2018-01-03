#! /bin/bash
# Das Programm geht durch alle Dateien in Verzeichnis1 und sucht dort die Datei$
# Wenn eine Datei kleiner als MaxGr ist, wird sie gelöscht
# Gleichzeitug werden auch die korrespondierenden mp4s in Verzeichnis2 geloesch$
# Es müssen 3 Vorgaben eingestellt werden
#  MaxGr........ Daeitgrösse in KB unterhalb der die Datei geloescht wird
#  pfadflv............  Pfad des Verzeichnis1 mit den Dateien
# der wird über parameter 1 vorgegeben
#      -->  Viel Spass <--     Reinhold Klass

typeset -i i=0
typeset -i lauf=0
typeset -i alle=0
typeset -i Anzahl=0
typeset -i delta=0
typeset -i alter=0
typeset -i MaxGr=1000

#Sicherheitsausgang
bash /home/rarents/eingabetest.sh $1
if [ $? -gt 0 ]; then echo "rausgehen "; exit 55; fi

# 1.) Einstellungen
echo " 1.) Vorgaben "
#pfad="/video_recordings/irgendingen/*"   # VORGABE:    Verzeichnis1 in dem die zu l$
#archiv="/home/rarents/videoarchiv/irgendingen"
pfad="/video_recordings/"$1"/*"
archiv="/home/rarents/videoarchiv/"$1


echo "pfad in dem gesucht wird=  " $pfad
echo " "
echo " "
echo "archiv=   " $archiv
echo " "
# 2.) Schleife in Verzeichnis üeber alle Dateien in dem Verzeichnis
echo "2.) Alle Dateien suchen"
alle=0
lauf=0
for File in $pfad
  do
alle=alle+1 
groesse=$(wc -c $File | awk '{print $1 }')
echo "$File" ,$alle, $groesse
 if [ $groesse -lt 20000000 ]
then
 echo "     -> wird ins Archiv geschoben "
 mv $File $archiv
else
 echo "     -> file hat Mindestgr?oesse und bleibt"
fi

  done
