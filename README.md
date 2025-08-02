# Database Setup Scripts

이 프로젝트는 다양한 데이터베이스(Docker 컨테이너)를 쉽게 설정할 수 있는 스크립트들을 제공합니다.

## 📋 사용법

### 🗄️ 데이터베이스 설정
데이터베이스 컨테이너를 설정하려면 다음 명령어를 사용하세요:

```bash
./setup-all-databases.sh
```

이 스크립트는 다음 데이터베이스들을 설정할 수 있습니다:
- **MySQL** - 관계형 데이터베이스
- **MongoDB** - NoSQL 문서 데이터베이스  
- **Redis** - 인메모리 키-값 저장소

### 🔄 GitHub Workflow 테스트
로컬에서 GitHub Actions 워크플로우를 테스트하려면 다음 명령어를 사용하세요:

```bash
./test-workflow.sh
```

## 📁 프로젝트 구조

```
cursor/
├── README.md                    # 이 파일
├── setup-all-databases.sh      # 메인 설정 스크립트
├── test-workflow.sh            # 워크플로우 테스트 스크립트
├── .gitignore                  # Git 무시 파일 설정
└── scripts/                    # 개별 데이터베이스 설정 스크립트
    ├── setup-mysql.sh         # MySQL 설정
    ├── setup-mongo.sh         # MongoDB 설정
    └── setup-redis.sh         # Redis 설정
```

## 🚀 빠른 시작

1. **데이터베이스 설정:**
   ```bash
   ./setup-all-databases.sh
   ```

2. **워크플로우 테스트:**
   ```bash
   ./test-workflow.sh
   ```

## 📝 요구사항

- Docker가 설치되어 있어야 합니다
- Bash 쉘 환경이 필요합니다
- macOS, Linux, WSL에서 테스트되었습니다

## 🔧 지원되는 데이터베이스

| 데이터베이스 | 포트 | 설명 |
|-------------|------|------|
| MySQL | 3306 | 관계형 데이터베이스 |
| MongoDB | 27017 | NoSQL 문서 데이터베이스 |
| Redis | 6379 | 인메모리 키-값 저장소 |
