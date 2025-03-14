# FastAPI 배포 연습 프로젝트

간단한 FastAPI 애플리케이션 배포 연습을 위한 프로젝트입니다. Poetry를 사용하여 의존성을 관리합니다.

## 프로젝트 구조

```
fastapi_deploy_tutorial/
├── app/                    # 애플리케이션 패키지
│   ├── api/                # API 엔드포인트
│   │   ├── hello.py        # Hello World 엔드포인트
│   │   └── router.py       # API 라우터 모음
│   └── main.py             # FastAPI 애플리케이션 정의
├── pyproject.toml          # Poetry 의존성 정의
└── Dockerfile              # Docker 이미지 정의
```

## 개발 환경 설정

1. Poetry 설치 (아직 설치하지 않은 경우):

```bash
curl -sSL https://install.python-poetry.org | python3 -
```

2. 의존성 설치:

```bash
poetry install
```

## 로컬에서 실행하기

1. 애플리케이션 실행:

```bash
uvicorn app.main:app --reload
```

2. 브라우저에서 확인:
   - API 문서: http://localhost:8000/docs
   - 엔드포인트: http://localhost:8000/
