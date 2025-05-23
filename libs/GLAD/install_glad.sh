#!/bin/bash

# Variables
# Default version
DEFAULT_VERSION=3.3
# Use provided version or default
VERSION=${1:-$DEFAULT_VERSION}

# If version is 0, use default
if [ "$VERSION" = "0" ]; then
    VERSION=$DEFAULT_VERSION
    echo "Using default version: $VERSION"
fi

# Verify version format
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in format X.Y (e.g., 3.3)"
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

echo "Installing GLAD with OpenGL version: $VERSION and install prefix: $INSTALL_PREFIX"

# Get the parent directory of the script
PARENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install
python3 -m venv glad_env
source glad_env/bin/activate
pip install git+https://github.com/ValtoLibraries/GLAD.git
glad --generator c --out-path glad/ --api gl=$VERSION --extensions "" --profile core

# Install
SRC_DIR=$(pwd)/glad
if [ -d build ]; then
    read -p "Build directory already exists. Do you want to delete it? (y/n): " answer
    if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
        rm -rf build
    fi
fi
mkdir -p build
cd build

cmake $PARENT_DIR -DCMAKE_INSTALL_DATAROOTDIR=lib/cmake -DDIR=$SRC_DIR -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DGLAD_VERSION=$VERSION
cmake --build .
sudo cmake --install .

# Remove
cd ..
rm -rf glad_env
rm -rf build
rm -rf glad