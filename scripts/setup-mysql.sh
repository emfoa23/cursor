#!/bin/bash

# MySQL Docker 컨테이너 설정 스크립트
echo ""
echo "🐬 MySQL Docker 컨테이너 설정"
echo "================================"

# 사용자 입력 받기
echo ""
read -p "MySQL Root 비밀번호를 입력하세요: " MYSQL_ROOT_PASSWORD
read -p "생성할 데이터베이스 이름을 입력하세요: " MYSQL_DATABASE

echo ""
echo "📋 설정 정보:"
echo "  - Root 비밀번호: $MYSQL_ROOT_PASSWORD"
echo "  - 데이터베이스: $MYSQL_DATABASE"

# 기존 컨테이너 확인 및 제거
if docker ps -a --format "table {{.Names}}" | grep -q "mysql-container"; then
    echo ""
    echo "⚠️  기존 MySQL 컨테이너를 제거합니다..."
    docker stop mysql-container 2>/dev/null
    docker rm mysql-container 2>/dev/null
fi

# MySQL 컨테이너 실행
echo ""
echo "🚀 MySQL 컨테이너를 시작합니다..."
docker run -d \
    --name mysql-container \
    -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
    -e MYSQL_DATABASE="$MYSQL_DATABASE" \
    -p 3306:3306 \
    mysql:latest

# 컨테이너 시작 대기
echo ""
echo "⏳ MySQL이 시작될 때까지 기다리는 중..."
sleep 30

# 연결 테스트 및 데이터베이스 검증
echo ""
echo "🔍 연결 테스트 중..."

echo ""
if docker exec mysql-container mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 'MySQL Connection Test' as message;" 2>/dev/null; then
    echo ""
    echo "✅ MySQL 연결 성공!"
else
    echo ""
    echo "❌ MySQL 연결 실패. 로그를 확인해주세요."
    docker logs mysql-container
    exit 1
fi

# 데이터베이스 테이블 생성, 데이터 삽입, 조회 테스트
echo ""
echo "🔍 데이터 저장 테스트 중..."
docker exec mysql-container mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "USE $MYSQL_DATABASE; CREATE TABLE IF NOT EXISTS test (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP); INSERT INTO test (name) VALUES ('MySQL Connection Test');" 2>/dev/null
docker exec mysql-container mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "USE $MYSQL_DATABASE; SELECT * FROM test WHERE name='MySQL Connection Test';" 2>/dev/null

echo ""
echo "📊 MySQL 정보:"
echo "  - 컨테이너: mysql-container"
echo "  - 데이터베이스: $MYSQL_DATABASE"
echo "  - 사용자: root"
echo ""
echo "🔗 연결 명령어:"
echo "  mysql -h 127.0.0.1 -u root -p$MYSQL_ROOT_PASSWORD" 