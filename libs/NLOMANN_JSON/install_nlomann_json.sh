#!/bin/bash

# Prerequisite
#sudo apt install unzip

# Variables
# Default version
DEFAULT_VERSION=3.12.0
# Use provided version or default
VERSION=${1:-$DEFAULT_VERSION}

# If version is 0, use default
if [ "$VERSION" = "0" ]; then
    VERSION=$DEFAULT_VERSION
    echo "Using default version: $VERSION"
fi

# Verify version format
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in format X.Y.Z (e.g., 3.12.0)"
    exit 1
fi

# Get the default CMake install prefix
DEFAULT_INSTALL_PREFIX=$(cmake -E capabilities | grep -o '"installPath":"[^"]*"' | awk -F '"' '{print $4}')
# If empty, fall back to /usr/local
if [ -z "$DEFAULT_INSTALL_PREFIX" ]; then
    DEFAULT_INSTALL_PREFIX="/usr/local"
fi
# Use provided install prefix or default
INSTALL_PREFIX=${2:-$DEFAULT_INSTALL_PREFIX}

echo "Installing JSON version: $VERSION with install prefix: $INSTALL_PREFIX"

# Download
wget -O json.zip https://github.com/nlohmann/json/archive/refs/tags/v$VERSION.zip
unzip json.zip

# cmake
cd json-$VERSION

# Check if build directory exists
if [ -d build ]; then
    read -p "Build directory already exists. Do you want to delete it? (y/n): " answer
    if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
        rm -rf build
    fi
fi
mkdir -p build

cd build
cmake \
    -DCMAKE_INSTALL_DATAROOTDIR=lib \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
    ..

#build
echo "[entering make all]"
#time make -j$(nproc)
time make -j8
echo "[entering make install]"
sudo make install

# Get the actual install prefix used by CMake
CMAKE_USED_PREFIX=$(cmake -L .. | grep "CMAKE_INSTALL_PREFIX" | awk -F "=" '{print $2}' | xargs)
sudo mv $CMAKE_USED_PREFIX/include/nlohmann $CMAKE_USED_PREFIX/include/json

#remove
cd ../..
rm -rf json-$VERSION
rm json.zip
rm -rf build

# Example of Installing
#-- Installing: /usr/local/include/nlohmann ## however, it should be /usr/local/include/json
#-- Installing: /usr/local/lib/cmake/nlohmann_json/nlohmann_jsonConfig.cmake
#-- Installing: /usr/local/lib/cmake/nlohmann_json/nlohmann_jsonConfigVersion.cmake
#-- Installing: /usr/local/lib/cmake/nlohmann_json/nlohmann_jsonTargets.cmake
#-- Installing: /usr/local/lib/pkgconfig/nlohmann_json.pc