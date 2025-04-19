mkdir build
cd build
cmake .. -DCMAKE_INSTALL_DATAROOTDIR=lib/cmake
cmake --build .
sudo cmake --install .
