[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ==============================================================================
# ADJUST THE PATH TO YOUR WINDOWS OR NAS DRIVE HERE
# ==============================================================================
$TargetDir = "" # Output directory example "X:\ISO\Good Old Games"

# Keep as $true for a simulation. Set to $false to actually delete files!
$DryRun = $true

# Store RegEx search patterns in variables to avoid script parser errors
$PatternBuild = "\((?<build>\d+)\)"
$PatternMac   = "english_(?<version>\d+_\d+|macOS)"

Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host " Starting GOG cleanup in ALL subfolders of: $TargetDir" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host " -> MODE: SIMULATION (No files will be deleted!)" -ForegroundColor Yellow
} else {
    Write-Host " -> MODE: LIVE (Files WILL be deleted!)" -ForegroundColor Red
}
Write-Host "========================================================================" -ForegroundColor Cyan

# Fetch all game subfolders
$GameFolders = Get-ChildItem -Path $TargetDir -Directory

foreach ($Folder in $GameFolders) {
    Write-Host ""
    Write-Host "--- Processing game folder: $($Folder.Name) ---" -ForegroundColor Magenta
    
    # --------------------------------------------------------------------------
    # 1. CLEAN UP WINDOWS BASE INSTALLERS & BIN FILES
    # --------------------------------------------------------------------------
    $LatestWinSetup = Get-ChildItem -Path $Folder.FullName -File -Filter "setup_*_64bit_*.exe" | 
                      Where-Object { $_.Name -notmatch "phantom_liberty" -and $_.Name -notmatch "\.part$" } |
                      Sort-Object LastWriteTime -Descending | Select-Object -First 1

    if ($LatestWinSetup) {
        if ($LatestWinSetup.Name -match $PatternBuild) {
            $CurrentBuild = $Matches.build
            Write-Host "   [Windows] Latest version found: Build $CurrentBuild ($($LatestWinSetup.Name))" -ForegroundColor Gray

            $OldFiles = Get-ChildItem -Path $Folder.FullName -File | 
                        Where-Object { ($_.Extension -eq ".exe" -or $_.Extension -eq ".bin") -and $_.Name -like "setup_*" -and $_.Name -notmatch "phantom_liberty" -and $_.Name -notmatch $CurrentBuild -and $_.Name -notmatch "\.part$" }

            foreach ($File in $OldFiles) {
                Write-Host "   [-] Removing old setup file: $($File.Name)" -ForegroundColor DarkYellow
                if (-not $DryRun) { Remove-Item -Path $File.FullName -Force }
            }
        }
    }

    # --------------------------------------------------------------------------
    # 2. CLEAN UP DLC INSTALLERS
    # --------------------------------------------------------------------------
    $LatestDlcSetup = Get-ChildItem -Path $Folder.FullName -File -Filter "setup_*.exe" | 
                      Where-Object { ($_.Name -match "phantom_liberty" -or $_.Name -like "dlc_*") -and $_.Name -notmatch "\.part$" } |
                      Sort-Object LastWriteTime -Descending | Select-Object -First 1

    if ($LatestDlcSetup) {
        if ($LatestDlcSetup.Name -match $PatternBuild) {
            $DlcBuild = $Matches.build
            Write-Host "   [DLC] Latest DLC version found: Build $DlcBuild" -ForegroundColor Gray

            $OldDlcFiles = Get-ChildItem -Path $Folder.FullName -File | 
                           Where-Object { ($_.Name -match "phantom_liberty" -or $_.Name -like "dlc_*") -and ($_.Extension -eq ".exe" -or $_.Extension -eq ".bin") -and $_.Name -notmatch $DlcBuild -and $_.Name -notmatch "\.part$" }

            foreach ($DlcFile in $OldDlcFiles) {
                Write-Host "   [-] Removing old DLC file: $($DlcFile.Name)" -ForegroundColor DarkYellow
                if (-not $DryRun) { Remove-Item -Path $DlcFile.FullName -Force }
            }
        }
    }

    # --------------------------------------------------------------------------
    # 3. CLEAN UP MAC INSTALLERS (.pkg)
    # --------------------------------------------------------------------------
    $LatestMacPkg = Get-ChildItem -Path $Folder.FullName -File -Filter "*english_*_mac*.pkg" | 
                    Where-Object { $_.Name -notmatch "\.part$" } |
                    Sort-Object LastWriteTime -Descending | Select-Object -First 1

    if ($LatestMacPkg) {
        if ($LatestMacPkg.Name -match $PatternMac) {
            $MacVersion = $Matches.version
            Write-Host "   [Mac] Latest Mac version found: $MacVersion" -ForegroundColor Gray

            $OldMacFiles = Get-ChildItem -Path $Folder.FullName -File -Filter "*.pkg" | 
                           Where-Object { $_.Name -notmatch $MacVersion -and $_.Name -notmatch "\.part$" }

            foreach ($MacFile in $OldMacFiles) {
                Write-Host "   [-] Removing old Mac package: $($MacFile.Name)" -ForegroundColor DarkYellow
                if (-not $DryRun) { Remove-Item -Path $MacFile.FullName -Force }
            }
        }
    }

    # --------------------------------------------------------------------------
    # 4. REMOVE INCREMENTAL PATCHES (.exe & .bin patches)
    # --------------------------------------------------------------------------
    $Patches = Get-ChildItem -Path $Folder.FullName -File | 
               Where-Object { $_.Name -like "patch_*" -and ($_.Extension -eq ".exe" -or $_.Extension -eq ".bin") }

    foreach ($Patch in $Patches) {
        Write-Host "   [-] Removing old incremental patch: $($Patch.Name)" -ForegroundColor DarkYellow
        if (-not $DryRun) { Remove-Item -Path $Patch.FullName -Force }
    }
}

Write-Host ""
Write-Host "========================================================================" -ForegroundColor Green
Write-Host " Cleanup completed for all game folders!" -ForegroundColor Green
Write-Host "========================================================================" -ForegroundColor Green
