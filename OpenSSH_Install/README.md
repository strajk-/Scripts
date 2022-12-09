### Installs and configures OpenSSH on Windows
**Requirements:**
- Windows 8 or newer
- Elevated privileges (Run as Administrator)
- [OpenSSH Release](https://github.com/PowerShell/Win32-OpenSSH/releases  "OpenSSH Release") extracted as an OpenSSH folder in the same directory as this script is located at

![](https://github.com/strajk-/Scripts/blob/main/!Resources/OpenSSH_Install_Structure.png)

**What it does:**
1. Copies .\OpenSSH to %ProgramFiles%\OpenSSH
2. Creates required .ssh folder and empty files in %UserProfile%\.ssh
3. Installs OpenSSH using the PowerShell scripts shipped with the release
4. Creates an Inbound Firewall rule at Port 22
5. Sets the OpenSSH Server Service startup type to Automatic and starts it

**Result:**

You will be able to SSH into this machine using your Windows User and Password, if you want to setup an RSA key you will have to do that on your own, that process is not part of this deployment script.
