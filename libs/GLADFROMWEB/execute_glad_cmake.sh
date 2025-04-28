#!/bin/bash

# Default version
DEFAULT_VERSION="0.1.0"
# Use provided version or default
VERSION=${1:-$DEFAULT_VERSION}

# Get the default CMake install prefix
DEFAULT_INSTALL_PREFIX=$(cmake -E capabilities | grep -o '"installPath":"[^"]*"' | awk -F '"' '{print $4}')
# If empty, fall back to /usr/local
if [ -z "$DEFAULT_INSTALL_PREFIX" ]; then
    DEFAULT_INSTALL_PREFIX="/usr/local"
fi
# Use provided install prefix or default
INSTALL_PREFIX=${2:-$DEFAULT_INSTALL_PREFIX}

echo "Installing with OpenGL version: $VERSION and install prefix: $INSTALL_PREFIX"

# Check if build directory exists
if [ -d build ]; then
    read -p "Build directory already exists. Do you want to delete it? (y/n): " answer
    if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
        rm -rf build
    fi
fi
mkdir -p build

cd build
cmake .. -DCMAKE_INSTALL_DATAROOTDIR=lib/cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DGLAD_VERSION=$VERSION
cmake --build .
sudo cmake --install .
