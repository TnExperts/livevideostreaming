#! /bin/bash
# Das Programm geht durch alle Dateien im Verzeichnis Archiv und prüft das Alter der Datei.
# Wenn dieses groesser ist als MaxDatAlter, wird die Datei geloescht.
# Es muessen 2 Vorgaben eingestellt werden
#  MaxAlter........ Maximales Alter der Daten in Tagen
#  archiv............ Ist der Name einen Archives für die FLVs und MP4
#  dies wird aus dem Paramter 1 erzeugt (z.B. irgendingen   alles kleine Buchstaben)
#    -->  Viel Spass <--     Reinhold Klass

typeset -i i=0
typeset -i loesche=0
typeset -i lauf=0
typeset -i alle=0
typeset -i Anzahl=0
typeset -i sekjetzt=0
typeset -i alterd=0
typeset -i alter=0
typeset -i maxalter=0
typeset -i MaxDatAlter=100   # VORGABE: Maximales erlaubtes Alter der Datei in Archiv (in Tagen)

#Sicherheitsausgang
bash /home/rarents/eingabetest.sh $1
if [ $? -gt 0 ]; then echo "rausgehen "; exit 55; fi


# 1.) Einstellungen
echo " 1.) Vorgaben "
echo "Parameter 1" $1

#archiv="/home/rarents/videoarchiv/irgendingen/*"   # Vorgabe: archiv, in dem die alten Files gelöscht werden sollen
archiv="/home/rarents/videoarchiv/"$1"/*"
echo "archiv=   " $archiv
sekjetzt=$(date +%s) # die Zeit jetzt in Sekunden
echo "Zeit jetzt ist  " $sekjetzt
echo " "


# 2.) Schleife in Verzeichnis üeber alle .flv oder .mp4s 
echo "2.) Alle flvs finden"
echo " "
alle=0
lauf=0
loesche=0 
for File in $archiv
 do
 alle=alle+1
 echo "Filenummer = " $alle $File

 #letzte 4 zeichen
  Teil=${File: -4}
 echo "letzte 4 Zeichen des Files= " $Teil
  # files mit Endung mp4 oder flv suchen
  if [ $Teil == ".flv" ] || [ $Teil == ".mp4" ]
    then
    lauf=lauf+1
    echo "   Filename hat mp4 oder flv " $lauf
    xx=$(stat -c %z $File) #schreibt Datumsstring auf xx
    xxx=${xx: 0 : -5} # laesst die letzten 5 Zeichen weg, sonst ist es kein korrekter Da$
    alter=sekjetzt-$(date -d "$xxx" +%s) #berechnet das Alter in sekunden
    alterd=$alter/24
    alterd=$alterd/3600
    
    echo  "        Alter in sec= "  $alter 
    echo  "        Alter in Tagen= "  $alterd
    if [ $alterd -gt $MaxDatAlter ]
      then
      loesche=loesche+1
      echo "        Loeschnummer  " $lauf
      echo "        File ist aelter als " $MaxDatAlter " Tage und wird geloescht  " 
      rm $File -f
      else  
      echo "        File ist nicht aelter als  " $MaxDatAlter " Tage und wird nicht geloescht  " 
      fi
    fi

done

#3.) Ergebnisausschrieb
echo " "
echo " "
echo "ERGEBNIS"
echo "Es gab  " $alle  " Files"
echo "Davon waren " $lauf "Files mit Endung .mp4 oder .flv"
echo "Davon waren " $loesche " zu alt und wurden geloescht auf NIMMERWIEDERSEHEN "
