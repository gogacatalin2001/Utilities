#======================================================================
# CHECK IF THE SCRIPT IS ELEVATED / ELEVATE IF NOT
#======================================================================
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Exit
}

#======================================================================
# NO POWERSHELL WINDOW DURING THE INSTALL
#======================================================================
$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
add-type -name win -member $t -namespace native
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)

#======================================================================
# TURN OFF PROGRESS BAR TO MAKE SCRIPT RUN FASTER
#======================================================================

$ProgressPreference = 'SilentlyContinue'

#======================================================================
# BYPASS EXECUTION POLICY TO ALLOW SCRIPT TO RUN
#======================================================================

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Check if winget is installed
        Write-Host "Checking if Winget is Installed..."
        $wingetPath = $env:LOCALAPPDATA + "\Microsoft\WindowsApps\winget.exe"
        if (Test-Path $wingetPath) {
            #Checks if winget executable exists and if the Windows Version is 1809 or higher
            Write-Host "Winget Already Installed"
        }
        else {
            #Gets the computer's information
            $ComputerInfo = Get-ComputerInfo

            #Gets the Windows Edition
            $OSName = if ($ComputerInfo.OSName) {
                $ComputerInfo.OSName
            }else {
                $ComputerInfo.WindowsProductName
            }

            if (((($OSName.IndexOf("LTSC")) -ne -1) -or ($OSName.IndexOf("Server") -ne -1)) -and (($ComputerInfo.WindowsVersion) -ge "1809")) {
                
                Write-Host "Running Alternative Installer for LTSC/Server Editions"

                Switching to winget-install from PSGallery from asheroto
                Source: https://github.com/asheroto/winget-in...
                
                Start-Process powershell.exe -Verb RunAs -ArgumentList "-command irm https://raw.githubusercontent.com/Chr... | iex | Out-Host" -WindowStyle Normal
                
            }
            elseif (((Get-ComputerInfo).WindowsVersion) -lt "1809") {
                #Checks if Windows Version is too old for winget
                Write-Host "Winget is not supported on this version of Windows (Pre-1809)"
            }
            else {
                #Installing Winget from the Microsoft Store
                Write-Host "Winget not found, installing it now."
                Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"
                $nid = (Get-Process AppInstaller).Id
                Wait-Process -Id $nid
                Write-Host "Winget Installed"
            }
        }

# ================== BASIC PROGRAMS ================== #
winget install google.chrome                            -h --accept-package-agreements --accept-source-agreements
winget install 7zip.7zip                                -h --accept-package-agreements --accept-source-agreements
winget install VideoLAN.VLC                             -h --accept-package-agreements --accept-source-agreements
winget install c0re100.qBittorrent-Enhanced-Edition     -h --accept-package-agreements --accept-source-agreements
# ================ DEVELOPER PROGRAMS ================ #
# WSL
wsl                                                     --install
# RUNTIMES
winget install Oracle.JavaRuntimeEnvironment            -h --accept-package-agreements --accept-source-agreements
# JDKs
winget install Oracle.JDK.21                            -h --accept-package-agreements --accept-source-agreements
winget install Oracle.JDK.17                            -h --accept-package-agreements --accept-source-agreements
winget install Anaconda.Anaconda3                       -h --accept-package-agreements --accept-source-agreements
# TOOLS
winget install Git.Git                                  -h --accept-package-agreements --accept-source-agreements
winget install Docker.DockerDesktop                     -h --accept-package-agreements --accept-source-agreements

winget install Microsoft.VisualStudio.2022.BuildTools   -h --accept-package-agreements --accept-source-agreements
# IDEs
winget install Notepad++.Notepad++                      -h --accept-package-agreements --accept-source-agreements
winget install Microsoft.VisualStudioCode               -h --accept-package-agreements --accept-source-agreements
winget install JetBrains.CLion                          -h --accept-package-agreements --accept-source-agreements
winget install JetBrains.IntelliJIDEA.Ultimate          -h --accept-package-agreements --accept-source-agreements
winget install JetBrains.PyCharm.Professional           -h --accept-package-agreements --accept-source-agreements
winget install ArduinoSA.IDE.stable                     -h --accept-package-agreements --accept-source-agreements
# ==================== GAMING ======================= #
winget install Nvidia.GeForceExperience                 -h --accept-package-agreements --accept-source-agreements
