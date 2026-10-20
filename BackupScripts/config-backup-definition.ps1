$winUserName = $env:USERNAME

$userProfilePath = "C:\Users\$winUserName"
$roamingPath = Join-Path $userProfilePath 'AppData\Roaming'
$localPath = Join-Path $userProfilePath 'AppData\Local'
$documentsPath = [Environment]::GetFolderPath('MyDocuments')

$fireFoxProfileName = 'dlkzgzgi.default-release-1761843228487'

$paths = [System.Collections.Generic.Dictionary[string, string[]]]::new()
$paths['Rider'] = @(
    Get-ChildItem -LiteralPath "$roamingPath\JetBrains" -Directory -Filter 'Rider*' | Select-Object -ExpandProperty FullName
)
$paths['Kopia'] = @(
    "$roamingPath\kopia"
)
$paths['VSCode'] = @(
    "$roamingPath\Code\User"
    "$userProfilePath\.vscode\extensions"
)
$paths['VS2026'] = @(
    "$roamingPath\Microsoft\VisualStudio"
    "$localPath\Microsoft\VisualStudio"
    "$documentsPath\Visual Studio 18"
)
# Include all Firefox profiles and the profile registration files.
$paths['FireFox'] = @(
    "$roamingPath\Mozilla\Firefox\Profiles\$fireFoxProfileName"
)
$paths['Powershell'] = @(
    "$documentsPath\PowerShell"
    "$documentsPath\WindowsPowerShell"
    "$userProfilePath\PowerShellProfile.ps1"
)
$paths['Git'] = @(
    "$userProfilePath\.gitconfig"
    "$userProfilePath\.config\git"
)
$paths['Libre Office'] = @(
    "$roamingPath\LibreOffice\4\user"
)
$paths['RSS Guard'] = @(
    "$localPath\RSS Guard 5\data"
)
