SHELL=/bin/bash

all:
	sudo mv /etc/apt/apt.conf.d/99dnanexus /tmp
	sudo mv /etc/apt/sources.list.d/nucleus.list /tmp
	sudo chown root:root /tmp
	sudo chmod 1777 /tmp
	sudo apt-get install -q -y gnupg
	sudo apt-get update
	#sudo apt-get install -q -y gnupg
	wget -q http://us.download.nvidia.com/tesla/384.81/nvidia-diag-driver-local-repo-ubuntu1604-384.81_1.0-1_amd64.deb
	sudo dpkg -i nvidia-diag-driver-local-repo-ubuntu1604-384.81_1.0-1_amd64.deb
	sudo apt-key add /var/nvidia-diag-driver-local-repo-384.81/7fa2af80.pub
	sudo apt-get update
	wget -q https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb
	mv cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64.deb
	sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
	sudo apt-get update
	sudo apt-get -y -q --allow-unauthenticated install cuda-9-0
	sudo bash /home/dnanexus/build_ac2_tf.sh
	
