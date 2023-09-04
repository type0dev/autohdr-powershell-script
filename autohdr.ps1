# Prompt the user to choose whether to install or remove entries
$Action = Read-Host "Do you want to install or remove entries? (i/r)"

if ($Action -eq "i") {
    # Prompt the user for the "Name" value
    $Name = Read-Host "Enter the name of the .exe (e.g., Starfield.exe)"

    # Display options for "D3DBehaviors"
    Write-Host "Choose an option for D3DBehaviors:"
    Write-Host "1. BufferUpgradeOverride=1"
    Write-Host "2. BufferUpgradeOverride=1;BufferUpgradeEnable10Bit=1"

    # Prompt the user for their choice
    $Choice = Read-Host "Enter the number corresponding to your choice"

    # Validate the user's choice for "D3DBehaviors"
    if ($Choice -eq "1") {
        $D3DBehaviors = "BufferUpgradeOverride=1"
    } elseif ($Choice -eq "2") {
        $D3DBehaviors = "BufferUpgradeOverride=1;BufferUpgradeEnable10Bit=1"
    } else {
        Write-Host "Invalid choice. Please enter 1 or 2 for the D3DBehaviors option."
        exit
    }

    # Define the registry path
    $RegistryPath = "HKCU:\SOFTWARE\Microsoft\Direct3D"

    # Set the "Name" and "D3DBehaviors" values in the registry
    Set-ItemProperty -Path $RegistryPath -Name "Name" -Value $Name
    Set-ItemProperty -Path $RegistryPath -Name "D3DBehaviors" -Value $D3DBehaviors

    Write-Host "Registry values installed."
} elseif ($Action -eq "r") {
    # Define the registry path
    $RegistryPath = "HKCU:\SOFTWARE\Microsoft\Direct3D"

    # Remove the entries
    Remove-ItemProperty -Path $RegistryPath -Name "Name" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $RegistryPath -Name "D3DBehaviors" -ErrorAction SilentlyContinue

    Write-Host "Registry entries removed."
} else {
    Write-Host "Invalid action. Please enter 'i' for install or 'r' for remove."
}

Write-Host "Script completed."
