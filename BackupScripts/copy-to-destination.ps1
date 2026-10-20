$backupPath = '\\192.168.0.200\public'

function Show-Error($path) {
	Write-Error -Message "Path not found - ${path}"
}

function Show-Header($path) {
	Write-Host -ForegroundColor Green "***** ***** ***** ***** ***** ***** ***** *****" 
	Write-Host -ForegroundColor Green "***** BACKUP = ${path}"
	Write-Host -ForegroundColor Green "***** ***** ***** ***** ***** ***** ***** *****"
}

function Copy-ToDestination {
    param(
        [Parameter(Mandatory)]
        [string]$sourcePath,
        [Parameter(Mandatory)]
        [string]$destinationPath,
        [string[]]$copyOptions = @('/DCOPY:DAT', '/COPY:DAT', '/V'),
        [switch]$updateLastWriteTime
    )

    Show-Header $sourcePath
    if (-not (Test-Path -LiteralPath $sourcePath -PathType Container)) {
        Show-Error $sourcePath
        return
    }

    if ($updateLastWriteTime) {
        Get-ChildItem -LiteralPath $sourcePath -File | ForEach-Object { $_.LastWriteTime = Get-Date }
    }

    robocopy $sourcePath $destinationPath *.* @copyOptions /R:5 /W:10
}

$backupSources = @(
    @{ sourcePath = 'E:\Books'; destinationPath = 'Books' }
    @{ sourcePath = 'E:\Installs'; destinationPath = 'Installs' }
    @{ sourcePath = 'E:\Photos'; destinationPath = 'Photos' }
    @{
        sourcePath = 'D:\Containers'
        destinationPath = 'Containers'
        copyOptions = @('/E', '/IS', '/IT', '/V')
        updateLastWriteTime = $true
    }
    @{
        sourcePath = 'E:\BackupConfigs'
        destinationPath = 'Backups'
        copyOptions = @('/E', '/NFL', '/NDL', '/NP')
    }
)

foreach ($source in $backupSources) {
    $copyParameters = $source.Clone()
    $copyParameters.destinationPath = Join-Path -Path $backupPath -ChildPath $source.destinationPath
    Copy-ToDestination @copyParameters
}
