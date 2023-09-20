# This script allows users to install or remove registry entries pertaining to Direct3D configurations
$RegistryPath = "HKCU:\SOFTWARE\Microsoft\Direct3D"

# Check if the registry path exists and create it if necessary
if (-not (Test-Path -Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force
}

# Prompt the user to choose whether to install or remove entries
$ValidAction = $false
while (-not $ValidAction) {
    $Action = (Read-Host "Do you want to install or remove entries? (i/r)").ToLower()
    
    if ($Action -eq "i" -or $Action -eq "r") {
        $ValidAction = $true
    } else {
        Write-Host "Invalid action. Please enter 'i' for install or 'r' for remove."
    }
}

if ($Action -eq "i") {
    # Prompt the user for the "Name" value
    $Name = Read-Host "Enter the name of the .exe (e.g., Starfield.exe)"

    # Display options for "D3DBehaviors"
    $ValidChoice = $false
    while (-not $ValidChoice) {
        Write-Host "Choose an option for D3DBehaviors:"
        Write-Host "1. BufferUpgradeOverride=1"
        Write-Host "2. BufferUpgradeOverride=1;BufferUpgradeEnable10Bit=1"

        # Prompt the user for their choice
        $Choice = Read-Host "Enter the number corresponding to your choice"
        
        if ($Choice -eq "1") {
            $D3DBehaviors = "BufferUpgradeOverride=1"
            $ValidChoice = $true
        } elseif ($Choice -eq "2") {
            $D3DBehaviors = "BufferUpgradeOverride=1;BufferUpgradeEnable10Bit=1"
            $ValidChoice = $true
        } else {
            Write-Host "Invalid choice. Please enter 1 or 2 for the D3DBehaviors option."
        }
    }

    # Set the "Name" and "D3DBehaviors" values in the registry
    Set-ItemProperty -Path $RegistryPath -Name "Name" -Value $Name
    Set-ItemProperty -Path $RegistryPath -Name "D3DBehaviors" -Value $D3DBehaviors
    Write-Host "Registry values installed."
} elseif ($Action -eq "r") {
    # Remove the entries
    Remove-ItemProperty -Path $RegistryPath -Name "Name" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $RegistryPath -Name "D3DBehaviors" -ErrorAction SilentlyContinue
    Write-Host "Registry entries removed."
}

Write-Host "Script completed."
