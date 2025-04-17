
download_url=https://developer.nvidia.com/downloads/compute/cudnn/secure/8.9.6/local_installers/11.x/cudnn-linux-x86_64-8.9.6.50_cuda11-archive.tar.xz/

download_dirname="cudnn-archive"
download_filename="$download_dirname.tar.xz"

wget -O $download_filename $download_url

tar -xvf $download_filename

cd $download_dirname

sudo cp include/cudnn*.h /usr/local/cuda/include
sudo cp -P lib/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

rm -rf cudnn-*

/usr/local/cuda-11.8/extras/demo_suite/deviceQuery
