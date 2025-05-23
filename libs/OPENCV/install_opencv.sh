#!/bin/bash

# Install prerequisite
PARENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
$PARENT_DIR/install_opencv_prerequisite.sh

#variables
# Default version
DEFAULT_OPENCV_VERSION=4.9.0
# Use provided version or default
OPENCV_VERSION=${1:-$DEFAULT_OPENCV_VERSION}

# If version is 0, use default
if [ "$OPENCV_VERSION" = "0" ]; then
    OPENCV_VERSION=$DEFAULT_OPENCV_VERSION
    echo "Using default OpenCV version: $OPENCV_VERSION"
fi

# Verify OpenCV version format
if ! [[ $OPENCV_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: OpenCV version must be in format X.Y.Z (e.g., 4.9.0)"
    exit 1
fi

DEFAULT_CUDNN_VERSION=8.9.6
# Use provided version or default
CUDNN_VERSION=${2:-$DEFAULT_CUDNN_VERSION}

# If version is 0, use default
if [ "$CUDNN_VERSION" = "0" ]; then
    CUDNN_VERSION=$DEFAULT_CUDNN_VERSION
    echo "Using default CUDNN version: $CUDNN_VERSION"
fi

# Verify CUDNN version format
if ! [[ $CUDNN_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: CUDNN version must be in format X.Y.Z (e.g., 8.9.6)"
    exit 1
fi

DEFAULT_PYTHON_DIST_PACKAGE_PATH=/usr/local/lib/python3.8/dist-packages #check: python3 -m site
# Use provided version or default
PYTHON_DIST_PACKAGE_PATH=${3:-$DEFAULT_PYTHON_DIST_PACKAGE_PATH}

DEFAULT_CUDA_CC=8.9
# Use provided version or default
CUDA_CC=${4:-$DEFAULT_CUDA_CC}

# If version is 0, use default
if [ "$CUDA_CC" = "0" ]; then
    CUDA_CC=$DEFAULT_CUDA_CC
    echo "Using default CUDA compute capability: $CUDA_CC"
fi

# Verify CUDA CC format
if ! [[ $CUDA_CC =~ ^[0-9]+\.[0-9]+$ ]]; then
    echo "Error: CUDA compute capability must be in format X.Y (e.g., 8.9)"
    exit 1
fi

# Get the default CMake install prefix
DEFAULT_INSTALL_PREFIX=$(cmake -E capabilities | grep -o '"installPath":"[^"]*"' | awk -F '"' '{print $4}')
# If empty, fall back to /usr/local
if [ -z "$DEFAULT_INSTALL_PREFIX" ]; then
    DEFAULT_INSTALL_PREFIX="/usr/local"
fi
# Use provided install prefix or default
INSTALL_PREFIX=${5:-$DEFAULT_INSTALL_PREFIX}

echo "Installing OpenCV version: $OPENCV_VERSION with install prefix: $INSTALL_PREFIX"

#download
mkdir opencv-sources
cd opencv-sources
wget -O opencv.zip https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip
unzip opencv.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip
unzip opencv_contrib.zip
cd opencv-$OPENCV_VERSION

# Check if build directory exists
if [ -d build ]; then
    read -p "Build directory already exists. Do you want to delete it? (y/n): " answer
    if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
        rm -rf build
    fi
fi
mkdir -p build

cd build

#cmake
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -D INSTALL_PYTHON_EXAMPLES=ON -D INSTALL_C_EXAMPLES=ON -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D BUILD_PACKAGE=OFF -D BUILD_EXAMPLES=OFF -D WITH_TBB=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda -D WITH_CUDA=ON -D WITH_CUBLAS=ON -D WITH_CUFFT=ON -D WITH_NVCUVID=ON -D WITH_IPP=OFF -D WITH_V4L=ON -D WITH_1394=OFF -D WITH_GTK=ON -D WITH_QT=OFF -D WITH_OPENGL=ON -D WITH_EIGEN=ON -D WITH_FFMPEG=ON -D WITH_GSTREAMER=ON -D BUILD_JAVA=OFF -D BUILD_opencv_python3=ON -D BUILD_opencv_python2=OFF -D BUILD_NEW_PYTHON_SUPPORT=ON -D OPENCV_SKIP_PYTHON_LOADER=ON -D OPENCV_GENERATE_PKGCONFIG=ON -D OPENCV_ENABLE_NONFREE=ON -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-$OPENCV_VERSION/modules -D WITH_CUDNN=ON -D OPENCV_DNN_CUDA=ON -D CUDA_ARCH_BIN=$CUDA_CC  -D CUDA_ARCH_PTX=$CUDA_CC -D CUDNN_LIBRARY=/usr/local/cuda/lib64/libcudnn.so.$CUDNN_VERSION -D CUDNN_INCLUDE_DIR=/usr/local/cuda/include  -D PYTHON3_PACKAGES_PATH=$PYTHON_DIST_PACKAGE_PATH  -D BUILD_opencv_cudacodec=ON ..

#build
echo [entering make all]
time make -j$(nproc)
#time make -j8
echo [entering make install]
sudo make install

#ldconfig
sudo ldconfig

#remove
cd ../..
rm -rf opencv-sources
