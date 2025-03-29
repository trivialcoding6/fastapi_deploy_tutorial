FROM python:3.9-slim

# 시스템 패키지 업데이트 및 필요한 의존성 설치
# - apt-get update: Ubuntu/Debian 패키지 목록 최신화
# - build-essential: C/C++ 컴파일러 등 기본 빌드 도구 설치
#   (일부 Python 패키지는 설치 시 C/C++ 코드 컴파일이 필요하며, 이를 위한 도구)
# - curl: URL을 통해 데이터를 전송하는 도구 설치
# - rm -rf: 패키지 캐시를 삭제하여 이미지 크기 최적화
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Poetry 설치 시 네트워크 타임아웃 설정
ENV POETRY_HTTP_TIMEOUT=120

# Poetry 설치 및 PATH 설정
# - curl로 Poetry 설치 스크립트 다운로드 및 실행
# - ln -s: Poetry 실행 파일의 심볼릭 링크를 생성하여 전역 접근 가능하게 함
#   (심볼릭 링크는 원본 파일을 가리키는 바로가기와 같은 것으로,
#    /root/.local/bin/poetry를 /usr/local/bin/poetry에서도 접근 가능하게 함)
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry

# Poetry 가상환경 생성 비활성화 (Docker 컨테이너 내부에서는 불필요)
RUN poetry config virtualenvs.create false

# 의존성 파일만 먼저 복사 및 설치 (레이어 캐싱 최적화)
# --only main: 개발 의존성 제외하고 주요 의존성만 설치
# --no-root: 현재 프로젝트를 설치하지 않고 의존성만 설치 (캐싱 최적화)
# --no-interaction: 사용자 입력 없이 자동 설치
COPY pyproject.toml poetry.lock* ./
RUN poetry install --only main --no-root --no-interaction

# 모든 애플리케이션 코드를 컨테이너로 복사
COPY . .

EXPOSE 8000

# Python 경로에 현재 디렉토리 추가
ENV PYTHONPATH=/app

# FastAPI 애플리케이션 실행
# app.main:app은 app 패키지의 main 모듈에서 app 인스턴스를 찾아 실행
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]