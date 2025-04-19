# Prerequisite
#sudo apt install unzip

# Variables
# Default version
DEFAULT_VERSION=3.2.0
# Use provided version or default
VERSION=${1:-$DEFAULT_VERSION}

echo "Installing cxxopts version: $VERSION"

# Download
wget -O cxxopts.zip https://github.com/jarro2783/cxxopts/archive/refs/tags/v$VERSION.zip
unzip cxxopts.zip

# cmake
cd cxxopts-$VERSION
mkdir build
cd build
cmake \
    -DCMAKE_INSTALL_DATAROOTDIR=lib/cmake \
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