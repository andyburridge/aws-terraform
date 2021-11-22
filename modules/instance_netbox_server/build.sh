#!/bin/bash
sleep 30
sudo apt update -y
sudo apt install docker -y
sudo apt install docker-compose -y
cd /opt
sudo git clone -b release https://github.com/netbox-community/netbox-docker.git
cd netbox-docker
sudo bash -c 'echo version: \"3.4\" >> docker-compose.override.yml'
sudo bash -c 'echo services: >> docker-compose.override.yml'
sudo bash -c 'echo \ \ netbox:  >> docker-compose.override.yml'
sudo bash -c 'echo \ \ \ \ ports:  >> docker-compose.override.yml'
sudo bash -c 'echo \ \ \ \ - 8000:8080  >> docker-compose.override.yml'
sudo docker-compose pull
sudo docker-compose up