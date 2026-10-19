Start-Process -FilePath "C:\rclone\rclone.exe" `
    -ArgumentList "mount GDrive: G: --vfs-cache-mode full" `
    -WindowStyle Hidden