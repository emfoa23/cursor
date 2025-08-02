#!/bin/bash

# Redis Docker 컨테이너 설정 스크립트
echo ""
echo "🔴 Redis Docker 컨테이너 설정"
echo "================================"

# 기존 컨테이너 확인 및 제거
if docker ps -a --format "table {{.Names}}" | grep -q "redis-container"; then
    echo ""
    echo "⚠️  기존 Redis 컨테이너를 제거합니다..."
    docker stop redis-container 2>/dev/null
    docker rm redis-container 2>/dev/null
fi

# Redis 컨테이너 실행
echo ""
echo "🚀 Redis 컨테이너를 시작합니다..."
docker run -d \
    --name redis-container \
    -p 6379:6379 \
    redis:latest

# 컨테이너 시작 대기
echo ""
echo "⏳ Redis가 시작될 때까지 기다리는 중..."
sleep 5

# 연결 테스트
echo ""
echo "🔍 연결 테스트 중..."

if docker exec redis-container redis-cli ping 2>/dev/null | grep -q "PONG"; then
    echo ""
    echo "✅ Redis 연결 성공!"
else
    echo ""
    echo "❌ Redis 연결 실패. 로그를 확인해주세요."
    docker logs redis-container
    exit 1
fi

# 데이터 저장 테스트
echo ""
echo "🔍 데이터 저장 테스트 중..."
docker exec redis-container redis-cli set test_key "Hello Redis" 2>/dev/null
docker exec redis-container redis-cli get test_key 2>/dev/null

echo ""
echo "📊 Redis 정보:"
echo "  - 컨테이너: redis-container"
echo ""
echo "🔗 연결 명령어:"
echo "  redis-cli -h 127.0.0.1"