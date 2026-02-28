from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db import get_db
import crud
import schemas

router = APIRouter(
    prefix="/trades",
    tags=["Trades"]
)


@router.get("/", response_model=list[schemas.TradeResponse])
def read_trades(db: Session = Depends(get_db)):
    return crud.get_trades(db)


@router.post("/", response_model=schemas.TradeResponse)
def create_trade(trade: schemas.TradeCreate, db: Session = Depends(get_db)):
    return crud.create_trade(db, trade)