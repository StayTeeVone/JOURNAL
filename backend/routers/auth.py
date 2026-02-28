from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel, EmailStr
from auth import hash_password, verify_password
from db import get_db
from sqlalchemy.orm import Session
from schemas import UserCreate, UserLogin
from models import User  # импорт модели пользователя
from crud import get_user_by_email
import crud

router = APIRouter(prefix="/auth", tags=["auth"])

class UserCreate(BaseModel):
    username: str
    email: EmailStr
    password: str

@router.post("/register")
def register(user: UserCreate, db: Session = Depends(get_db)):
    # Проверяем, есть ли уже пользователь с таким email
    existing_user = db.query(User).filter(User.email == user.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="User already exists")

    # Создаём нового пользователя
    new_user = User(
        username=user.username,
        email=user.email,
        password_hash=hash_password(user.password)  # <- имя поля совпадает с моделью
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return {"message": "User created successfully", "user_id": new_user.id_user}

class UserLogin(BaseModel):
    email: EmailStr
    password: str

# LOGIN
@router.post("/login")
def login(user: UserLogin, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, user.email)
    if not db_user or not verify_password(user.password, db_user.password_hash):
        raise HTTPException(status_code=400, detail="Invalid credentials")
    return {"message": "Login successful", "user_id": db_user.id_user}