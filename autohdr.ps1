# Define the main registry path
$MainRegistryPath = "HKCU:\SOFTWARE\Microsoft\Direct3D"

# Check if the main registry path exists, if not create it
if (-not (Test-Path -Path $MainRegistryPath)) {
    New-Item -Path $MainRegistryPath -Force
}

Function Get-Action {
    # Prompt the user to choose whether to install, remove, or list entries
    do {
        $Action = Read-Host "Do you want to install, remove, or list entries? (i/r/l)"
    } while ($Action -ne 'i' -and $Action -ne 'r' -and $Action -ne 'l')

    return $Action
}

Function Get-D3DBehaviors {
    # Display options for "D3DBehaviors" and get user choice
    do {
        Write-Host "Choose an option for D3DBehaviors:"
        Write-Host "1. BufferUpgradeOverride=1"
        Write-Host "2. BufferUpgradeOverride=1;BufferUpgradeEnable10Bit=1"
        $Choice = Read-Host "Enter the number corresponding to your choice"
        
        if ($Choice -eq "1") {
            $D3DBehaviors = "BufferUpgradeOverride=1"
        } elseif ($Choice -eq "2") {
            $D3DBehaviors = "BufferUpgradeOverride=1;BufferUpgradeEnable10Bit=1"
        } else {
            Write-Host "Invalid choice. Please enter 1 or 2 for the D3DBehaviors option."
        }
    } while ($Choice -ne '1' -and $Choice -ne '2')
    
    return $D3DBehaviors
}

Function Perform-Action {
    param (
        [string]$Action
    )

    if ($Action -eq "i") {
        # Prompt the user for the "Name" value
        $Name = Read-Host "Enter the name of the .exe (e.g., Starfield.exe)"
        $D3DBehaviors = Get-D3DBehaviors
        
        # Define the registry path including the name
        $RegistryPath = Join-Path -Path $MainRegistryPath -ChildPath $Name

        # Create a new subkey for the .exe and set the "Name" and "D3DBehaviors" values in the registry
        if (-not (Test-Path -Path $RegistryPath)) {
            New-Item -Path $RegistryPath -Force
        }
        Set-ItemProperty -Path $RegistryPath -Name "Name" -Value $Name
        Set-ItemProperty -Path $RegistryPath -Name "D3DBehaviors" -Value $D3DBehaviors

        Write-Host "Registry values installed."

    } elseif ($Action -eq "r") {
        # Get the list of existing subkeys
        $SubKeys = Get-ChildItem -Path $MainRegistryPath

        # If no subkeys are found, notify the user
        if ($SubKeys.Count -eq 0) {
            Write-Host "No entries found."
        } else {
            # Display the list of subkeys and prompt the user to choose one to remove
            $Index = 0
            foreach ($SubKey in $SubKeys) {
                Write-Host "$Index. $($SubKey.Name -replace '.*\\', '')"
                $Index++
            }
            
            # Get user choice for removal
            $Choice = Read-Host "Enter the number corresponding to the entry you wish to remove, or enter 'all' to remove all entries"
            
            if ($Choice -eq 'all') {
                # Confirm before removing all entries
                $Confirm = Read-Host "Are you sure you want to remove all entries? (y/n)"
                if ($Confirm -eq 'y') {
                    Remove-Item -Path $MainRegistryPath -Recurse -Force
                    New-Item -Path $MainRegistryPath -Force
                    Write-Host "All entries removed."
                }
            } else {
                # Remove the chosen entry
                try {
                    $SelectedSubKey = $SubKeys[[int]$Choice]
                    Remove-Item -Path $SelectedSubKey.FullName -Force
                    Write-Host "Entry removed."
                } catch {
                    Write-Host "Invalid choice. No entries were removed."
                }
            }
        }

    } elseif ($Action -eq "l") {
        # Get and display the list of existing subkeys
        $SubKeys = Get-ChildItem -Path $MainRegistryPath

        # If no subkeys are found, notify the user
        if ($SubKeys.Count -eq 0) {
            Write-Host "No entries found."
        } else {
            # Display the list of subkeys
            foreach ($SubKey in $SubKeys) {
                Write-Host "$($SubKey.Name -replace '.*\\', '')"
            }
        }

        # Re-prompt the user for their action
        $Action = Get-Action
        Perform-Action -Action $Action
    }
}

# Get the initial action from the user
$Action = Get-Action

# Perform the initial action
Perform-Action -Action $Action

Write-Host "Script completed."
