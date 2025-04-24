# PowerShell Script: Manage Files Older Than 24 Months
# Features: Dry Run Preview, Deletion with Logging, and Export to CSV

# Prompt user for the directory
$directory = Read-Host "Enter the full path of the directory to search"

# Calculate cutoff date
$cutoffDate = (Get-Date).AddMonths(-24)

# Prepare paths for log and export files (same directory as script)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$logFile = Join-Path -Path $scriptDir -ChildPath "DeletedFilesLog.txt"
$exportFile = Join-Path -Path $scriptDir -ChildPath "OldFilesReport.csv"

# Find files older than 24 months
$oldFiles = Get-ChildItem -Path $directory -File -Recurse | Where-Object { $_.LastWriteTime -lt $cutoffDate }

# Check if files exist
if ($oldFiles.Count -eq 0) {
    Write-Host "No files older than 24 months were found in '$directory'."
} else {
    # Display the list in the terminal
    Write-Host "`nFound $($oldFiles.Count) file(s) older than 24 months:`n"
    $oldFiles | Select-Object FullName, LastWriteTime | Format-Table -AutoSize

    # Export the list to CSV
    $oldFiles | Select-Object FullName, LastWriteTime | Export-Csv -Path $exportFile -NoTypeInformation
    Write-Host "`nExported list to: $exportFile"

    # Ask user for action
    $action = Read-Host "`nWhat would you like to do? Enter 'D' to Delete, 'P' to Preview (Dry Run), or anything else to Cancel"

    if ($action -match '^[Pp]$') {
        Write-Host "`nDry Run Preview – These files would be deleted:"
        $oldFiles | Select-Object FullName, LastWriteTime | Format-Table -AutoSize
        Write-Host "`nNo files were deleted. This was a preview only."
    }
    elseif ($action -match '^[Dd]$') {
        "`nDeletion started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -Append $logFile
        foreach ($file in $oldFiles) {
            try {
                Remove-Item -Path $file.FullName -Force
                "Deleted: $($file.FullName) | LastWriteTime: $($file.LastWriteTime)" | Out-File -Append $logFile
            } catch {
                "Failed to delete: $($file.FullName) | Error: $_" | Out-File -Append $logFile
            }
        }
        "`nDeletion completed: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n" | Out-File -Append $logFile
        Write-Host "`nFiles deleted successfully. Log saved to $logFile"
    }
    else {
        Write-Host "`nOperation canceled. No files were deleted."
    }
}
