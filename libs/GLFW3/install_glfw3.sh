#!/bin/bash

# Prerequisite
sudo apt -y install libwayland-dev libxkbcommon-dev xorg-dev
#sudo apt install unzip

# Variables
# Default version
DEFAULT_VERSION=3.4
# Use provided version or default
VERSION=${1:-$DEFAULT_VERSION}

# If version is 0, use default
if [ "$VERSION" = "0" ]; then
    VERSION=$DEFAULT_VERSION
    echo "Using default version: $VERSION"
fi

# Verify version format
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in format X.Y (e.g., 3.4)"
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

echo "Installing GLFW version: $VERSION with install prefix: $INSTALL_PREFIX"

# Download
wget -O glfw.zip https://github.com/glfw/glfw/archive/refs/tags/$VERSION.zip
unzip glfw.zip

# cmake
cd glfw-$VERSION

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
    -DGLFW_BUILD_EXAMPLES=OFF \
    -DGLFW_BUILD_TESTS=OFF \
    -DGLFW_BUILD_DOCS=OFF \
    -DCMAKE_INSTALL_DATAROOTDIR=lib/cmake \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
    ..

#build
echo [entering make all]
#time make -j$(nproc)
time make -j8
echo [entering make install]
sudo make install

#ldconfig
sudo ldconfig

#remove
cd ../..
rm -rf glfw-$VERSION
rm glfw.zip
rm -rf build


# Example of Installing
# -- Installing: /usr/local/lib/libglfw.so.3.4
# -- Installing: /usr/local/lib/libglfw.so.3
# -- Installing: /usr/local/lib/libglfw.so
# -- Installing: /usr/local/include/GLFW
# -- Installing: /usr/local/include/GLFW/glfw3.h
# -- Installing: /usr/local/include/GLFW/glfw3native.h
# -- Installing: /usr/local/lib/cmake/glfw3/glfw3Config.cmake
# -- Installing: /usr/local/lib/cmake/glfw3/glfw3ConfigVersion.cmake
# -- Installing: /usr/local/lib/cmake/glfw3/glfw3Targets.cmake
# -- Installing: /usr/local/lib/cmake/glfw3/glfw3Targets-noconfig.cmake
# -- Installing: /usr/local/lib/pkgconfig/glfw3.pc