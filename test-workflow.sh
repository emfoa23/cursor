#!/bin/bash

# GitHub Actions Workflow 로컬 테스트 스크립트
# Colima + act를 사용하여 로컬에서 workflow 실행

set -e

echo "🚀 GitHub Actions Workflow 로컬 테스트 시작"
echo "=========================================="

# 1. Colima 상태 확인
echo "📋 1. Colima 상태 확인 중..."
if ! colima status > /dev/null 2>&1; then
    echo "❌ Colima가 실행되지 않았습니다. 시작 중..."
    colima start
else
    echo "✅ Colima가 실행 중입니다."
fi

# 2. Docker 소켓 경로 설정
echo "📋 2. Docker 소켓 경로 설정 중..."
export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
echo "✅ DOCKER_HOST 설정 완료: $DOCKER_HOST"

# 3. act 설치 확인
echo "📋 3. act 도구 확인 중..."
if ! command -v act &> /dev/null; then
    echo "❌ act가 설치되지 않았습니다."
    echo "설치 명령어: brew install act"
    exit 1
else
    echo "✅ act가 설치되어 있습니다: $(which act)"
fi

# 4. 사용 가능한 workflow 확인
echo "📋 4. 사용 가능한 workflow 확인 중..."
act --list

# 5. workflow 실행
echo "📋 5. workflow 실행 중..."
echo "=========================================="

# workflow_dispatch 이벤트로 실행
act workflow_dispatch --container-architecture linux/amd64

echo "=========================================="
echo "✅ Workflow 테스트 완료!"