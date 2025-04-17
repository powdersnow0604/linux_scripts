#variables
opencv_version=4.9.0
cudnn_version=8.9.6
python_dist_package_path=/usr/local/lib/python3.8/dist-packages #check: python3 -m site
cuda_cc=8.9 #device compute capability ex) nvidia geforce rtx 4090 compute capability

#download
mkdir opencv-sources
cd opencv-sources
wget -O opencv.zip https://github.com/opencv/opencv/archive/$opencv_version.zip
unzip opencv.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/$opencv_version.zip
unzip opencv_contrib.zip
cd opencv-$opencv_version
mkdir build
cd build

#cmake
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_PYTHON_EXAMPLES=ON -D INSTALL_C_EXAMPLES=ON -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D BUILD_PACKAGE=OFF -D BUILD_EXAMPLES=OFF -D WITH_TBB=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda -D WITH_CUDA=ON -D WITH_CUBLAS=ON -D WITH_CUFFT=ON -D WITH_NVCUVID=ON -D WITH_IPP=OFF -D WITH_V4L=ON -D WITH_1394=OFF -D WITH_GTK=ON -D WITH_QT=OFF -D WITH_OPENGL=ON -D WITH_EIGEN=ON -D WITH_FFMPEG=ON -D WITH_GSTREAMER=ON -D BUILD_JAVA=OFF -D BUILD_opencv_python3=ON -D BUILD_opencv_python2=OFF -D BUILD_NEW_PYTHON_SUPPORT=ON -D OPENCV_SKIP_PYTHON_LOADER=ON -D OPENCV_GENERATE_PKGCONFIG=ON -D OPENCV_ENABLE_NONFREE=ON -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-$opencv_version/modules -D WITH_CUDNN=ON -D OPENCV_DNN_CUDA=ON -D CUDA_ARCH_BIN=$cuda_cc  -D CUDA_ARCH_PTX=$cuda_cc -D CUDNN_LIBRARY=/usr/local/cuda/lib64/libcudnn.so.$cudnn_version -D CUDNN_INCLUDE_DIR=/usr/local/cuda/include  -D PYTHON3_PACKAGES_PATH=$python_dist_package_path  -D BUILD_opencv_cudacodec=ON ..

#build
echo [entering make all]
#time make -j$(nproc)
time make -j8
echo [entering make install]
sudo make install

#ldconfig
sudo ldconfig

#remove
rm -rf opencv-source
