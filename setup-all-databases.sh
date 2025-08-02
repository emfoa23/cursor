#!/bin/bash

# 모든 데이터베이스 Docker 컨테이너 설정 스크립트

echo "🗄️  모든 데이터베이스 설정"
echo "================================"

echo "설정할 데이터베이스를 선택하세요:"
echo "1. MySQL"
echo "2. MongoDB"
echo "3. Redis"
echo "4. 모든 데이터베이스"
echo "5. 종료"

echo ""
read -p "선택하세요 (1-5): " choice

case $choice in
    1)
        echo "🐬 MySQL 설정을 시작합니다..."
        ./scripts/setup-mysql.sh
        ;;
    2)
        echo "🍃 MongoDB 설정을 시작합니다..."
        ./scripts/setup-mongo.sh
        ;;
    3)
        echo "🔴 Redis 설정을 시작합니다..."
        ./scripts/setup-redis.sh
        ;;
    4)
        echo "🗄️  모든 데이터베이스를 설정합니다..."
        echo ""
        echo "=== MySQL 설정 ==="
        ./scripts/setup-mysql.sh
        echo ""
        echo "=== MongoDB 설정 ==="
        ./scripts/setup-mongo.sh
        echo ""
        echo "=== Redis 설정 ==="
        ./scripts/setup-redis.sh
        echo ""
        echo "✅ 모든 데이터베이스 설정 완료!"
        ;;
    5)
        echo "종료합니다."
        exit 0
        ;;
    *)
        echo "잘못된 선택입니다."
        exit 1
        ;;
esac

echo ""
echo "📊 실행 중인 컨테이너 확인:"
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}" 