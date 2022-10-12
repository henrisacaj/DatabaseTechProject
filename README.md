# Database Technologies Project

## Datenbank für ein Fitnessstudio zur Verwaltung der Mitarbeiter, Kunden, Geräte, Abos usw.

## Installation der Datenbank

Vor dem Aufsetzen der Datenbank, bitte die [requirements](requirements.md) überprüfen.

Reihenfolge der Skript-Ausführung:

- [Create schema](database/create_gym_schema.sql)
- [Create stored programs](database/create_stored_program.sql)
  - Erstellen der Prozeduren, Funktionen, Events und Trigger (wichtig für Datenvalidierung und SELECT-Statements) 
- [Insert data](database/gym_data.sql)
  - Beispieldatensätze sowie die Erstellung eines Fulltext-Indexes 
- [Create views](database/views.sql)
  - Hilfreiche Views für die Trainer und Kunden
 
 ## Verschiedene Select-Statements für unterschiedliche Anwendungsfälle 
 
 - [Select-Statements](database/select_statements.sql)

## Starten des Backends und Frontends
- Das Passwort in der Zeile 21 der app.js an das eigene MySQL-Root anpassen
- app.js starten mithilfe von folgendem Befehl:  
  ```node app.js```
