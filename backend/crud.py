from sqlalchemy.orm import Session
import models
import schemas


def get_trades(db: Session):
    return db.query(models.Trade).all()


def create_trade(db: Session, trade: schemas.TradeCreate):
    db_trade = models.Trade(**trade.model_dump())
    db.add(db_trade)
    db.commit()
    db.refresh(db_trade)
    return db_trade