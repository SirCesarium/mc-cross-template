$ErrorActionPreference = "Stop"

# --- Configuration ---
$RepoUrl = "https://github.com/SirCesarium/mc-cross-template/archive/refs/heads/main.zip"
$TmpZip = "template.zip"
$TmpDir = "mc-cross-template-main"

# --- Metadata Collection ---
$ArchName = Read-Host "Enter Project ID [my_mod]"
if ([string]::IsNullOrWhiteSpace($ArchName)) { $ArchName = "my_mod" }
if ($ArchName -notmatch "^[a-z0-9_]+$") { throw "Invalid ID format." }

$ModName = Read-Host "Enter Display Name [My Mod]"
if ([string]::IsNullOrWhiteSpace($ModName)) { $ModName = "My Mod" }
if ([string]::IsNullOrWhiteSpace($ModName)) { throw "Name cannot be empty." }

$ModVer = Read-Host "Enter Version [1.0.0]"
if ([string]::IsNullOrWhiteSpace($ModVer)) { $ModVer = "1.0.0" }
if ($ModVer -notmatch "^\d+\.\d+\.\d+$") { throw "Use SemVer format (x.y.z)." }

$ModAuth = Read-Host "Enter Author Name [Author]"
if ([string]::IsNullOrWhiteSpace($ModAuth)) { $ModAuth = "Author" }

$MavenGrp = Read-Host "Enter Maven Group [com.example]"
if ([string]::IsNullOrWhiteSpace($MavenGrp)) { $MavenGrp = "com.example" }
if ($MavenGrp -notmatch "^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)*$") { throw "Invalid Maven Group." }

# --- Execution ---
Write-Host "Downloading template..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $RepoUrl -OutFile $TmpZip

Write-Host "Extracting files..." -ForegroundColor Cyan
Expand-Archive -Path $TmpZip -DestinationPath "." -Force
Rename-Item -Path $TmpDir -NewName $ArchName
Set-Location $ArchName

Write-Host "Generating gradle.properties..." -ForegroundColor Cyan
$Content = @"
# --- Metadata ---
archives_name=$ArchName
mod_name=$ModName
mod_version=$ModVer
mod_author=$ModAuth
mod_description=A Minecraft mod created with mc-cross-template.
maven_group=$MavenGrp
minecraft_version=1.21.1

# --- Fabric ---
fabric_loader_version=0.16.9
fabric_api_version=0.102.0+1.21.1
yarn_mappings=1.21.1+build.3

# --- NeoForge ---
neoforge_version=21.1.219

# --- Paper ---
paper_version=1.21.1-R0.1-SNAPSHOT
paper_build=133

# --- System ---
org.gradle.jvmargs=-Xmx2G -XX:MaxMetaspaceSize=512m -XX:+UseParallelGC -XX:SoftRefLRUPolicyMSPerMB=50
org.gradle.parallel=true
org.gradle.configuration-cache=false
"@

$Content | Out-File -FilePath "gradle.properties" -Encoding utf8

$OrgPath = $MavenGrp.Replace('.', '/')
foreach ($platform in @("fabric", "neoforge", "paper")) {
    $SrcDir = "$platform/src/main/java"
    $OldPath = Join-Path $SrcDir "com/example"
    $NewPath = Join-Path $SrcDir $OrgPath
    
    if (Test-Path $OldPath) {
        New-Item -ItemType Directory -Force -Path $NewPath | Out-Null
        Copy-Item -Path "$OldPath\*" -Destination $NewPath -Recurse -Force
        Remove-Item -Path $OldPath -Recurse -Force
        
        Get-ChildItem -Path $NewPath -Filter "*.java" -Recurse | ForEach-Object {
            (Get-Content $_.FullName) -replace 'package com.example', "package $MavenGrp" | Set-Content $_.FullName
        }
    }
}

Remove-Item "..\\$TmpZip"

Write-Host "SUCCESS: Project '$ArchName' is ready in .\$ArchName" -ForegroundColor Green
