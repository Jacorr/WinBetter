# BACKUP all configurations
# Close all programs to avoid lock of configs files
# TODO
# - Backup-ConfigOfCredentials (certs, private keys etc)
# - Backup-WindowsSubsystemLinux


function Write-Header {
    param ([string]$header)

    $color = 'Yellow'
    $bcgColor = 'Black'

    Write-Host "###############################################################################################" -ForegroundColor $color -BackgroundColor $bcgColor
    Write-Host "#         $header" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "###############################################################################################" -ForegroundColor $color -BackgroundColor $bcgColor
}

function Backup-ConfigOfFireFox {
    param (
        [string]$winUserName,
        [string]$workingDir
    )

    Write-Header "Backup-ConfigOfFireFox"

    $fireFoxProfileName = 'dlkzgzgi.default-release-1761843228487'

    # FireFox
    $fireFoxPathExtensionSource = "C:\Users\$winUserName\AppData\Roaming\Mozilla\Firefox\Profiles\$fireFoxProfileName\"
    $fireFoxPathExtensionDest = "$workingDir\C\Users\$winUserName\AppData\Roaming\Mozilla\Firefox\Profiles\$fireFoxProfileName\"

    # Copy-Item had problem with copying more complex files/dirs structure.

    # Robocopy doesn't have such problems. Its params
    # /R:0 → No retries on fail copying item
    # /W:0 → No waits on fail copying item 
    # /NFL → No File List (hides every copied file)
    # /NDL → No Directory List
    # /NP → No Progress per file (removes per-file % spam)
    robocopy $fireFoxPathExtensionSource $fireFoxPathExtensionDest /E /R:0 /W:0 /NFL /NDL /NP
}

function Backup-ConfigOfLibreOffice {
    param (
        [string]$winUserName,
        [string]$workingDir
    )

    Write-Header "Backup-ConfigOfLibreOffice"

    # FireFox
    $libreOfficePathExtensionSource = "C:\Users\$winUserName\AppData\Roaming\LibreOffice\4\user\"
    $libreOfficeExtensionDest = "$workingDir\C\Users\$winUserName\AppData\Roaming\LibreOffice\4\user\"

    robocopy $libreOfficePathExtensionSource $libreOfficeExtensionDest /E /R:0 /W:0 /NFL /NDL /NP
}

function Backup-ConfigOfVisualStudio {
    param(
        [string]$workingDir
    )

    Write-Header "Backup-ConfigOfVisualStudio"

    # configuration
    popd
    cd "C:\Program Files\Microsoft Visual Studio\18\Insiders\Common7\IDE"
    .\devenv.exe /Command "Tools.ImportandExportSettings /export:$workingDir\visual-studio-2026-insider.txt"
    pushd

    # Snippets
    $vsPath = "Program Files\Microsoft Visual Studio\18\Insiders\VC#"
    robocopy "C:\$vsPath" "$workingDir\C\$vsPath" /E /R:0 /W:0 /NFL /NDL /NP

    # Default template
    $vsPath = "Program Files\Microsoft Visual Studio\18\Insiders\Common7\IDE\ItemTemplates"
    robocopy "C:\$vsPath" "$workingDir\C\$vsPath" /E /R:0 /W:0 /NFL /NDL /NP

    # Solution template
    $vsPath = "Program Files\Microsoft Visual Studio\18\Insiders\Common7\IDE\SolutionTemplates"
    robocopy "C:\$vsPath" "$workingDir\C\$vsPath" /E /R:0 /W:0 /NFL /NDL /NP    

    # Projects tempalte
    $vsPath = "Program Files\Microsoft Visual Studio\18\Insiders\Common7\IDE\ProjectTemplates"
    robocopy "C:\$vsPath" "$workingDir\C\$vsPath" /E /R:0 /W:0 /NFL /NDL /NP
}

function Backup-ConfigOfVsCode {
    param(
        [string]$workingDir,
        [string]$winUserName
    )

    Write-Header "Backup-ConfigOfVsCode"

    $vscConfigsPath = "Users\$winUserName\AppData\Roaming\Code\User"

    mkdir "$workingDir\C\$vscConfigsPath\"
    cp -Path "C:\$vscConfigsPath\settings.json" -Destination "$workingDir\C\$vscConfigsPath\"

    $vscConfigsPath = "Users\$winUserName\AppData\Roaming\Code\User"
    robocopy "C:\$vscConfigsPath\snippets\" "$workingDir\C\$vscConfigsPath\snippets\" /E /R:0 /W:0

    popd
    cd "C:\Users\$winUserName\AppData\Local\Programs\Microsoft VS Code\"
    code --list-extensions > "$workingDir\vscode-extensions-list.txt"
    pushd
}

function Backup-ConfigOfRssGuard {
    param(
        [string]$workingDir,
        [string]$winUserName
    )

    Write-Header "Backup-ConfigOfRssGuard"

    $rssConfigPath = "RSS Guard 5\data5"
    cp -Path "c:\$rssConfigPath" -Destination "$workingDir\C\$rssConfigPath"

    write 'Done'
}


function Backup-ConfigOfGit {
    param(
        [string]$workingDir,
        [string]$winUserName
    )

    Write-Header "Backup-ConfigOfGit"

    $gitConfigPath = "Users\$winUserName"
    cp -Path "C:\$gitConfigPath\.gitconfig" -Destination "$workingDir\C\$gitConfigPath\.gitconfig"

    write 'Done'
}

function Backup-ConfigOfPowerShell {
    param(
        [string]$workingDir,
        [string]$winUserName
    )

    Write-Header "Backup-ConfigOfPowerShell"

    $psPath = "Users\$winUserName"

	$oneDriveWps = "$workingDir\C\$psPath\OneDrive\Dokumenty\WindowsPowerShell"
	if (-not (Test-Path $oneDriveWps)) {
		mkdir $oneDriveWps
	}
	
	cp -Path $Profile -Destination $oneDriveWps
	
	$oneDrivePowerShell = "$workingDir\C\$psPath\OneDrive\Dokumenty\PowerShell"
	if (-not (Test-Path $oneDrivePowerShell)) {
		mkdir $oneDrivePowerShell
	}
	
	cp -Path $Profile -Destination "$workingDir\C\$psPath\OneDrive\Dokumenty\PowerShell"

    cp -Path "C:\$psPath\PowerShellProfile.ps1" -Destination "$workingDir\C\$psPath\PowerShellProfile.ps1"

    write 'Done'
}

function Backup-ConfigOfCredentials {
    # think about secure them
    echo 'Backup-ConfigOfCredentials - NOT IMPLEMENTED'
}

function Backup-WindowsSubsystemLinux {
    echo 'Backup-ConfigOfCredentials - NOT IMPLEMENTED'
}

function Kill-VisualStudioInstances {
    ps |? Name -eq 'devenv' | kill  
}

function Kill-VSCodeInstances {
    ps |? Name -eq 'Code' | kill
}

function Kill-FirefoxInstances {
    ps |? Name -eq 'Firefox' | kill
}

function Compress-Backup {
    param (
        [string]$backupFolder,
        [string]$workingDir,
        [string]$dateDir
    )
    
    # zip and move to backup
    $fullBackupFolderPath = "$backupFolder\all-configs_$dateDir.zip"

    echo "Zip is starting..."
    #Compress-Archive -Path "$workingDir\*" -DestinationPath $fullBackupFolderPath

    # [Window Title]
    # Compressed (zipped) Folders Error
    # [Content]
    # Windows cannot open the folder.
    # The Compressed (zipped) Folder 'E:\Backups\all-configs_2026-03-17_074349.zip' is invalid.
    # [OK]

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($workingDir, $fullBackupFolderPath)

    echo "Zip is done"
}

# ***************************************************************************************************************************
#       BACKUP EXECUTION
# ***************************************************************************************************************************
$winUserName = 'jacek.pszczolkowski'

$dateDir = [System.DateTime]::Now.ToString("yyyy-MM-dd_HH.mm.ss")
$workingDir = "E:\Backups\AppConfigs\$dateDir"

popd
mkdir $workingDir
cd $workingDir

# Prepare
Kill-VSCodeInstances
Kill-VisualStudioInstances
Kill-FirefoxInstances

# Execute backup
Backup-ConfigOfFireFox -winUserName $winUserName -workingDir $workingDir
Backup-ConfigOfVisualStudio -workingDir $workingDir
Backup-ConfigOfVsCode -winUserName $winUserName -workingDir $workingDir
Backup-ConfigOfGit -winUserName $winUserName -workingDir $workingDir
Backup-ConfigOfPowerShell -winUserName $winUserName -workingDir $workingDir
Backup-ConfigOfCredentials
Backup-ConfigOfRssGuard
Backup-WindowsSubsystemLinux

# DISABLED because of error (probably pathes are too long)
# The Compressed (zipped) Folder 'E:\Backups\all-configs_2026-03-17_074349.zip' is invalid.
# Compress-Backup -backupFolder $backupFolder -workingDir $workingDir -dateDir $dateDir

pushd
