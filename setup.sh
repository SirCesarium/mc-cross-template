#!/bin/bash
set -e

# --- Configuration ---
REPO_URL="https://github.com/SirCesarium/mc-cross-template/archive/refs/heads/main.zip"
TMP_ZIP="template.zip"
TMP_DIR="mc-cross-template-main"

# --- Functions ---
die() {
  echo "ERROR: $1" >&2
  exit 1
}

# --- Metadata Collection ---
read -p "Enter Project ID (lowercase, no spaces, e.g. my_cool_mod): " ARCH_NAME
[[ $ARCH_NAME =~ ^[a-z0-9_]+$ ]] || die "Invalid ID format."

read -p "Enter Display Name (e.g. My Mod): " MOD_NAME
[[ -n "$MOD_NAME" ]] || die "Name cannot be empty."

read -p "Enter Version (e.g. 1.0.0): " MOD_VER
[[ $MOD_VER =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "Use SemVer format (x.y.z)."

read -p "Enter Author Name: " MOD_AUTH
read -p "Enter Maven Group (e.g. com.example): " MAVEN_GRP
[[ $MAVEN_GRP =~ ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)*$ ]] || die "Invalid Maven Group."

# --- Execution ---
echo "Downloading template..."
curl -sSL "$REPO_URL" -o "$TMP_ZIP"

echo "Extracting files..."
unzip -q "$TMP_ZIP"
mv "$TMP_DIR" "$ARCH_NAME"
cd "$ARCH_NAME"

echo "Generating gradle.properties..."
cat <<EOF >gradle.properties
# --- Metadata ---
archives_name=$ARCH_NAME
mod_name=$MOD_NAME
mod_version=$MOD_VER
mod_author=$MOD_AUTH
mod_description=A Minecraft mod created with mc-cross-template.
maven_group=$MAVEN_GRP
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
EOF

rm "../$TMP_ZIP"
echo "SUCCESS: Project '$ARCH_NAME' is ready in ./$ARCH_NAME"
