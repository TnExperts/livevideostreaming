<!-- Dieses Script liest die Videoaufzeichnungen in einem bestimmten Verzeichnis und gibt diese in Form einer HTML Tabelle aus -->

<!DOCTYPE html>
<html lang="de">
<head>
<title>Gottesdienste der Evang. Kirchengemeinde in Gechingen</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<style>
* {
    box-sizing: border-box;
}

body {
  margin: 0;
}

/* Style the header */
.header {
    background-color: #f1f1f1;
    padding: 10px;
    font-size:100%;
}

/* Style the content */
.content {
    background-color: #ddd;
    padding: 10px;
    font-size:80%;
}

/* Style the footer */
.footer {
    background-color: #f1f1f1;
    padding: 5px;
}
</style>
</head>

<body>

<div class="header">
  <h2>Gottesdienste der Evang. Kirchengemeinde in Gechingen</h2>
  <h3>Administrations-Oberfl&auml;che</h3>

<?php
exec("/home/rarents/bin/ffprobe -i http:\/\/rk-solutions-stream.de/livegecho/test/index.m3u8 -v quiet -print_format json -show_format -show_streams -hide_banner > temp_file", $output, $res);
$info = json_decode(file_get_contents("temp_file"));

$videocodec = $info->streams[0]->codec_name;

if($videocodec == "h264") 
   {
  echo"<a href=\"livestream.html\"><img src=\"../images/livegreen.png\" title=\"Live Stream\" width=\"20\" height=\"20\"></a> &nbsp;<a href=\"livestream.html\">Live Stream</a> &nbsp; ";
   }
else 
   {
   echo"<img src=\"../images/offline.png\" title=\"Momentan findet keine Live &Uuml;bertragung statt\" width=\"20\" height=\"20\"> &nbsp; Momentan keine Live-&Uuml;bertragung  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ";
   }
?>

  <a href="../gechingen/aufzeichnung.html"><img src="../images/play.png" title="Letzte Aufzeichnung" width="20" height="20"></a>&nbsp; <a href="../gechingen/aufzeichnung.html">Letzte Aufzeichnung</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="./statistic.html"><img src="../images/statistic.png" title="Statistic" width="20" height="20"></a>&nbsp; <a href="./statistic.html">Statistik</a><p>
</div>

<div class="content">

<?php
#Ueberprufen, ob ffmpeg Konvertierung nach mp4 laeuft. Wenn ja, keine weiteren Links fuer die Konvertierung anzeigen

$pid=exec("pidof avconv");
exec("ps -p $pid", $output);

if (count($output) > 1) {
 echo "<font color='green'><b>mp4 Videoaufzeichnung wird momentan erzeugt - daher sind momentan keine weiteren Konvertierungsvorg&auml;nge m&ouml;glich.<br>
Bitte einige Minuten warten und anschl. Browserseite neu laden.
</b></font><p>";
 $mpegcreation="running";
}
else {
 $mpegcreation="notrunning";
}

#Ueberprufen, ob Kopiervorgang der aufzeichnung.mp4 noch andauert. Wenn ja, keine weiteren Links fuer Kopiervorgaenge anlegen
$pidcp=exec("pidof cp");
exec("ps -p $pidcp", $outputcp);

if (count($outputcp) > 1) {
 echo "<font color='green'><b>Letzte Aufzeichnung wird momentan erzeugt - daher sind momentan keine weiteren Kopiervorg&auml;nge m&ouml;glich.<br>
Bitte einige Minuten warten und anschl. Browserseite neu laden.
</b></font><p>";
 $kopieren="running";
}
else {
 $kopieren="notrunning";
}

// Pfad zur aktuellsten Aufzeichnung festlegen und Lesen der Datei Informationen
$aufzeichnung = "/video_recordings/gechingen/aufzeichnung.mp4";

?>

<h4>Aufnahmen:</h4>
<div class="w3-responsive">
<table class="w3-table-all w3-small w3-hoverable w3-card-4 w3-centered"><tr>
<th>Tag</th>
<th>Datum</th>
<th>Beginn</th>
<th>Ende</th>
<th>Dateigroesse<br>(flv)</th>
<th>Streaming<br>(mp4)</th>
<th>Streaming<br>(flv)</th>
<th>Download<br>(mp4)</th>
<th>mp4<br>erzeugen</th>
<th>als letzte<br> Aufzeichnung festlegen</th>
<th>Aufzeichnung<br>l&ouml;schen</th>
</tr></b><br>

<?php 
function byte_ausrechnen($byte) { 
     
    if($byte < 1024) { 
        $ergebnis = round($byte, 2). ' Byte'; 
    }elseif($byte >= 1024 and $byte < pow(1024, 2)) { 
        $ergebnis = round($byte/1024, 2).' KByte'; 
    }elseif($byte >= pow(1024, 2) and $byte < pow(1024, 3)) { 
        $ergebnis = round($byte/pow(1024, 2), 2).' MByte'; 
    }elseif($byte >= pow(1024, 3) and $byte < pow(1024, 4)) { 
        $ergebnis = round($byte/pow(1024, 3), 2).' GByte'; 
    }elseif($byte >= pow(1024, 4) and $byte < pow(1024, 5)) { 
        $ergebnis = round($byte/pow(1024, 4), 2).' TByte'; 
    }elseif($byte >= pow(1024, 5) and $byte < pow(1024, 6)) { 
        $ergebnis = round($byte/pow(1024, 5), 2).' PByte'; 
    }elseif($byte >= pow(1024, 6) and $byte < pow(1024, 7)) { 
        $ergebnis = round($byte/pow(1024, 6), 2).' EByte'; 
    } 

return $ergebnis; 
     
}

function wochentag($tag) { 
     
    if($tag=="Sunday") { 
        $weekday = "Sonntag"; 
    }elseif($tag=="Monday") { 
       $weekday = "Montag"; 
    }elseif($tag=="Tuesday") { 
       $weekday = "Dienstag"; 
    }elseif($tag=="Wednesday") { 
       $weekday = "Mittwoch";
    }elseif($tag=="Thursday") { 
       $weekday = "Donnerstag";
    }elseif($tag=="Friday") { 
       $weekday = "Freitag";
    }elseif($tag=="Saturday") { 
       $weekday = "Samstag";
    }

return $weekday; 
     
}

// Pfad zum Ordner mit allen Video-Aufzeichnungen 
$ordner = "/video_recordings/gechingen"; //auch komplette Pfade moeglich ($ordner = "download/files";)

// Ordner auslesen und Array in Variable speichern
$alledateien = scandir($ordner, 1); // Sortierung A-Z
// Sortierung Z-A mit scandir($ordner, 1)               				

// Schleife um Array "$alledateien" aus scandir Funktion auszugeben
// Einzeldateien werden dabei in der Variabel $datei abgelegt
foreach ($alledateien as $datei) {

	// Zusammentragen der Dateiinfo
	$dateiinfo = pathinfo($ordner."/".$datei); 
	//Folgende Variablen stehen nun zur Verfuegung
	// $dateiinfo['filename'] = Dateiname ohne Dateiendung  *erst mit PHP 5.2
	// $dateiinfo['dirname'] = Verzeichnisname
	// $dateiinfo['extension'] = Dateityp -/endung
	// $dateiinfo['basename'] = voller Dateiname mit Dateiendung

	// scandir liest alle Dateien im Ordner aus, zusaetzlich noch "." , ".." als Ordner
	// Nur echte Dateien anzeigen lassen und keine "Punkt" Ordner
	// aufzeichnung.mp4 ist die aktuellste Aufzeichnung. Diese soll nicht in der Tabelle erscheinen
	if ($datei != "." && $datei != ".."  && $datei != "aufzeichnung.mp4") {
        if ($dateiinfo['extension'] == "flv") { 
        // Dateigroesse der flv-Dateien feststellen
        $size = filesize($ordner."/".$dateiinfo['filename'].".flv");
        // Splitten des Dateinamens
        $dateiname=$dateiinfo['filename'];
        $teile = explode("-", $dateiname);
        // test-1481403588-Saturday-10-12-16-21-59
        // $teile[0] = test
        // $teile[1] = string
        // $teile[2] = Wochentag (Name)
        // $teile[3] = Wochentag (Zahl)
        // $teile[4] = Monat
        // $teile[5] = Jahr
        // $teile[6] = Stunde
        // $teile[7] = Minute
        // ...
        $tag=$teile[2];

// Nur Tabellenzeilen fuer Dateien erzeugen die groesser 0 KB sind
if($size > 0) { 
echo "<tr><td>".wochentag($tag)."</td><td>".$teile[3].".".$teile[4].".".$teile[5]."</td><td>".$teile[6].":".$teile[7]."</td>
<td>".date("H:i", filemtime($ordner."/".$dateiinfo['basename']))."</td>
<td>".byte_ausrechnen($size)."</td>
<td>";

# Wenn keine mp4 Datei vorliegt, in dieser Spalte keinen Link auf das mp4 anzeigen.
$filenamempeg = "/video_recordings/gechingen/".$dateiinfo['filename'].".mp4";
if (file_exists($filenamempeg)) {
  echo "<a href=\"/gechingen/showmpeg.html?filename=".$dateiinfo['filename'].".mp4\"><img src=\"../images/play.png\" title=\"Video abspielen\" width=\"20\" height=\"20\"></a></td>"; 
}
else {
 echo "<font color='grey'>mp4 fehlt</font></td>";
}

echo "<td><a href=\"./showflv.html?filename=".$dateiinfo['filename'].".flv\"><img src=\"../images/play.png\" title=\"Video abspielen\" width=\"20\" height=\"20\"></a></td>
<td><a href=\"/gechingenstreams/".$dateiinfo['filename'].".mp4\" download=\"http://rk-solutions-stream.de/gechingenstreams/".$dateiinfo['filename'].".mp4\">
<img src=\"../images/download.png\" title=\"Download (mp4)\" width=\"20\" height=\"20\"></a></td>
<td>";

# Wenn kein ffmpeg (mp4) Konvertierungsprozess laeuft und keine  mp4 Datei vorliegt, 
# dann einen Link mit dem Namen "Start" erzeugen, ueber den die mp4 erstellt werden kann.
if (($mpegcreation == "notrunning") && (!file_exists($filenamempeg))){
   echo "<a href=\"./creatempeg.html?filename=".$dateiinfo['filename']."\"><img src=\"../images/convert.png\" title=\"mp4 erzeugen\" width=\"20\" height=\"20\"></a></td>"; 
}
else {
  echo "<img src=\"../images/noconvert.png\" title=\"Konvertierung nicht m&ouml;glich\" width=\"20\" height=\"20\"></td>"; 
}

echo "<td>";

# Wenn kein Kopiervorgang laeuft und eine mp4 Datei existiert, dann Links fuer Kopiervorgaenge anzeigen.
if (($kopieren=="notrunning") && (file_exists($filenamempeg))) {
 echo "<a href=\"./setaufzeichnung.html?filename=".$dateiinfo['filename']."\"><img src=\"../images/copy.png\" title=\"Kopieren\" width=\"20\" height=\"20\"></a></td>";
}
else {
  echo "<img src=\"../images/nocopy.png\" title=\"Kopieren\" width=\"20\" height=\"20\"></td>"; 
}

echo "<td><a href=\"./predelete.html?filename=".$dateiinfo['filename']."\"><img src=\"../images/delete.png\" title=\"Video l&ouml;schen\" width=\"20\" height=\"20\"></a></td></tr>"; 
       } // Ende if-Schleife fuer Datei Groessenabfrage
      }; // Ende if-Schliefe fuer erste Abfrage	
     }; // Ende if-Schleife fuer Datei Extension Abfrage
 };
?>     

</table></div><p>

<div class="w3-panel w3-border-left w3-border-red w3-pale-red">
<b>Hinweis:</b> Um die Videos/ Streams anzuschauen, verwenden Sie am besten den <a href="https://www.mozilla.org/de/firefox/new/">Firefox</a> oder
<a href="http://www.google.de/chrome">Google Chrome Browser</a>. 
Teilweise werden auch internetf&auml;hige Fernsehger&auml;te unterst&uuml;tzt. Bei bestimmten Browsern (z.B. Microsoft Edge Browser in Windows 10 oder bestimmte Versionen des Internet Explorers) 
kann es vorkommen, dass Bild und Ton nicht ganz synchron sind.
</div>

</div>
