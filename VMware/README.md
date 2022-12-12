### VMware scripts
**Requirements:**
- [VMware Tools](https://customerconnect.vmware.com/downloads/info/slug/datacenter_cloud_infrastructure/vmware_tools/12_x "VMware Tools") (Installs automatically with Workstation Pro)

**SuspendAllVMs.bat**
1. Fetches a list of all VMs with vmlist
2. Suspends all VMs

**SuspendAndShutdown.bat**
1. Uses SuspendAllVms.bat to suspend all VMs
2. Perform system shutdown in 10 seconds

**SuspendAndRestart.bat**
1. Uses SuspendAllVms.bat to suspend all VMs
2. Perform system restart in 10 seconds

**BackupAllVMs.bat**
(ex: BackupAllVMs.bat C:\VM_Backup 1)
1. Fetches a list of all VMs with vmlist
2. Suspends all VMs
3. Copies all VM Folders of the suspended VMs to the %OutputDirectory% given as the Batch Parameter
4. Starts all suspended VMs back up with vmrun as %guiMode% being "gui" or "nogui" depending if the second Batch Parameter was 1 for nogui or anything else for gui
