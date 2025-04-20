# Prerequisite
sudo apt -y install libwayland-dev libxkbcommon-dev xorg-dev
#sudo apt install unzip

# Variables
# Default version
DEFAULT_VERSION=3.4
# Use provided version or default
VERSION=${1:-$DEFAULT_VERSION}

echo "Installing GLFW version: $VERSION"

# Download
wget -O glfw.zip https://github.com/glfw/glfw/archive/refs/tags/$VERSION.zip
unzip glfw.zip

# cmake
cd glfw-$VERSION
mkdir build
cd build
cmake \
    -DBUILD_SHARED_LIBS=ON \
    -DGLFW_BUILD_EXAMPLES=OFF \
    -DGLFW_BUILD_TESTS=OFF \
    -DGLFW_BUILD_DOCS=OFF \
    -DCMAKE_INSTALL_DATAROOTDIR=lib/cmake \
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