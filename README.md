# Windows Image Builder

Deploy this role to a Microsoft Windows Server to build custom Windows WIM images. The images can be used with Foreman, MDT, SCCM, and good old fashioned commandline favorite - DISM.  The roles and instructions will be written based on Foreman as the provisioning enginge. Future updates may include output files for other provisioners and installation media.

A web server is required before running this role. Some software used in the role has a license that prohibits redistribution. You will need to upload your licensed media to the web server for the role to use while running. After the inital Builder deployment and configuration, the web server downloads will no longer be needed and could be removed. It is recommended to use a private web server and keep the file for future use.

## Usage

* Prepare the Windows target for Ansible management.
* Download the role. (git or Galaxy)
* Create a playbook and inventory (See examples in Private Data System)
* Run playbook

## Settings

There are a set of variables that must be defined for the environment. 

win_build_base: Z:\source # location of builder source files

win_build_deploy: Z:\Deploy # location of finished output

win_build_wsusRoot: Z:\wsusoffline # location of WSUS Offline Updater root

win_build_katello: katello.example.com # FQDN of Katello server or proxy. 

win_build_share_iis: true # Set to false to not deploy local web server

win_build_share_cifs: true # Set to false to skip share creation. NOTE: The share is required for MDT and SCCM like deployments.

win_build_shareuser: windeploy # Local Windows user the share will be mounted read-only as

win_build_sharepass: ThisI5abAdPaSSwd # Local Windows user's password

win_build_ws_iso: https://download.example.com/iso/server16.iso # Location of Windows Server installation ISO. NOTE: Only test with 2016. Server 2019 will build images, but not be updated.

win_build_wimbooturl: https://git.ipxe.org/release/wimboot/wimboot-1.0.5.zip

## Example Playbook
<code>
- name: Configure ClusterApps Windows Build Server 
  hosts: winbuilder
  vars:
    win_build_ws_iso: https://download.internalweb.com/iso/server16.iso
    win_build_sharepass: NotBett3rButDiffer3nt
  roles:
    - win_builder

</code>

## Custom ISO

Creating a custom Windows Server 2022 installation ISO from a WIM (Windows Imaging Format) image involves several steps and requires certain tools. Before you start, ensure you have a legitimate copy of Windows Server 2022 and a valid license to use it. 

The general process involves capturing or modifying an existing WIM file, creating an answer file for unattended installation (optional), and then creating a bootable ISO image. Here’s a simplified overview of the process:

### Tools Required:
1. **Windows Assessment and Deployment Kit (Windows ADK):** Contains tools like Windows System Image Manager for creating answer files and Deployment Image Servicing and Management (DISM) for modifying WIM images.
2. **A copy of the Windows Server 2022 ISO:** To extract the original WIM file and other necessary files.
3. **ISO creation tool:** Such as `oscdimg`, a command-line tool for creating ISO files, part of the Windows ADK.

### Steps:

#### 1. Install Windows ADK
- Download and install the Windows ADK from the Microsoft website, including the Deployment Tools feature.

#### 2. Extract the Original WIM
- Mount the Windows Server 2022 ISO and locate the `install.wim` file, usually found in the `sources` folder.
- Copy `install.wim` to a working directory.

#### 3. Modify the WIM File (Optional)
- Use DISM to add or remove packages, drivers, or updates to the WIM file.
- Example command: `DISM /Mount-Wim /WimFile:<path-to-wim> /index:1 /MountDir:<mount-directory>`
- After modifications, unmount and commit changes: `DISM /Unmount-Wim /MountDir:<mount-directory> /Commit`

#### 4. Create an Answer File (Optional)
- Use Windows System Image Manager to create an unattended answer file (`autounattend.xml`).
- This file automates the installation process according to your preferences.

#### 5. Prepare the ISO Folders
- Create a new folder structure for your ISO, such as `C:\ISO-Files`.
- Inside this folder, replicate the structure of the original ISO, but replace the original `install.wim` with your modified version.
- If you created an answer file, place it in the root of the ISO file structure.

#### 6. Create the ISO
- Use `oscdimg` to create an ISO from your new folder structure.
- Example command: `oscdimg -m -u2 -b"C:\path-to-extracted-ISO\boot\etfsboot.com" "C:\ISO-Files" "C:\path-to-new-ISO\WindowsServer2022_Custom.iso"`

#### 7. Test the ISO
- It’s important to test your new ISO in a safe environment, like a virtual machine, to ensure that it installs correctly.

### Notes:
- Ensure your customizations comply with Microsoft’s licensing and customization guidelines.
- This process can be complex and may vary slightly depending on your specific requirements.
- The commands and steps might need adjustments based on your actual file paths and system configuration.

Creating a custom Windows Server ISO can be a powerful way to streamline deployments, especially in environments with specific configuration requirements. Always test thoroughly to ensure stability and functionality.