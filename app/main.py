from fastapi import FastAPI
from app.api.router import api_router

app = FastAPI(title="배포 연습용 API test")

# API 라우터 등록
app.include_router(api_router)