from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from db import SessionLocal, init_db
import models
from schemas import AccountCreate, AccountUpdate, AccountOut
from schemas_trades import TradeCreate, TradeUpdate, TradeOut

app = FastAPI(title="Trading Journal API")

# Dependency to get DB session

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.on_event("startup")
def on_startup():
    init_db()

@app.get("/")
def root():
    return {"message": "Trading Journal API is running!"}

@app.get("/accounts/test")
def test_accounts(db: Session = Depends(get_db)):
    # Просто тестовый запрос к таблице аккаунтов
    accounts = db.query(models.Account).all()
    return {"accounts": [a.name for a in accounts]}

@app.post("/accounts/", response_model=AccountOut)
def create_account(account: AccountCreate, db: Session = Depends(get_db)):
    db_account = models.Account(name=account.name, balance=account.balance)
    db.add(db_account)
    db.commit()
    db.refresh(db_account)
    return db_account

@app.get("/accounts/", response_model=list[AccountOut])
def get_accounts(db: Session = Depends(get_db)):
    return db.query(models.Account).all()

@app.get("/accounts/{account_id}", response_model=AccountOut)
def get_account(account_id: int, db: Session = Depends(get_db)):
    acc = db.query(models.Account).filter(models.Account.id == account_id).first()
    if not acc:
        raise HTTPException(status_code=404, detail="Account not found")
    return acc

@app.put("/accounts/{account_id}", response_model=AccountOut)
def update_account(account_id: int, account: AccountUpdate, db: Session = Depends(get_db)):
    db_account = db.query(models.Account).filter(models.Account.id == account_id).first()
    if not db_account:
        raise HTTPException(status_code=404, detail="Account not found")
    if account.name is not None:
        db_account.name = account.name
    if account.balance is not None:
        db_account.balance = account.balance
    db.commit()
    db.refresh(db_account)
    return db_account

@app.delete("/accounts/{account_id}")
def delete_account(account_id: int, db: Session = Depends(get_db)):
    db_account = db.query(models.Account).filter(models.Account.id == account_id).first()
    if not db_account:
        raise HTTPException(status_code=404, detail="Account not found")
    db.delete(db_account)
    db.commit()
    return {"ok": True}

@app.post("/trades/", response_model=TradeOut)
def create_trade(trade: TradeCreate, db: Session = Depends(get_db)):
    db_trade = models.Trade(**trade.dict())
    db.add(db_trade)
    db.commit()
    db.refresh(db_trade)
    return db_trade

@app.get("/trades/", response_model=list[TradeOut])
def get_trades(db: Session = Depends(get_db)):
    return db.query(models.Trade).all()

@app.get("/trades/{trade_id}", response_model=TradeOut)
def get_trade(trade_id: int, db: Session = Depends(get_db)):
    trade = db.query(models.Trade).filter(models.Trade.id == trade_id).first()
    if not trade:
        raise HTTPException(status_code=404, detail="Trade not found")
    return trade

@app.put("/trades/{trade_id}", response_model=TradeOut)
def update_trade(trade_id: int, trade: TradeUpdate, db: Session = Depends(get_db)):
    db_trade = db.query(models.Trade).filter(models.Trade.id == trade_id).first()
    if not db_trade:
        raise HTTPException(status_code=404, detail="Trade not found")
    for field, value in trade.dict(exclude_unset=True).items():
        setattr(db_trade, field, value)
    db.commit()
    db.refresh(db_trade)
    return db_trade

@app.delete("/trades/{trade_id}")
def delete_trade(trade_id: int, db: Session = Depends(get_db)):
    db_trade = db.query(models.Trade).filter(models.Trade.id == trade_id).first()
    if not db_trade:
        raise HTTPException(status_code=404, detail="Trade not found")
    db.delete(db_trade)
    db.commit()
    return {"ok": True}
