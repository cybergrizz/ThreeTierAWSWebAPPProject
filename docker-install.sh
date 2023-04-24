#! /bin/bash
sudo su
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
docker build https://github.com/cybergrizz/ThreeTierAWSWebAPPProject