from fastapi import FastAPI

app = FastAPI()

# 测试接口
@app.get("/")
def home():
    return {"message": "HealthMax API running"}

# 登录接口
@app.post("/login")
def login(username: str, password: str):
    return {"status": "success", "user": username}

# 获取健康数据
@app.get("/data")
def get_data():
    return {
        "heart_rate": 72,
        "steps": 5400,
        "glucose": 5.2
    }

# 上传健康数据
@app.post("/data")
def upload_data(heart_rate: int, steps: int):
    return {"message": "data saved"}