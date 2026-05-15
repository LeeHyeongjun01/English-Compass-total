#!/bin/bash
# EC2 초기 설정 스크립트 (Ubuntu 22.04 기준)
# 사용법: bash setup.sh [ec2-role]
# ec2-role: api-gateway | problem | user-speech | learning-media | infra

set -e

EC2_ROLE=${1:-"unknown"}
echo "=== English Compass EC2 Setup: $EC2_ROLE ==="

# 1. 시스템 업데이트
sudo apt-get update -y
sudo apt-get upgrade -y

# 2. Docker 설치
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 3. ubuntu 유저를 docker 그룹에 추가
sudo usermod -aG docker ubuntu

# 4. 앱 디렉토리 생성
mkdir -p ~/app

# 5. 역할별 docker-compose.yml 복사 안내
echo ""
echo "=== 다음 단계 ==="
echo "1. ~/app/ 에 아래 파일을 업로드하세요:"
case $EC2_ROLE in
  "api-gateway")
    echo "   - deploy/ec2-api-gateway/docker-compose.yml"
    ;;
  "problem")
    echo "   - deploy/ec2-problem/docker-compose.yml"
    ;;
  "user-speech")
    echo "   - deploy/ec2-user-speech/docker-compose.yml"
    ;;
  "learning-media")
    echo "   - deploy/ec2-learning-media/docker-compose.yml"
    ;;
  "infra")
    echo "   - deploy/infra/docker-compose.yml"
    echo "   - deploy/infra/init/ (MySQL 초기화 SQL)"
    ;;
esac
echo ""
echo "2. ~/app/.env 파일을 생성하고 환경변수를 설정하세요"
echo "   (deploy/env.example 참고)"
echo ""
echo "3. newgrp docker 또는 재로그인 후 Docker 사용 가능"
echo ""
echo "=== 설정 완료 ==="
