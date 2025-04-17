# Prerequisite
#sudo apt install unzip

# Variables
version=1.0.1

# Download
wget -O glm.zip https://github.com/g-truc/glm/archive/refs/tags/$version.zip
unzip glm.zip

# cmake
cd glm-$version
cmake \
    -DGLM_BUILD_TESTS=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_INSTALL_DATAROOTDIR=lib/cmake \
    -B build .
cmake --build build -- all
sudo cmake --build build -- install

#remove
cd ..
rm -rf glm-$version
rm glm.zip

# Wrting pkg-config file
PREFIX="/usr/local"
EXEC_PREFIX="${PREFIX}"
LIBDIR="${PREFIX}/lib"
INCLUDEDIR="${PREFIX}/include"

PKG_CONFIG_CONTENT="prefix=${PREFIX}
exec_prefix=${EXEC_PREFIX}
libdir=${LIBDIR}
includedir=${INCLUDEDIR}

Name: glm
Description: OpenGL Mathematics (GLM)
Version: $version
Libs: -L${LIBDIR} -lmylibrary
Cflags: -I${INCLUDEDIR}
"

OUTPUT_FILE="$LIBDIR/pkgconfig/glm.pc"
sudo echo "$PKG_CONFIG_CONTENT" > "$OUTPUT_FILE"


# Example of Installing
# -- Installing: /usr/local/lib/libglm.so
# -- Installing: /usr/local/include/glm
# -- Installing: /usr/local/lib/cmake/glm/glmConfig.cmake
# -- Installing: /usr/local/lib/cmake/glm/glmConfig-noconfig.cmake
# -- Installing: /usr/local/lib/cmake/glm/glmConfigVersion.cmake