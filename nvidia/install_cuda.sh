#delete old GPG Key
sudo apt-key del 7fa2af80

#download cooda toolkit
 #newest version
 #wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb
 #sudo dpkg -i cuda-keyring_1.1-1_all.deb
 #sudo apt-get update
 #sudo apt-get -y install cuda
#cuda 11.8
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-wsl-ubuntu-11-8-local_11.8.0-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-11-8-local_11.8.0-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda


#download nvidia-utils
apt-cache search nvidia-utils-

echo intall utils: sudo apt install nvidia-utils-535

echo please export /usr/local/cuda-*/lib64/
