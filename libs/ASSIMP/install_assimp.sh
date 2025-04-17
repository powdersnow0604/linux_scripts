# Prerequisite
#sudo apt install unzip

# Variables
version=5.4.3

# Download
wget -O assimp.zip https://github.com/assimp/assimp/archive/refs/tags/v$version.zip
unzip assimp.zip

# cmake
cd assimp-$version
mkdir build
cd build
cmake \
    -DBUILD_SHARED_LIBS=ON \
    -DASSIMP_BUILD_TESTS=OFF \
    -DCMAKE_INSTALL_DATAROOTDIR=lib/cmake \
    ..

#build
echo [entering make all]
#time make -j$(nproc)
time make -j8
echo [entering make install]
sudo make install

#remove
cd ../..
rm -rf assimp-$version
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