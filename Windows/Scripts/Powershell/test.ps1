
param(
    # Installs basic programs
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty]
    [string]
    $Basic,
    # Installs developer tools
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty]
    [string]
    $Developer,
    # Installs gaming programs
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty]
    [string]
    $Gaming
)

if($Basic -eq "Y") {
    Write-Output "Basic programs will be installed"
}
if($Developer -eq "Y") {
    Write-Output "Developer programs will be installed"
}
if($Gaming -eq "Y") {
    Write-Output "Gaming programs will be installed"
}
