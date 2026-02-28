import models
import schemas
from sqlalchemy.orm import Session
from models import User

def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email).first()


def get_trades(db: Session):
    return db.query(models.Trade).all()


def create_trade(db: Session, trade: schemas.TradeCreate):
    db_trade = models.Trade(**trade.model_dump())
    db.add(db_trade)
    db.commit()
    db.refresh(db_trade)
    return db_trade