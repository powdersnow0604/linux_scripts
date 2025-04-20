#!/bin/bash

# Prerequisite
#sudo apt install unzip

# Variables
# Default version
DEFAULT_VERSION=3.12.0
# Use provided version or default
VERSION=${1:-$DEFAULT_VERSION}

echo "Installing JSON version: $VERSION"

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
    ..

#build
echo "[entering make all]"
#time make -j$(nproc)
time make -j8
echo "[entering make install]"
sudo make install

INSTALL_PREFIX=$(cmake -L .. | grep "CMAKE_INSTALL_PREFIX" | awk -F "=" '{print $2}')
sudo mv $INSTALL_PREFIX/include/nlohmann $INSTALL_PREFIX/include/json

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