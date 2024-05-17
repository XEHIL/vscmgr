# VS Code Manager
The VS Code Extensions Manager is a powerful tool designed to streamline the management of extensions in Visual Studio Code. It offers a systematic and efficient approach to installing, updating, and uninstalling extensions, ensuring that your development environment remains tailored to your needs with minimal effort.
## Dependencies
- Install [fzf](https://github.com/junegunn/fzf?tab=readme-ov-file#installation)
- and [VS Code](https://code.visualstudio.com/download) obviously ;-)

## Installation
**Clone**
```
git clone https://github.com/XEHIL/vscmgr.git ~/vscmgr
```
**Change Directory**
```
cd ~/vscmgr
```
**Make Executable**
```
chmod u+x vscmgr.sh
```
**Run**
```
./vscmgr.sh
```
*Add `alias` to run the, if needed.*

---
## Usage
```
------------------------------------------------------

CS Sahil (github.com/XEHIL)

------------------------------------------------------

Usage: ./vscmgr.sh [-b] OR [-i] OR [-d] OR [-l] OR [-u] OR [-x]

Options:
  -b: Go to Base Config
  -i: Install Extensions from Profiles Config
  -d: Delete Extensions from Profiles Config
  -l: List Installed Extensions
  -u: Update Installed Extensions
  -x: Uninstall All Extensions
```
### Flags

`-b`: Load the Base Config.
![Base Config](https://github.com/XEHIL/vscmgr/blob/main/images/base.jpg "Base Config")
`-i`: List and install extensions from .ext files in the profiles folder.
![Install Config](https://github.com/XEHIL/vscmgr/blob/main/images/install.jpg "Install Config")
![Installed](https://github.com/XEHIL/vscmgr/blob/main/images/installed.jpg "Installed")
`-d`: List and delete extensions from .ext files in the profiles folder.
![Delete Config](https://github.com/XEHIL/vscmgr/blob/main/images/delete.jpg "Delete Config")
![Deleted](https://github.com/XEHIL/vscmgr/blob/main/images/deleted.jpg "Deleted")
`-l`: List installed extensions.
![List Config](https://github.com/XEHIL/vscmgr/blob/main/images/list.jpg "List Config")
`-u`: Update installed extensions.
![Update](https://github.com/XEHIL/vscmgr/blob/main/images/update.jpg "Update Config")
`-x`: Delete all extensions from VS Code.
![Delete All](https://github.com/XEHIL/vscmgr/blob/main/images/delete_all.jpg "Delete All")

----
**What is a .ext File?**
It is a file containing a list of VS Code Extension IDs.
![Python .ext File](https://github.com/XEHIL/vscmgr/blob/main/images/extfile.jpg "Python .ext File")

---
**What is? `IGNORE_SETTINGS_KEYBINDINGS`**
- `IGNORE_SETTINGS_KEYBINDINGS` is set to 1 by default, this disables modification of the current `keybindings.json` and `settings.json` of VS Code.
- If `IGNORE_SETTINGS_KEYBINDINGS` is set to 0, the script will modify the  `settings.json` and `keybindings.json` to the VS Code Settings.

---
**What is? `CREATE_SYMLINKS`** (only works if `IGNORE_SETTINGS_KEYBINDINGS` is set to 0)
- `CREATE_SYMLINKS` is set to 0 by default, this copies the `vscmgr/keybindings.json` and `vscmgr/settings.json` to the VS Code Settings.
- If `CREATE_SYMLINKS` is set to 1, the script will create a symlink of `vscmgr/keybindings.json` and `vscmgr/settings.json` to the VS Code Settings.
