# Minecraft Cross Backend Mod/Plugin Template

A robust, multi-loader template for developing Minecraft mods and plugins across **Fabric**, **NeoForge**, and **Paper (Bukkit)** using a shared **Core** module to minimize code duplication.

## Getting Started

### 1. Initialize the Project

You can quickly set up your project using the automated installers. These scripts will prompt you for project metadata (Name, ID, Version, Group) and refactor the package structure automatically.

#### Unix-based (Linux, macOS, WSL)

Run the following command in your terminal:

```bash
curl -sSL https://raw.githubusercontent.com/SirCesarium/mc-cross-template/installer/setup.sh -o setup.sh && bash setup.sh; rm -f setup.sh
```

#### Windows (PowerShell)

Run the following command in PowerShell:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/SirCesarium/mc-cross-template/installer/setup.ps1'))
```

### 2. Manual Setup

Alternatively, you can:

- Click the **"Use this template"** button on GitHub to create a new repository.
- Clone the repository manually: `git clone https://github.com/SirCesarium/mc-cross-template.git`

## Project Structure

- `core/`: Contains the common logic, API wrappers, and shared code.
- `fabric/`: Fabric-specific implementation and resources.
- `neoforge/`: NeoForge-specific implementation and resources.
- `paper/`: Paper/Bukkit-specific implementation and resources.

## Building and Distribution

The project includes a custom task to build all platforms and collect the artifacts in a single directory.

To build all JARs, run:

```bash
./gradlew buildAll
```

The resulting files will be located in the `dist/` folder with the following naming convention:
`ARCHIVES_NAME-VERSION-LOADER.jar`

## Configuration

Metadata such as versions and dependencies are managed in `gradle.properties`.

```properties
archives_name=my_mod
mod_name=MyMod
mod_version=1.0.0
maven_group=com.example
minecraft_version=1.21.1
```
