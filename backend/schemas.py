from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class AccountBase(BaseModel):
    name: str
    balance: float

class AccountCreate(AccountBase):
    pass

class AccountUpdate(BaseModel):
    name: Optional[str] = None
    balance: Optional[float] = None

class AccountOut(AccountBase):
    id: int
    created_at: Optional[datetime]
    class Config:
        orm_mode = True
