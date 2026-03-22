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
read -p "Enter Project ID [my_mod]: " ARCH_NAME </dev/tty
ARCH_NAME=${ARCH_NAME:-my_mod}
[[ $ARCH_NAME =~ ^[a-z0-9_]+$ ]] || die "Invalid ID format."

read -p "Enter Display Name [My Mod]: " MOD_NAME </dev/tty
MOD_NAME=${MOD_NAME:-My Mod}
[[ -n "$MOD_NAME" ]] || die "Name cannot be empty."

read -p "Enter Version [1.0.0]: " MOD_VER </dev/tty
MOD_VER=${MOD_VER:-1.0.0}
[[ $MOD_VER =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "Use SemVer format (x.y.z)."

read -p "Enter Author Name [Author]: " MOD_AUTH </dev/tty
MOD_AUTH=${MOD_AUTH:-Author}

read -p "Enter Maven Group [com.example]: " MAVEN_GRP </dev/tty
MAVEN_GRP=${MAVEN_GRP:-com.example}
[[ $MAVEN_GRP =~ ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)*$ ]] || die "Invalid Maven Group."

# --- Execution ---
echo "Downloading template..."
curl -sSL "$REPO_URL" -o "$TMP_ZIP"

echo "Extracting files..."
unzip -o -q "$TMP_ZIP"

if [ -d "$ARCH_NAME" ]; then
  rm -rf "$TMP_DIR"
  rm "$TMP_ZIP"
  die "Directory '$ARCH_NAME' already exists. Aborting to avoid overwrite."
fi

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

sed -i "s/rootProject.name = 'mc-cross-template'/rootProject.name = '$ARCH_NAME'/g" settings.gradle

ORG_PATH=$(echo $MAVEN_GRP | tr '.' '/')
for platform in core fabric neoforge paper; do
  SRC_DIR="$platform/src/main/java"
  OLD_PATH="$SRC_DIR/com/example"
  NEW_PATH="$SRC_DIR/$ORG_PATH"

  mkdir -p "$NEW_PATH"
  cp -r "$OLD_PATH/"* "$NEW_PATH/"
  rm -rf "$OLD_PATH"

  find "$NEW_PATH" -name "*.java" -exec sed -i "s/package com.example/package $MAVEN_GRP/g" {} +
done

rm "../$TMP_ZIP"
echo "------------------------------------------------"
echo "SUCCESS: Project '$ARCH_NAME' is ready in ./$ARCH_NAME"
echo "Next steps: cd $ARCH_NAME && ./gradlew build"
