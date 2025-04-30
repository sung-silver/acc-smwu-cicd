#!/bin/bash

set -e

echo "▶️ 시스템 패키지 업데이트 중..."
sudo apt update -y

echo "▶️ Ruby 설치 중..."
sudo apt install -y ruby-full

echo "▶️ wget 설치 중..."
sudo apt install -y wget

echo "▶️ Java (Amazon Corretto 17) 설치 중..."
sudo apt install -y curl gnupg
curl -fsSL https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | sudo tee /etc/apt/sources.list.d/corretto.list
sudo apt update -y
sudo apt install -y java-17-amazon-corretto-jdk

echo "✅ Java 버전 확인:"
java -version

echo "▶️ Nginx 설치 중..."
sudo apt install -y nginx

echo "▶️ Nginx 서비스 활성화 및 시작..."
sudo systemctl enable nginx
sudo systemctl start nginx

echo "✅ Nginx 상태 확인:"
sudo systemctl status nginx

echo "▶️ CodeDeploy Agent 설치 파일 다운로드 중..."
cd /home/ubuntu
wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install

echo "▶️ 설치 파일 실행 권한 부여..."
chmod +x ./install

echo "▶️ CodeDeploy Agent 설치 중..."
sudo ./install auto > /tmp/codedeploy-install.log

echo "▶️ CodeDeploy Agent 상태 확인:"
sudo service codedeploy-agent status