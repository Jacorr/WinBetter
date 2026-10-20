function Write-Header {
    param ([string]$header)

    $color = 'Green'
    $bcgColor = 'Black'

    Write-Host "###############################################################################################" -ForegroundColor $color -BackgroundColor $bcgColor
    Write-Host "#         $header"                                                                               -ForegroundColor $color -BackgroundColor $bcgColor
    Write-Host "###############################################################################################" -ForegroundColor $color -BackgroundColor $bcgColor
}

function Get-CorespondendBackupPath {
    param(
        [Parameter(Mandatory)]
        [string]$inputPath
    )

    return ($inputPath -replace '[<>:"|?*]', '').TrimStart([char[]]'\/')
}

function Backup-Dir {
    param(
        [string]$name,
        [string]$baseDir,
        [string]$backupDir
    )

    # Robocopy doesn't have such problems. Its params
    # /R:0 → No retries on fail copying item
    # /W:0 → No waits on fail copying item 
    # /NFL → No File List (hides every copied file)
    # /NDL → No Directory List
    # /NP → No Progress per file (removes per-file % spam)
    robocopy $baseDir $backupDir /E /R:0 /W:0 /NFL /NDL /NP

    Write-Host $name + ': Done'
}

# ***************************************************************************************************************************
#       BACKUP EXECUTION
# ***************************************************************************************************************************

$dateDir = [System.DateTime]::Now.ToString("yyyy-MM-dd_HH.mm.ss")
$backupDir = "E:\BackupConfigs\AppConfigs\$dateDir"

mkdir $backupDir

# initialize backups
. "$PSScriptRoot\config-backup-definition.ps1"

$backupTimer = [System.Diagnostics.Stopwatch]::StartNew()

foreach ($app in $paths.GetEnumerator()) {
    foreach ($inputPath in $app.Value) {
        if (-not (Test-Path -LiteralPath $inputPath)) {
            Write-Warning "Skipping missing configuration path: $inputPath"
            continue
        }

        $backupPath = Join-Path -Path $backupDir -ChildPath (Get-CorespondendBackupPath -inputPath $inputPath)

        Write-Host "$($app.Key): $inputPath => $backupPath"

        if (Test-Path -LiteralPath $inputPath -PathType Leaf) {
            $destinationDir = Split-Path -Path $backupPath -Parent
            New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
            Copy-Item -LiteralPath $inputPath -Destination $backupPath -Force
        }
        else {
            Backup-Dir -name $app.Key -baseDir $inputPath -backupDir $backupPath
        }
    }
}

$backupTimer.Stop()

$backupSizeBytes = (Get-ChildItem -LiteralPath $backupDir -File -Recurse -Force |
    Measure-Object -Property Length -Sum).Sum
if ($null -eq $backupSizeBytes) {
    $backupSizeBytes = 0
}

Write-Header 'Backup summary'
Write-Host ('Execution time: {0}' -f $backupTimer.Elapsed.ToString('c'))
Write-Host ('Archived data size: {0:N2} MiB ({1:N0} bytes)' -f ($backupSizeBytes / 1MB), $backupSizeBytes)
Write-Host "Backup directory: $backupDir"
