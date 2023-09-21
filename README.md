# Update registry to enable AutoHDR for games on Windows 11

This PowerShell script assists users in enabling Windows 11's AutoHDR feature for games that are not officially supported. It facilitates the management of Direct3D registry entries, allowing you to install, remove, or list registry entries related to AutoHDR settings.

## Description

The script aims to enhance your gaming experience on Windows 11 by enabling the AutoHDR feature for games that lack official support. Here is how it achieves this:

### Registry keys and values

The script modifies the Windows registry to manage the Direct3D settings for specific executable files. Here are the main components it interacts with:

- **Main registry path**: The script uses the registry path `HKCU:\SOFTWARE\Microsoft\Direct3D`, storing the Direct3D settings for different executables here.

- **D3DBehaviors**: This registry key is crucial in enabling AutoHDR as it defines the behaviors for Direct3D. Users can choose between two settings:
  - `BufferUpgradeOverride=1`: This setting is a general buffer upgrade override.
  - `BufferUpgradeOverride=1;BufferUpgradeEnable10Bit=1`: Along with buffer upgrade override, this setting enables 10-bit buffer support.
  
  These settings enable the AutoHDR feature for non-compatible games by overriding default buffer settings to ones compatible with AutoHDR.

- **Executable Name**: Users specify the executable file name for which the settings should be applied. This is stored as a new registry entry under the main registry path with the properties `Name` and `D3DBehaviors` defined to store the executable name and chosen Direct3D behaviors, respectively.

### Workflow

1. **Initialization**: The script initially verifies the existence of the main registry path, creating it if absent.
2. **Action selection**: Users are prompted to select an action — install, remove, or list entries, or exit the script.
3. **Details specification**: Depending on the chosen action, users may be required to specify details like the executable name or desired Direct3DBehaviors settings.

## Installation

To set up the script:

1. Ensure PowerShell is installed on your Windows 11 system.
2. Download the PowerShell script file from this repository.
3. Run it in a PowerShell environment with the required privileges to modify the registry entries.

## Usage

Execute the script in a PowerShell environment and adhere to the on-screen instructions to manage Direct3D registry entries effectively. Use the following command to run the script:

```sh
powershell -NoProfile -ExecutionPolicy Bypass -File "Path/To/Your/Script.ps1"
```

Replace `"Path/To/Your/Script.ps1"` with the actual path to your script.

## Contribution

Contributions are welcomed. Feel free to fork the repository and submit pull requests. Ensure to maintain the established coding style and conventions.

## License

[MIT License](LICENSE)