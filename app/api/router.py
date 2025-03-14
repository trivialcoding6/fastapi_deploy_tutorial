from fastapi import APIRouter
from app.api import hello

api_router = APIRouter()
# Hello World 라우터 포함
api_router.include_router(hello.router) 