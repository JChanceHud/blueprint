#!/bin/sh

SSH_AUTHORIZED_KEYS="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzdwD5nG+og435muHDSXpRKxtjyeegxppl13FKijulK4Emq+svRq3He1m6+GjiMIogLQGZglzfoDI771Lk0m35yYr2qFdvzvwc3/uw/N0Pf0GuGDnE96smlrxLDZ6NW6Dx0nGyS7K9EhRwkfq3J5blizylu+O9GcYifsZ48vsOdpF/r2tqUfR0TlVH8JHgcENyK8oGzNjZj+PQEum208evI1M51UxGoCPrqN4wIy193Ffbu18arKdcWW4+zZGz7zZYJrrgaHrbMC9mYTyBrarfQdpjj+eEDH+WAMOq/u5d+CUXsn/HiTQY1geE+8YmOrj24wUK61XE+n5oR4G0AIAR mb1"

set -e

[ -z $1 ] && echo "Specify username as first argument" && exit 1

sudo adduser --shell /bin/bash --disabled-password $1
echo "\n$SSH_AUTHORIZED_KEYS" >> /home/$1/.ssh/authorized_keys

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=armhf] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermode -aG docker $1

echo "Creating swapfile"
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
