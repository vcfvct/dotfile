# This script removes specified applications from the Windows taskbar that is added by company policy on every startup. it can be added to Windows Task Scheduler to run at logon.

# In the Actions pane, click Create Task.
# Give the task a name, such as “Remove Taskbar Shortcuts.”
# Go to the Triggers tab and click New. Set it to begin the task At log on and select Any user if you want it to run for anyone logging in.
# Go to the Actions tab, click New, and select Start a Program.
# In the Program/script field, enter powershell.exe.
# In the Add arguments (optional) field, type:
# -ExecutionPolicy Bypass -File "C:\Scripts\RemoveTaskbarShortcuts.ps1"

# Define the names of applications to remove from the taskbar
$appsToRemove = @("Microsoft 365 (Office)", "People (Preview)", "Files (Preview)")

# Attempt to get a Shell COM object and the AppsFolder
$shell = New-Object -ComObject Shell.Application
$appsFolderPath = $shell.NameSpace('shell:AppsFolder')

if ($appsFolderPath -eq $null) {
    Write-Output "Could not access AppsFolder. Ensure you have the necessary permissions and try again."
    exit
}

# Proceed if AppsFolder was accessed successfully
foreach ($appName in $appsToRemove) {
    foreach ($item in $appsFolderPath.Items()) {
        if ($item.Name -eq $appName) {
            # Unpin from taskbar
            $item.InvokeVerb("taskbarunpin")
            Write-Output "Unpinned $appName from taskbar."
        }
    }
}

# Restart Explorer to refresh taskbar icons
# Stop-Process -Name explorer -Force
Start-Process -FilePath "ie4uinit.exe" -ArgumentList "-show"
