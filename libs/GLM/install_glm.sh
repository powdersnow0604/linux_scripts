# Prerequisite
#sudo apt install unzip

# Variables
# Default version
DEFAULT_VERSION=1.0.1
# Use provided version or default
VERSION=${1:-$DEFAULT_VERSION}

echo "Installing GLM version: $VERSION"

# Download
wget -O glm.zip https://github.com/g-truc/glm/archive/refs/tags/$VERSION.zip
unzip glm.zip

# cmake
cd glm-$VERSION
cmake \
    -DGLM_BUILD_TESTS=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_INSTALL_DATAROOTDIR=lib/cmake \
    -B build .
cmake --build build -- all
sudo cmake --build build -- install

#remove
cd ..
rm -rf glm-$VERSION
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
Version: $VERSION
Libs: -L${LIBDIR} -lglm
Cflags: -I${INCLUDEDIR}
"

OUTPUT_FILE="$LIBDIR/pkgconfig/glm.pc"
if [ ! -f "$OUTPUT_FILE" ]; then
        echo "Create $OUTPUT_FILE"
        sudo touch $OUTPUT_FILE
        sudo chmod +w $OUTPUT_FILE
fi
# sudo echo "$PKG_CONFIG_CONTENT" > "$OUTPUT_FILE"
echo "$PKG_CONFIG_CONTENT" | sudo tee "$OUTPUT_FILE" > /dev/null


# Example of Installing
# -- Installing: /usr/local/lib/libglm.so
# -- Installing: /usr/local/include/glm
# -- Installing: /usr/local/lib/cmake/glm/glmConfig.cmake
# -- Installing: /usr/local/lib/cmake/glm/glmConfig-noconfig.cmake
# -- Installing: /usr/local/lib/cmake/glm/glmConfigVersion.cmake