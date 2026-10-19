Start-Process -FilePath "C:\rclone\rclone.exe" `
    -ArgumentList "mount ProtonDrive: P: --vfs-cache-mode full" `
    -WindowStyle Hidden