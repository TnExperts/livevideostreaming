#! /bin/bash
# Das Programm geht durch alle Dateien in Verzeichnis1 und prueft, ob die Datei in Verzeichnis2
# schon als MP4 da ist.
# Wenn nicht, wird die MP4 erzeugt (aus der flv)
# Anschliessend werden die älteren Dateien geloescht (gesucht wird in Verzcihnis 1, geloescht in beiden
# Es wird so lange die aelteste Datei geloescht, bis nur noch die
# gewünschte Anzahl an Dateien (MaxAnzDat) uebrig ist (im Verzeichnis 1)
# Gleichzeitug werden auch die korrespondierenden mp4s in Verzeichnis2 geloescht (falls der Namensstring bis auf .flv und .mp4 identisch ist)
# Es muessen 3 Vorgaben eingestellt werden
#  MaxAnzDat........ Anzahl Dateien, die uebrig bleiben sollen
#  pfadflv............  dies wird aus dem Paramter 1 erzeugt (z.B. irgendingen   alles kleine Buchstaben)
#  pfadmp4...........  Pfad des Verzeichnis2 in dem die MP4s stehen -> ->  wird aus dem Paramter 1 erzeugt (z.B. irgendingen   alles kleine Buchstaben) 
#  archiv............ Ist der Name einen Archives für die FLVs und MP4s->  wird aus dem Paramter 1 erzeugt (z.B. irgendingen   alles kleine Buchstaben)
#    -->  Viel Spass <--     Reinhold Klass

typeset -i i=0
typeset -i lauf=0
typeset -i alle=0
typeset -i Anzahl=0
typeset -i sekjetzt=0
typeset -i delta=0
typeset -i alter=0
typeset -i maxalter=0
typeset -i MaxAnzDat=10   # VORGABE: Maximale Anzahl Dateien, die uebrig bleiben sollen

#Sicherheitsausgang
bash /home/rarents/eingabetest.sh $1
if [ $? -gt 0 ]; then echo "rausgehen "; exit 55; fi

# 1.) Einstellungen
echo " 1.) Vorgaben "
#pfadflv="/video_recordings/irgendingen/*"   # VORGABE:    Verzeichnis1 in dem stehen die .flvs (mit /* hinten)
#pfadmp4="/video_recordings/irgendingen"   # VORGABE:    Verzeichnis2 in dem stehen die .mp4s
#archiv="/home/rarents/videoarchiv/irgendingen"   # Vorgabe: Verzeichnis in dem die gelöschten Files rein kommen


pfadflv="/video_recordings/"$1"/*"
pfadmp4="/video_recordings/"$1
archiv="/home/rarents/videoarchiv/"$1
echo "Eingabeparameter= " $1
echo "pfadflv=  " $pfadflv
echo "pfadmp4=  " $pfadmp4
echo "archiv=   " $archiv
teststr=".flv"        #VORGABE letzte 4 Zeichen der der Dateien, die nach Alter untersucht werden
echo " "




# 2.) Schleife in Verzeichnis üeber alle .flvs 
echo "2.) Alle flvs finden"
echo " "
alle=0
lauf=0 
for File in $pfadflv
 do
 alle=alle+1
 echo "$File" , $lauf
 #letzte 4 zeichen
  Teil=${File: -4}
#  echo $Teil
  # files mit Endung teststr (also.flv) suchen
  if [ $Teil == $teststr ]
    then
    lauf=lauf+1
    # mp4 Namen aus File basteln 
    echo "Name flv = "  $File          #File ist der  Name der flv Datei
    Filemp4="${File:0:-3}"
    Filemp4="${Filemp4}mp4"
    echo "Name mp4 = " $Filemp4          #Filemp4 ist die zug. mp4 Datei
    # Dateinamen finden
    Datmp4=${Filemp4##*/}    # entfernt links das groesste passende Stueck */
    echo "extrahierter Dateiname = " $Datmp4
    # Pruefen, ob der mp4 File schon da ist
     echo "Diesen File nun suchen: " "${pfadmp4}/$Datmp4"
    if find "${pfadmp4}/$Datmp4"
      then
      #  nix tun, wenn file schon da
      echo "   --> mp4 wurde schon erzeugt"
      else
      echo "   --> mp4 erzeugen. Lieber Ralf: Hier wird ein Programm aufgerufen, das den MP4 erzeugt und in pfadmp4 schreibt"
      #/home/rarents/bin/ffmpeg -y -i $File -codec copy $Filemp4 
#     /home/rarents/bin/ffmpeg -y -i $File -acodec aac -ar 44100 -ac 1 -vcodec libx264 $Filemp4      
#     /home/rarents/bin/ffmpeg -y -i $File -ss 380  -c copy -copyts $Filemp4
      /home/rarents/bin/ffmpeg -y -i $File -c copy -copyts $Filemp4
#hier kommt das Wandelprogramm nach mp4 rein, soll gleich in Verzeichnis 2 schreiben
    fi
    echo " "
 fi
 done

#3.) üueberfluessige Dateien entfernen (so dass die gewuenschte Anzahl uebrig bleibt)
echo " "
echo "3.) Nun die Dateien entfernen, die alt sind"
echo " "

sekjetzt=$(date +%s) # die Zeit jetzt in Sekunden
echo "sekjetzt= " $sekjetzt  "  MaxAnzDat= "  $MaxAnzDat
echo " "
# 3a.) Schleife um die Anzahl der Dateien mit der Endung tststr finden
alle=0
lauf=0
for File in $pfadflv
 do
 alle=alle+1
echo "$File" , $lauf
 #letzte 4 zeichen
  Teil=${File: -4}
echo "letzte 4 Zeichen des Files= " $Teil
  # files mit Endung teststr suchen
  if [ $Teil == $teststr ]
    then
    lauf=lauf+1
  fi
 done
Anzahl=$lauf
if [ $Anzahl -le $MaxAnzDat ]
then
 echo "Nix zu Loeschen weil gewuenschte Anzahl erreicht. MaxAnzDat= " $MaxAnzDat
fi
echo " Es sind " $alle " Dateien drin, davon haben "  $Anzahl " Dateien die Endung "  $teststr


# 3b.) In While Schleife immer die aelteste Datei löschen solange bis nur noch MaxAnzDat da sind
while [ $Anzahl -gt $MaxAnzDat ]
 do
 maxalter=0
#aelteste Datei finden
   for File in $pfadflv
    do
     #letzte 4 zeichen
      Teil=${File: -4}
      # files mit Endung teststr suchen
      if [ $Teil == $teststr ]
      then
        xx=$(stat -c %z $File) #schreibt Datumsstring auf xx
        xxx=${xx: 0 : -5} # laesst die letzten 5 Zeichen weg, sonst ist es kein korrekter Da$
        alter=sekjetzt-$(date -d "$xxx" +%s) #berechnet das Alter in sekunden
        echo $File " hat das Alter in sec= "  $alter
        if [ $alter -gt $maxalter ]
        then
          maxalter=$alter
          Fileold=$File
        fi
      fi
   done
 echo "Der aelteste File ist " $Fileold  " mit Alter= "  $maxalter "sec.  Er wird archiviert"
# alten File archivieren
   mv $Fileold $archiv  # File in archiv archivieren
 # nun den mp4 datzu löschen, falls es ihn gibt
   echo "Name flv = "  $Fileold
   Filemp4="${Fileold:0:-3}"
   Filemp4="${Filemp4}mp4"
   echo "Name mp4 = " $Filemp4
   # Dateinamen finden
   Datmp4=${Filemp4##*/}    # entfernt links das grösste passende Stück */
   echo "extrahierter Dateiname = " $Datmp4
   # Pruefen, ob der mp4 File existiert (im Verzeichnis 2)
   echo "Diesen File nun suchen: " "${pfadmp4}/$Datmp4"
   if find "${pfadmp4}/$Datmp4"    #  nix tun, wenn es keine mp4 dazu gab
   then
      mv "${pfadmp4}/$Datmp4" $archiv    #  mp4 wird archiviert
      echo "Der zugeörige mp4 wurdearchiviert"
   fi
   Anzahl=Anzahl-1
   echo "Schleifenindex in while geht runter bis maximale Fileanzahl erreicht. Anzahlfiles flv = " $Anzahl
   echo " "
done
