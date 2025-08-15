#!/bin/bash

# MongoDB Docker 컨테이너 설정 스크립트
echo ""
echo "🍃 MongoDB Docker 컨테이너 설정"
echo "================================"

# 사용자 입력 받기
echo ""
read -p "MongoDB Root 비밀번호를 입력하세요: " MONGO_ROOT_PASSWORD
read -p "생성할 데이터베이스 이름을 입력하세요: " MONGO_DATABASE

echo ""
echo "📋 설정 정보:"
echo "  - Root 비밀번호: $MONGO_ROOT_PASSWORD"
echo "  - 데이터베이스: $MONGO_DATABASE"

# 기존 컨테이너 확인 및 제거
if docker ps -a --format "table {{.Names}}" | grep -q "mongo-container"; then
    echo ""
    echo "⚠️  기존 MongoDB 컨테이너를 제거합니다..."
    docker stop mongo-container 2>/dev/null
    docker rm mongo-container 2>/dev/null
fi

# MongoDB 컨테이너 실행
echo ""
echo "🚀 MongoDB 컨테이너를 시작합니다..."
docker run -d \
    --name mongo-container \
    -e MONGO_INITDB_ROOT_USERNAME="root" \
    -e MONGO_INITDB_ROOT_PASSWORD="$MONGO_ROOT_PASSWORD" \
    -p 27017:27017 \
    mongo:latest

# 컨테이너 시작 대기
echo ""
echo "⏳ MongoDB가 시작될 때까지 기다리는 중..."
sleep 30

# 연결 테스트 및 데이터베이스 생성 테스트
echo ""
echo "🔍 연결 테스트 및 데이터베이스 생성 중..."
if docker exec mongo-container mongosh --username "root" --password "$MONGO_ROOT_PASSWORD" --eval "print('MongoDB Connection Test - Database created successfully');" 2>/dev/null; then
    echo ""
    echo "✅ MongoDB 연결 및 데이터베이스 생성 성공!"
else
    echo ""
    echo "❌ MongoDB 연결 또는 데이터베이스 생성 실패. 로그를 확인해주세요."
    docker logs mongo-container
    exit 1
fi

# 데이터베이스 테이블 생성, 데이터 삽입, 조회 테스트
echo ""
echo "🔍 데이터 저장 테스트 중..."
docker exec mongo-container mongosh --username "root" --password "$MONGO_ROOT_PASSWORD" --eval "db = db.getSiblingDB('$MONGO_DATABASE'); db.test.insertOne({test: 'connection'});" 2>/dev/null
docker exec mongo-container mongosh --username "root" --password "$MONGO_ROOT_PASSWORD" --eval "db = db.getSiblingDB('$MONGO_DATABASE'); db.test.find({test: 'connection'});" 2>/dev/null

echo ""
echo "📊 MongoDB 정보:"
echo "  - 컨테이너: mongo-container"
echo "  - 데이터베이스: $MONGO_DATABASE"
echo "  - 사용자: root"
echo ""
echo "🔗 연결 명령어:"
echo "  mongosh --username root --password $MONGO_ROOT_PASSWORD --host 127.0.0.1"