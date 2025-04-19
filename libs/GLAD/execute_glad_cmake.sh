mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_DATAROOTDIR=lib/cmake
cmake --build .
sudo cmake --install .

# Wrting pkg-config file
PREFIX="/usr/local"
EXEC_PREFIX="${PREFIX}"
LIBDIR="${PREFIX}/lib"
INCLUDEDIR="${PREFIX}/include"

PKG_CONFIG_CONTENT="prefix=${PREFIX}
exec_prefix=${EXEC_PREFIX}
libdir=${LIBDIR}
includedir=${INCLUDEDIR}

Name: glad
Description: Multi-Language GL/GLES/EGL/GLX/WGL Loader-Generator based on the official specs
Version: $version
Libs: -L${LIBDIR} -lglad
Cflags: -I${INCLUDEDIR}
"

OUTPUT_FILE="$LIBDIR/pkgconfig/glad.pc"
if [ ! -f "$OUTPUT_FILE" ]; then
        echo "Create $OUTPUT_FILE"
        sudo touch $OUTPUT_FILE
        sudo chmod +w $OUTPUT_FILE
fi
# sudo echo "$PKG_CONFIG_CONTENT" > "$OUTPUT_FILE"
echo "$PKG_CONFIG_CONTENT" | sudo tee "$OUTPUT_FILE" > /dev/null
