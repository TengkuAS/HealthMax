import models, schemas
from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from passlib.context import CryptContext
from database import get_db
from typing import List
from datetime import date, timedelta
from sqlalchemy import func, and_
from typing import Optional, List
app = FastAPI(title="HealthMax API")

# 密码哈希上下文
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

# ---------- 用户注册 ----------

@app.post('/register', response_model=schemas.UserResponse)
async def register(user: schemas.UserCreate, db: AsyncSession = Depends(get_db)):
    try:
        # 原来的所有代码（包括检查用户是否存在、创建用户等）
        result = await db.execute(select(models.User).where(models.User.username == user.username))
        existing_user = result.scalar_one_or_none()
        if existing_user:
            raise HTTPException(status_code=400, detail="用户名已存在")
        # ... 创建用户 ...
    except Exception as e:
        import traceback
        traceback.print_exc()   # 在终端打印完整堆栈
        raise HTTPException(status_code=500, detail=str(e))  # 返回具体错误信息

    # 2. 密码哈希并创建新用户
    hashed_password = get_password_hash(user.password)
    db_user = models.User(
        username=user.username,
        password_hash=hashed_password,
        gender=user.gender,
        age=user.age,
        height_cm=user.height_cm,
        weight_kg=user.weight_kg
    )
    db.add(db_user)
    await db.commit()
    await db.refresh(db_user)
    return db_user

# ---------- 登录（简单版） ----------
@app.post('/login')
async def login(username: str, password: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(models.User).where(models.User.username == username))
    user = result.scalar_one_or_none()          # 注意：这里变量名是 result 不是 results
    if not user or not verify_password(password, user.password_hash):
        raise HTTPException(status_code=401, detail="用户名或密码错误")
    return {"message": "login successful", "username": user.username}

# ---------- 健康日志模块 ----------
@app.post("/users/{username}/health-logs", response_model=schemas.HealthLogResponse)
async def create_health_log(
    username: str,
    log: schemas.HealthLogCreate,
    db: AsyncSession = Depends(get_db)
):
    # 确保用户存在
    user = await db.get(models.User, username)
    if not user:
        raise HTTPException(status_code=404, detail="account not exist")
    
    db_log = models.HealthLog(
        username=username,
        metric_type=log.metric_type,
        value=log.value
    )
    db.add(db_log)
    await db.commit()
    await db.refresh(db_log)
    return db_log

@app.get("/users/{username}/health-logs", response_model=List[schemas.HealthLogResponse])
async def get_health_logs(
    username: str,
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(models.HealthLog)
        .where(models.HealthLog.username == username)
        .offset(skip)
        .limit(limit)
    )
    logs = result.scalars().all()
    return logs


@app.get("/users/{username}/health-logs/aggregate", response_model=List[schemas.HealthLogAggregate])
async def get_health_logs_aggregate(
    username: str,
    metric_type: str,
    granularity: str = "day",          # 可选 "day", "week", "month"
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    db: AsyncSession = Depends(get_db)
):
    """
    Aggregate the health data of the specified indicators by day/week/month. 
    Return the average value, total sum and the number of records within each period.
    """
    # 默认时间范围：最近7天
    if not end_date:
        end_date = date.today()
    if not start_date:
        start_date = end_date - timedelta(days=7)

    # 确保包含结束日期当天的数据（recorded_at 是 timestamp）
    end_inclusive = end_date + timedelta(days=1)

    # 使用 PostgreSQL 的 date_trunc 按粒度截断时间戳
    query = select(
        func.date_trunc(granularity, models.HealthLog.recorded_at).label("period"),
        func.avg(models.HealthLog.value).label("avg_value"),
        func.sum(models.HealthLog.value).label("sum_value"),
        func.count().label("count")
    ).where(
        and_(
            models.HealthLog.username == username,
            models.HealthLog.metric_type == metric_type,
            models.HealthLog.recorded_at >= start_date,
            models.HealthLog.recorded_at < end_inclusive
        )
    ).group_by("period").order_by("period")

    result = await db.execute(query)
    rows = result.all()

    aggregates = []
    for row in rows:
        # 将 datetime 对象格式化为日期字符串（用于前端显示）
        period_str = row.period.strftime("%Y-%m-%d")
        aggregates.append(schemas.HealthLogAggregate(
            period=period_str,
            avg_value=row.avg_value,
            sum_value=row.sum_value,
            count=row.count
        ))
    return aggregates
# ---------- 饮食日志模块 ----------
@app.post("/users/{username}/food-logs", response_model=schemas.FoodLogResponse)
async def create_food_log(
    username: str,
    log: schemas.FoodLogCreate,
    db: AsyncSession = Depends(get_db)
):
    user = await db.get(models.User, username)
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    
    db_log = models.FoodLog(
        username=username,
        food_name=log.food_name,
        calories=log.calories
    )
    db.add(db_log)
    await db.commit()
    await db.refresh(db_log)
    return db_log

@app.get("/users/{username}/food-logs", response_model=List[schemas.FoodLogResponse])
async def get_food_logs(
    username: str,
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(models.FoodLog)
        .where(models.FoodLog.username == username)
        .offset(skip)
        .limit(limit)
    )
    logs = result.scalars().all()
    return logs


@app.get("/")
async def root():
    return {"message": "HealthMax API is running. Visit /docs for API documentation."}
# 其他模块（目标、设备、医院反馈等）可类似添加