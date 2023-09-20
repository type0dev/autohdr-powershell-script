<#
.SYNOPSIS
This script manages Direct3D registry entries for various executable files, allowing the user to install, remove, or list registry entries.
.DESCRIPTION
The script facilitates the management of Direct3D registry settings by:
- Creating the main registry path if it does not exist
- Prompting users to install new settings, remove existing ones, or list all current entries
.EXAMPLE
Run the script and follow the on-screen prompts to manage Direct3D registry entries.
#>

# Define the main registry path
$MainRegistryPath = "HKCU:\SOFTWARE\Microsoft\Direct3D"

# Check if the main registry path exists, if not create it
if (-not (Test-Path -Path $MainRegistryPath)) {
    New-Item -Path $MainRegistryPath -Force
}

Function Get-Action {
    # Prompt the user to choose whether to install, remove, or list entries
    do {
        $Action = Read-Host "Do you want to install, remove, or list entries, or exit? (i/r/l/x)"
        if ($Action -eq 'x') {
            Write-Host "Exiting script..."
            exit
        }
    } while ($Action -ne 'i' -and $Action -ne 'r' -and $Action -ne 'l')

    return $Action
}

Function Get-D3DBehaviors {
    # Display options for "D3DBehaviors" and get user choice
    do {
        Write-Host "Choose an option for D3DBehaviors:"
        Write-Host "1. BufferUpgradeOverride=1"
        Write-Host "2. BufferUpgradeOverride=1;BufferUpgradeEnable10Bit=1"
        $Choice = Read-Host "Enter the number corresponding to your choice, or enter 'x' to exit"
        
        if ($Choice -eq "1") {
            $D3DBehaviors = "BufferUpgradeOverride=1"
        }
        elseif ($Choice -eq "2") {
            $D3DBehaviors = "BufferUpgradeOverride=1;BufferUpgradeEnable10Bit=1"
        }
        elseif ($Choice -eq 'x') {
            Write-Host "Exiting script..."
            exit
        }
        else {
            Write-Host "Invalid choice. Please enter 1, 2 or 'x' to exit."
        }
    } while ($Choice -ne '1' -and $Choice -ne '2')
    
    return $D3DBehaviors
}

Function Perform-Action {
    param (
        [string]$Action
    )
    
    if ($Action -eq "i") {
        $Name = Read-Host "Enter the name of the .exe (e.g., Starfield.exe), or enter 'x' to exit"
        if ($Name -eq 'x') {
            Write-Host "Exiting script..."
            exit
        }
        $D3DBehaviors = Get-D3DBehaviors
        $RegistryPath = Join-Path -Path $MainRegistryPath -ChildPath $Name
        
        if (-not (Test-Path -Path $RegistryPath)) {
            New-Item -Path $RegistryPath -Force
        }
        Set-ItemProperty -Path $RegistryPath -Name "Name" -Value $Name
        Set-ItemProperty -Path $RegistryPath -Name "D3DBehaviors" -Value $D3DBehaviors

        Write-Host "Registry values installed."
        
    }
    elseif ($Action -eq "r") {
        $SubKeys = Get-ChildItem -Path $MainRegistryPath

        if ($SubKeys.Count -eq 0) {
            Write-Host "No entries found."
        }
        else {
            $Index = 1
            foreach ($SubKey in $SubKeys) {
                $SubKeyDetail = Get-Item -LiteralPath $SubKey.PSPath
                Write-Host "$Index. $($SubKeyDetail.Name -replace '.*\\', '')"
                $SubKeys[$Index - 1] = $SubKeyDetail
                $Index++
            }

            $Choice = Read-Host "Enter the number corresponding to the entry you wish to remove, or enter 'all' to remove all entries, or enter 'x' to exit"
            
            if ($Choice -eq 'x') {
                Write-Host "Exiting script..."
                exit
            }
            elseif ($Choice -eq 'all') {
                $Confirm = Read-Host "Are you sure you want to remove all entries? (y/n/x)"
                if ($Confirm -eq 'x') {
                    Write-Host "Exiting script..."
                    exit
                }
                elseif ($Confirm -eq 'y') {
                    Remove-Item -Path $MainRegistryPath -Recurse -Force
                    New-Item -Path $MainRegistryPath -Force
                    Write-Host "All entries removed."
                }
            }
            else {
                if ($Choice -match '^\d+$' -and [int]$Choice -ge 1 -and [int]$Choice -le $SubKeys.Count) {
                    $SelectedSubKey = $SubKeys[[int]$Choice - 1]
                    Remove-Item -Path $SelectedSubKey.PSPath -Force
                    Write-Host "Entry removed."
                }
                else {
                    Write-Host "Invalid choice. No entries were removed."
                }
            }
        }

        
    }
    elseif ($Action -eq "l") {
        $SubKeys = Get-ChildItem -Path $MainRegistryPath

        if ($SubKeys.Count -eq 0) {
            Write-Host "No entries found."
        }
        else {
            foreach ($SubKey in $SubKeys) {
                Write-Host "$($SubKey.Name -replace '.*\\', '')"
            }
        }
    }
}

do {
    # Get the initial action from the user
    $Action = Get-Action

    # Perform the initial action
    Perform-Action -Action $Action
} while ($true)
