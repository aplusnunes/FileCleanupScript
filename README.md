# FileCleanupScript

# File Cleanup Utility – PowerShell Script

This PowerShell script helps you manage and clean up files older than **24 months** in a specified directory. It provides the following features:

✅ Lists files older than 24 months  
✅ Exports the list to a `.csv` file  
✅ Offers a **Dry Run (Preview)** mode  
✅ Optionally deletes the files  
✅ Logs all deletions and any errors to a `.txt` log file

---

## 📂 Files Included

- `CleanupOldFiles.ps1` – The main PowerShell script  
- `README.md` – Instructions on how to use the script  
- `OldFilesReport.csv` – (Auto-generated) List of old files  
- `DeletedFilesLog.txt` – (Auto-generated) Log of deleted files and errors  

---

## 🚀 How to Use

### 1. **Open PowerShell**
Run PowerShell as Administrator (recommended for full access).

### 2. **Run the Script**
Navigate to the script directory, then run:

```powershell
.\CleanupOldFiles.ps1
