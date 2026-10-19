Start-Process -FilePath "C:\rclone\rclone.exe" `
    -ArgumentList "mount OneDrive: O: --vfs-cache-mode full" `
    -WindowStyle Hidden