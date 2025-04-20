#!/bin/bash
# Check if glad is installed
if pkg-config --exists glad; then
    echo "glad is already installed."
    exit 1
fi

# Variables
# Default version
DEFAULT_VERSION=3.3
# Use provided version or default
VERSION=${1:-$DEFAULT_VERSION}

echo "Installing GLAD with OpenGL version: $VERSION"

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
    rm -rf build
fi
mkdir -p build
cd build

cmake $PARENT_DIR -DCMAKE_INSTALL_DATAROOTDIR=lib/cmake -DDIR=$SRC_DIR
cmake --build .
sudo cmake --install .

# Remove
cd ..
rm -rf glad_env
rm -rf build
rm -rf glad