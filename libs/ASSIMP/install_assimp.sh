#!/bin/bash

# Prerequisite
#sudo apt install unzip

# Variables
# Default version
DEFAULT_VERSION=5.4.3
# Use provided version or default
VERSION=${1:-$DEFAULT_VERSION}

# If version is 0, use default
if [ "$VERSION" = "0" ]; then
    VERSION=$DEFAULT_VERSION
    echo "Using default version: $VERSION"
fi

# Verify version format
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in format X.Y.Z (e.g., 5.4.3)"
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

echo "Installing ASSIMP version: $VERSION with install prefix: $INSTALL_PREFIX"

# Download
wget -O assimp.zip https://github.com/assimp/assimp/archive/refs/tags/v$VERSION.zip
unzip assimp.zip

# cmake
cd assimp-$VERSION

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
    -DBUILD_SHARED_LIBS=ON \
    -DASSIMP_BUILD_TESTS=OFF \
    -DCMAKE_INSTALL_DATAROOTDIR=lib/cmake \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
    ..

#build
echo [entering make all]
#time make -j$(nproc)
time make -j8
echo [entering make install]
sudo make install

#remove
cd ../..
rm -rf assimp-$VERSION
rm assimp.zip


# Example of Installing
# -- Installing: /usr/local/lib/cmake/assimp-5.4/assimpConfig.cmake
# -- Installing: /usr/local/lib/cmake/assimp-5.4/assimpConfigVersion.cmake
# -- Installing: /usr/local/lib/cmake/assimp-5.4/assimpTargets.cmake
# -- Installing: /usr/local/lib/cmake/assimp-5.4/assimpTargets-noconfig.cmake
# -- Installing: /usr/local/lib/libassimp.so.5.4.3
# -- Installing: /usr/local/lib/libassimp.so.5
# -- Installing: /usr/local/lib/libassimp.so
# -- Installing: /usr/local/include/assimp/anim.h
# -- Installing: /usr/local/lib/pkgconfig/assimp.pc