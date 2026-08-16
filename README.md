# lyma-docker Installer

This repository contains the bootstrap scripts for `lyma-docker`. 

The installer downloads the latest stable release directly from the internal Nexus raw repository. Because the binary assets are private, you will be prompted for your Nexus credentials during installation.

**Important:** This installer extracts the files into a `lyma-docker` folder in your **current working directory**. It does not modify your system PATH. 

## Prerequisites

1. An active account on the company Nexus server (`repo.lymagroups.ir`).
2. A Nexus User Token (generate this in the Nexus UI under your user profile -> User Token).

## Installation

Navigate to the directory where you want the `lyma-docker` files to live, then run the command below.

### Windows (PowerShell)
Open PowerShell and run:

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
3. It downloads the versioned zip archive and extracts the files directly into a folder named `lyma-docker` in your current directory.
4. It cleans up the temporary downloaded zip files.
5. It leaves your system PATH completely untouched.

## Updating

To update to the newest release, simply run the installation command again from the same directory. The installer will automatically download the new version and overwrite the existing `lyma-docker` folder.
