# todo: verify id zmiana w pliku powinna byc wykrywana i podlegać backupowi

$backupPath = '\\192.168.0.200\public'

function Show-Error($path) {
	Write-Error -Message "Path not found - ${path}"
}

function Show-Header($path) {
	Write-Host -ForegroundColor Green "***** ***** ***** ***** ***** ***** ***** *****" 
	Write-Host -ForegroundColor Green "***** BACKUP = ${path}"
	Write-Host -ForegroundColor Green "***** ***** ***** ***** ***** ***** ***** *****"
}

# Code
$booksSourcePath = 'D:\Code\BackupScripts'
Show-Header $booksSourcePath
if (Test-Path $booksSourcePath) {
	robocopy $booksSourcePath "${backupPath}\Code\BackupScripts" *.* /DCOPY:DAT /COPY:DAT /V /R:5 /W:10
}
else {
	Show-Error $booksSourcePath
}

# Ksiązki
$booksSourcePath = 'E:\Books'
Show-Header $booksSourcePath
if (Test-Path $booksSourcePath) {
	robocopy $booksSourcePath "${backupPath}\Books" *.* /DCOPY:DAT /COPY:DAT /V /R:5 /W:10
}
else {
	Show-Error $booksSourcePath
}

# Instalki
$installsSourcePath = 'E:\Installs'
Show-Header $installsSourcePath
if (Test-Path $installsSourcePath) {
	robocopy $installsSourcePath "${backupPath}\Installs" *.* /DCOPY:DAT /COPY:DAT /V /R:5 /W:10
}
else {
	Show-Error $installsSourcePath
}

# Zdjęcia
$photosSourcePath = 'E:\Photos'
Show-Header $photosSourcePath
if (Test-Path $photosSourcePath) {
	robocopy $photosSourcePath "${backupPath}\Photos" *.* /DCOPY:DAT /COPY:DAT /V /R:5 /W:10
}
else {
	Show-Error $photosSourcePath
}

# Kontenery VeraCrypt
# Copy always because of containers contain many files which are hidden by encryption
$containersSourcePath = 'D:\Containers'
Show-Header $containersSourcePath

# todo: override task
if (Test-Path 'I:\') {
	Write-Host -ForegroundColor Yellow 'WARNING: There is available disc I:\ what suggests container is attached (it could break backup)'	
}

if (Test-Path $containersSourcePath) {
	# is it hack for mark files as changed to be ready for backup
	Get-ChildItem $containersSourcePath -File |% { $_.LastWriteTime = Get-Date }
	
	robocopy $containersSourcePath "${backupPath}\Containers" *.* /E /IS /IT /V /R:5 /W:10
}
else {
	Show-Error $containersSourcePath
}

# Application configuration backup
robocopy "E:\Backups" "${backupPath}\Backups" *.* /E /R:5 /W:10 /NFL /NDL /NP
