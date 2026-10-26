[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ==============================================================================
# PFAD ZU DEINEM WINDOWS- oder NAS-LAUFWERK ANPASSEN
# ==============================================================================
$TargetDir = "X:\ISO\Good Old Games"

# Auf $true lassen für eine Simulation. Auf $false setzen zum echten Löschen!
# $DryRun = $true
$DryRun = $false

# RegEx-Suchmuster in Variablen auslagern, um Parser-Fehler zu vermeiden
$PatternBuild = "\((?<build>\d+)\)"
$PatternMac   = "english_(?<version>\d+_\d+|macOS)"

Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host " Starte GOG-Cleanup in ALLEN Unterordnern von: $TargetDir" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host " -> MODUS: SIMULATION (Es wird nichts gelöscht!)" -ForegroundColor Yellow
} else {
    Write-Host " -> MODUS: SCHARF (Dateien werden gelöscht!)" -ForegroundColor Red
}
Write-Host "========================================================================" -ForegroundColor Cyan

# Holt alle Spiele-Unterordner
$GameFolders = Get-ChildItem -Path $TargetDir -Directory

foreach ($Folder in $GameFolders) {
    Write-Host ""
    Write-Host "--- Verarbeite Spiele-Ordner: $($Folder.Name) ---" -ForegroundColor Magenta
    
    # --------------------------------------------------------------------------
    # 1. WINDOWS BASE-INSTALLER & BIN-DATEIEN REINIGEN
    # --------------------------------------------------------------------------
    $LatestWinSetup = Get-ChildItem -Path $Folder.FullName -File -Filter "setup_*_64bit_*.exe" | 
                      Where-Object { $_.Name -notmatch "phantom_liberty" -and $_.Name -notmatch "\.part$" } |
                      Sort-Object LastWriteTime -Descending | Select-Object -First 1

    if ($LatestWinSetup) {
        if ($LatestWinSetup.Name -match $PatternBuild) {
            $CurrentBuild = $Matches.build
            Write-Host "   [Windows] Aktuellste Version: Build $CurrentBuild ($($LatestWinSetup.Name))" -ForegroundColor Gray

            $OldFiles = Get-ChildItem -Path $Folder.FullName -File | 
                        Where-Object { ($_.Extension -eq ".exe" -or $_.Extension -eq ".bin") -and $_.Name -like "setup_*" -and $_.Name -notmatch "phantom_liberty" -and $_.Name -notmatch $CurrentBuild -and $_.Name -notmatch "\.part$" }

            foreach ($File in $OldFiles) {
                Write-Host "   [-] Entferne alte Setup-Datei: $($File.Name)" -ForegroundColor DarkYellow
                if (-not $DryRun) { Remove-Item -Path $File.FullName -Force }
            }
        }
    }

    # --------------------------------------------------------------------------
    # 2. DLC-INSTALLER REINIGEN
    # --------------------------------------------------------------------------
    $LatestDlcSetup = Get-ChildItem -Path $Folder.FullName -File -Filter "setup_*.exe" | 
                      Where-Object { ($_.Name -match "phantom_liberty" -or $_.Name -like "dlc_*") -and $_.Name -notmatch "\.part$" } |
                      Sort-Object LastWriteTime -Descending | Select-Object -First 1

    if ($LatestDlcSetup) {
        if ($LatestDlcSetup.Name -match $PatternBuild) {
            $DlcBuild = $Matches.build
            Write-Host "   [DLC] Aktuellste DLC-Version: Build $DlcBuild" -ForegroundColor Gray

            $OldDlcFiles = Get-ChildItem -Path $Folder.FullName -File | 
                           Where-Object { ($_.Name -match "phantom_liberty" -or $_.Name -like "dlc_*") -and ($_.Extension -eq ".exe" -or $_.Extension -eq ".bin") -and $_.Name -notmatch $DlcBuild -and $_.Name -notmatch "\.part$" }

            foreach ($DlcFile in $OldDlcFiles) {
                Write-Host "   [-] Entferne alte DLC-Datei: $($DlcFile.Name)" -ForegroundColor DarkYellow
                if (-not $DryRun) { Remove-Item -Path $DlcFile.FullName -Force }
            }
        }
    }

    # --------------------------------------------------------------------------
    # 3. MAC-INSTALLER REINIGEN (.pkg)
    # --------------------------------------------------------------------------
    $LatestMacPkg = Get-ChildItem -Path $Folder.FullName -File -Filter "*english_*_mac*.pkg" | 
                    Where-Object { $_.Name -notmatch "\.part$" } |
                    Sort-Object LastWriteTime -Descending | Select-Object -First 1

    if ($LatestMacPkg) {
        if ($LatestMacPkg.Name -match $PatternMac) {
            $MacVersion = $Matches.version
            Write-Host "   [Mac] Aktuellste Mac-Version: $MacVersion" -ForegroundColor Gray

            $OldMacFiles = Get-ChildItem -Path $Folder.FullName -File -Filter "*.pkg" | 
                           Where-Object { $_.Name -notmatch $MacVersion -and $_.Name -notmatch "\.part$" }

            foreach ($MacFile in $OldMacFiles) {
                Write-Host "   [-] Entferne altes Mac-Paket: $($MacFile.Name)" -ForegroundColor DarkYellow
                if (-not $DryRun) { Remove-Item -Path $MacFile.FullName -Force }
            }
        }
    }

    # --------------------------------------------------------------------------
    # 4. INKREMENTELLE PATCHES ENTFERNEN (.exe & .bin Patches)
    # --------------------------------------------------------------------------
    $Patches = Get-ChildItem -Path $Folder.FullName -File | 
               Where-Object { $_.Name -like "patch_*" -and ($_.Extension -eq ".exe" -or $_.Extension -eq ".bin") }

    foreach ($Patch in $Patches) {
        Write-Host "   [-] Entferne alten inkrementellen Patch: $($Patch.Name)" -ForegroundColor DarkYellow
        if (-not $DryRun) { Remove-Item -Path $Patch.FullName -Force }
    }
}

Write-Host ""
Write-Host "========================================================================" -ForegroundColor Green
Write-Host " Cleanup für alle Spiele-Ordner beendet!" -ForegroundColor Green
Write-Host "========================================================================" -ForegroundColor Green
