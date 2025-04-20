#!/bin/bash

# Prerequisite
#sudo apt install unzip

# Variables
# Default version
DEFAULT_VERSION=3.2.0
# Use provided version or default
VERSION=${1:-$DEFAULT_VERSION}

# Verify version format
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in format X.Y.Z (e.g., 3.2.0)"
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

echo "Installing cxxopts version: $VERSION with install prefix: $INSTALL_PREFIX"

# Download
wget -O cxxopts.zip https://github.com/jarro2783/cxxopts/archive/refs/tags/v$VERSION.zip
unzip cxxopts.zip

# cmake
cd cxxopts-$VERSION

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
    -DCMAKE_INSTALL_DATAROOTDIR=lib/cmake \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
    ..

#build
echo "[entering make all]"
#time make -j$(nproc)
time make -j8
echo "[entering make install]"
sudo make install

#remove
cd ../..
rm -rf cxxopts-$VERSION
rm cxxopts.zip


# Example of Installing
# -- Installing: /usr/local/lib/cmake/cxxopts/cxxopts-config.cmake
# -- Installing: /usr/local/lib/cmake/cxxopts/cxxopts-config-version.cmake
# -- Installing: /usr/local/lib/cmake/cxxopts/cxxopts-targets.cmake
# -- Installing: /usr/local/include/cxxopts.hpp
# -- Installing: /usr/local/lib/pkgconfig/cxxopts.pc