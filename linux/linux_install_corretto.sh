#!/bin/bash


sudo amazon-linux-extras enable corretto8
sudo yum -y install java-1.8.0-amazon-corretto
sudo yum -y install java-1.8.0-amazon-corretto-devel
sudo alternatives --config java
sudo alternatives --config javac
