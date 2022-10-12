# Reflexionsdokument 

## Arbeitsverteilung des Teams
Datenbankentwurf, Schemadefinition und Datenbankanbindung haben wir als Team zusammen bearbeitet.
- Henri hat sich mit den Select-Statements, Indizes und Views beschäftigt. 
- Alex hat sich mit den Stored-Programs (Prozeduren, Funktionen, Trigger, Events) auseinandergesetzt.
- Omar hat neben dem Beispieldatensatz noch das Frontend erstellt.  

Mehr Informationen sind unter [Product_Backlog](Product_Backlog.PNG) zu finden.  
Link zum Trello-Board: https://trello.com/b/Q96VAacI/gym

## Beschreibung des Anwendungsfalls

Wir haben eine MySQL Gym-Datenbank zur Verwaltung der Mitarbeiter, Kunden, Abos, Geräte, Kurse und Räume. 
Auf der Webseite können Mitarbeiter neue Kunden hinzufügen sowie bestehende Kunden löschen. Zudem können Kunden mit Hilfe des Namen + Geburtstag die Kunden-ID herausfinden.
Die Kunden können sich die Abos mit den jeweiligen Extras anzeigen lassen.  

## Reflexion von Entwurf und Umsetzung

- Auswahl der Primary-Keys: Der Primary-Key besteht in fast allen Tabellen aus der ID.   
  - Bei den sogenannten "Verknüpfungstabellen" (hier includes, teaches und attends) besteht der PK aus den PKs der Entitäten, die miteinander in Beziehung stehen. 
- Normalisierung: Alle Tabellen sind in der 3. Normalform. 
- Constraints
  - Überprüfen der Attribut-Werte mithilfe von Regexes (PLZ, E-Mail, IBAN)
  - Foreign Key Constraints (Einschränkung durch ON DELETE/UPDATE CASCADE/SET NULL...)
- Indizes
  - Neben den automatisch generierten PK-Indizes haben wir versucht, sinnvolle Beispiele für Secondary Indizes, die tatsächlich in den Queries verwendet werden. Ein Beispiel hierfür wäre der Fulltext-Index für die Spalte course_description.
  - Durch den Fulltext-Index haben sich die Kosten der Query, in der der Index verwendet wird, deutlich verringert.
- Views
  - Es existieren 3 Views für die Trainer bzw. Customer. 
    - personal_trainer_customer
    - membership_extra
    - trainer_course
- SELECT-Statements 
  - Alle Klauseln (Select, From, Where, Group by, Having, Order by)
  - Unterschiedliche Join-Arten (Natural Join, Left join, Inner join unter Verwendung der Schlüsselwörter USING/ON)
  - Unterabfragen in der FROM-Klausel
  - Aggregatfunktionen (COUNT, AVG)
  - Date-Funktionen (CURDATE(), NOW(), date_diff(), date_format())
  - ROUND, CONCAT, UPPER, SUBSTRING, LENGTH, DINSTINCT, LIKE
- Stored Programs
  - Prozeduren zum Erstellen/Löschen von Kunden (inklusive Error-Handling und Verwendung von Transaktionen)
  - Getter-Funktionen für Kundennamen/KundenIDs
  - Funktion zum Extrahieren von Monat und Tag aus einem Date, um sie leichter zu vergleichen
  - Funktion zum Überprüfen von Daten (älter als ein angegebener Interval)
  - Event zum täglichen Überprüfen, ob ein Kunde an dem aktuellen Tag Geburtstag hat
  - Trigger zum Formatieren des Kundennamens vor dem INSERT in die customer-Tabelle

- Herausforderungen/Probleme
  - Wir hatten das Ziel, mithilfe einer Audit-Tabelle auf der Webseite ausgeben zu lassen, zu welchen Uhrzeiten das Fitnessstudio oft besucht wird. Hier würden wir die last_login-Timestamps speichern und verarbeiten. Leider konnten wir dies aus Zeitgründen nicht umsetzen.
  - Die Anzahl der Tabellen niedrig zu halten war eine Schwierigkeit, da wir möglichst viele Beziehungen zwischen den Tabellen umsetzen mussten.  
  Lösung: Durch Vorkenntnisse/Erfahrung aus dem Pflichtmodul Datenbanksysteme konnten wir das Schema trotzdem realisieren.
  - Frontend: Wir hatten alle wenig Erfahrung mit Node.js und Web-Design ==> schwierig, innerhalb so einer kurzer Zeit alles umzusetzen. 
  Lösung: Wir haben uns auf das Wesentliche und die Hauptelemente der Webseite konzentriert.  

- Besonderheiten:
  - Teilweise automatisiertes Generieren der Beispieldaten
  - ENUM, SETS
  - Custom Reihenfolge definieren mit FIELD()
  - MATCH ... AGAINST REGEX zum Suchen mit Fulltext-Index

