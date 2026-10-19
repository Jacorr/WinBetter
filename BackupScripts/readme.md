# OVERVIEW
Scripts to create full backup from my PC (laptop Legion) to NAS server and external offline disc and cloud backup.
Solution is not fully automated!

## Steps

### Preparation
1. Ensure is NAS connection is established
1. Connect external Yellow Disc
- if disk is not recognised then reboot Windows
1. Ensure VERACRYPT drives are unmounted

### Backup configurations

1. Log in to router and backup configuration
1. Log in to NAS and backup configuration
1. Run script **config-backup.ps1** to backup all configurations
1. Move configuration's backup to NAS and Yellow Disc
1. Move encrypted SafeBox into NAS, Yellow Disc and Google Drive

### Backup photos,  books
1. Run script **move_to_NAS.ps1** to move
- photos
- installs
- books
- audios etc

### Verify
1. Check if everything was correctly backup


## TODO
1. E:\Backups\AppConfigs\$dateDir - przenieść na NAS !!!
1. E:\Edukacja - przenieść do kontenera?
1. Params output path to move for NAS or external disc
1. Backup script move to GIT