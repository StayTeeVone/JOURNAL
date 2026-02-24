from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class TradeBase(BaseModel):
    account_id: int
    asset_id: int
    direction: str
    result: Optional[str] = None
    session: Optional[str] = None
    risk_percent: Optional[float] = None
    rr_ratio: Optional[float] = None
    open_date: Optional[datetime] = None
    description: Optional[str] = None

class TradeCreate(TradeBase):
    pass

class TradeUpdate(BaseModel):
    direction: Optional[str] = None
    result: Optional[str] = None
    session: Optional[str] = None
    risk_percent: Optional[float] = None
    rr_ratio: Optional[float] = None
    open_date: Optional[datetime] = None
    description: Optional[str] = None
    asset_id: Optional[int] = None

class TradeOut(TradeBase):
    id: int
    created_at: Optional[datetime]
    class Config:
        orm_mode = True
