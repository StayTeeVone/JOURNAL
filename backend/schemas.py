from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional


class TradeBase(BaseModel):
    id_prop_account: int
    id_asset: int
    direction: str
    status: str
    pnl_amount: Optional[float] = None
    open_date: Optional[datetime] = None
    closed_date: Optional[datetime] = None
    description: Optional[str] = None


class TradeCreate(TradeBase):
    pass


class TradeResponse(TradeBase):
    id_trade: int

    class Config:
        from_attributes = True

class UserCreate(BaseModel):
    username: str
    email: EmailStr
    password: str


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class Token(BaseModel):
    access_token: str
    token_type: str
