# GOG Downloader PowerShell Toolkit 🎮

Choose your language / Wähle deine Sprache:
- 🌐 [English](#-english-version)
- 🌐 [Deutsch](#-deutsche-version)

---

## 🇬🇧 English Version

A set of two lightweight PowerShell scripts for the GOG (`gogg`) downloader. These tools make it easy to download or update your entire GOG game library in one go and keep your storage clean by automatically deleting outdated installer versions.

### Features

- **Bulk Download (`download_all_games.ps1`):** Loops through your library to start the automatic download or update of all games sequentially.
- **Storage Cleanup (`storage_cleanup.ps1`):** Scans your download directory for obsolete installer versions and removes them to free up disk space.
- **Quick Launch:** Both scripts come with matching `.bat` files, allowing you to run them easily with a simple double-click under Windows.

### Prerequisites

1. **Windows PowerShell:** The scripts are optimized for Windows PowerShell.
2. **gogg-Downloader:** The command-line downloader for GOG (`gogg`) must be installed on your system and added to your system's PATH, or be available in the same directory.
3. **PowerShell Execution Policy:** You might need to allow the execution of PowerShell scripts once by running this command in your PowerShell (as Administrator):
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

### Usage

#### 1. Download / Update Entire Library
This script automates the download process for all games using the `gogg` downloader.

- **Via Batch File (Recommended):** Double-click `download_all_games.bat`.
- **Via PowerShell:**
  ```powershell
  .\download_all_games.ps1
  ```

#### 2. Clean Up Old Versions (Storage Cleanup)
GOG installers often leave older setup files behind when games get updated. This script keeps only the latest version and deletes the rest.

- **Via Batch File (Recommended):** Double-click `storage_cleanup.bat`.
- **Via PowerShell:**
  ```powershell
  .\storage_cleanup.ps1
  ```

> ⚠️ **Note:** Before running the cleanup script for the first time, make sure to verify that the paths inside the script point correctly to your GOG download directory.

### Configuration (Optional)

If your games are stored in a custom directory or if the `gogg` downloader requires specific arguments, simply open the `.ps1` files with a text editor (e.g., Notepad++) and adjust the variables at the top of the file:

```powershell
# Example configuration variables inside the script
\$DownloadPath = "D:\GOG_Downloads"
\$GoggPath = "gogg"
```

Downloads:  
* [gogg](https://github.com/habedi/gogg)

### License

This project is licensed under the [MIT License](LICENSE) – feel free to use, modify, and distribute it.

---

## 🇩🇪 Deutsche Version

Ein Set aus zwei kleinen PowerShell-Skripten für den GOG (`gogg`) Downloader. Diese Tools erleichtern es dir, deine gesamte GOG-Spielebibliothek in einem Rutsch herunterzuladen oder zu aktualisieren und Ordnung in deinem Speicher zu halten, indem alte Versionen automatisch bereinigt werden.

### Features

- **Massen-Download (`download_all_games.ps1`):** Durchläuft deine Bibliothek und startet den automatischen Download oder die Aktualisierung aller Spiele nacheinander.
- **Speicher-Bereinigung (`storage_cleanup.ps1`):** Scannt dein Download-Verzeichnis nach veralteten Installer-Versionen und löscht diese, um wertvollen Speicherplatz freizugeben.
- **Einfacher Start:** Beide Skripte kommen mit einer dazugehörigen `.bat`-Datei, sodass du sie unkompliziert per Doppelklick unter Windows ausführen kannst.

### Voraussetzungen

1. **Windows PowerShell:** Die Skripte sind für Windows PowerShell optimiert.
2. **gogg-Downloader:** Der CLI-Downloader für GOG (`gogg`) muss auf deinem System installiert und im Systempfad (PATH) registriert oder im selben Verzeichnis verfügbar sein.
3. **PowerShell-Berechtigungen:** Möglicherweise musst du die Ausführungsrichtlinie für PowerShell-Skripte einmalig in deiner PowerShell (als Administrator) anpassen:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

### Nutzung

#### 1. Gesamte Bibliothek herunterladen / aktualisieren
Dieses Skript automatisiert den Download-Prozess aller Spiele über den `gogg`-Downloader.

- **Via Batch-Datei (Empfohlen):** Doppelklick auf `download_all_games.bat`.
- **Via PowerShell:**
  ```powershell
  .\download_all_games.ps1
  ```

#### 2. Alte Versionen löschen (Storage Cleanup)
GOG-Installer hinterlassen bei Updates oft alte Versionen der Setup-Dateien. Dieses Skript behält nur die jeweils neueste Version und löscht die alten.

- **Via Batch-Datei (Empfohlen):** Doppelklick auf `storage_cleanup.bat`.
- **Via PowerShell:**
  ```powershell
  .\storage_cleanup.ps1
  ```

> ⚠️ **Hinweis:** Es wird empfohlen, vor dem ersten Ausführen des Bereinigungsskripts zu prüfen, ob die Pfade im Skript korrekt auf dein GOG-Download-Verzeichnis eingestellt sind.

### Konfiguration (Optional)

Sollten deine Spiele in einem benutzerdefinierten Verzeichnis liegen oder der `gogg`-Downloader spezielle Parameter benötigen, öffne die jeweiligen `.ps1`-Dateien einfach mit einem Texteditor (z. B. Notepad++) und passe die Variablen im oberen Bereich des Skripts an:

```powershell
# Beispiel für Konfigurationsvariablen im Skriptkopf
\$DownloadPath = "D:\GOG_Downloads"
\$GoggPath = "gogg"
```

Downloads:  
* [gogg](https://github.com/habedi/gogg)

### Lizenz

Dieses Projekt ist unter der [MIT Lizenz](LICENSE) lizenziert – freie Nutzung, Modifikation und Weitergabe ausdrücklich erlaubt.
