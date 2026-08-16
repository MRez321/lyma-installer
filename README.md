# lyma-docker Installer

This repository contains the bootstrap scripts for `lyma-docker`. 

The installer downloads the latest stable release directly from the internal Nexus raw repository. Because the binary assets are private, you will be prompted for your Nexus credentials during installation.

## Prerequisites

1. An active account on the company Nexus server (`repo.lymagroups.ir`).
2. A Nexus User Token (generate this in the Nexus UI under your user profile -> User Token).

## Installation

### Windows (PowerShell)
Open PowerShell and run the following command. This temporarily bypasses the execution policy for the current session to allow the script to run without requiring Administrator privileges:

~~~powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; irm https://raw.githubusercontent.com/MRez321/lyma-installer/main/install.ps1 | iex
~~~

### Linux / macOS
Open your terminal and run:

~~~bash
curl -fsSL https://raw.githubusercontent.com/MRez321/lyma-installer/main/install.sh | bash
~~~

## What happens during installation?

1. You will be prompted to enter your Nexus username and User Token.
2. The script fetches the latest version number from Nexus (`latest.txt`).
3. It downloads the versioned zip archive and extracts it into:
   - Windows: `%LOCALAPPDATA%\lyma\<version>`
   - Linux/Mac: `~/.lyma/<version>`
4. It creates a persistent shortcut (symlink/junction) named `lyma-docker` that always points to the active version.
5. It adds the `lyma-docker` folder to your system `PATH`.

## Updating

To update to the newest release, simply run the installation command again. The installer will automatically download the new version, extract it, and update the `lyma-docker` shortcut. Old versions are kept on disk to allow for manual rollbacks if needed.
