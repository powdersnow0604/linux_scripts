# Prerequisite
#sudo apt install unzip

# Variables
version=3.2.0

# Download
wget -O cxxopts.zip https://github.com/jarro2783/cxxopts/archive/refs/tags/v$version.zip
unzip cxxopts.zip

# cmake
cd cxxopts-$version
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
rm -rf cxxopts-$version
rm cxxopts.zip


# Example of Installing
# -- Installing: /usr/local/lib/cmake/cxxopts/cxxopts-config.cmake
# -- Installing: /usr/local/lib/cmake/cxxopts/cxxopts-config-version.cmake
# -- Installing: /usr/local/lib/cmake/cxxopts/cxxopts-targets.cmake
# -- Installing: /usr/local/include/cxxopts.hpp
# -- Installing: /usr/local/lib/pkgconfig/cxxopts.pc