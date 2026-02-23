from sqlalchemy import Column, Integer, String, DECIMAL, DateTime, ForeignKey, Text
from sqlalchemy.orm import declarative_base, relationship

Base = declarative_base()

class Account(Base):
    __tablename__ = 'accounts'
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    balance = Column(DECIMAL(18,2), nullable=False)
    created_at = Column(DateTime)
    trades = relationship('Trade', back_populates='account')
    documents = relationship('Document', back_populates='account')
    assets = relationship('Asset', back_populates='account')

class Trade(Base):
    __tablename__ = 'trades'
    id = Column(Integer, primary_key=True)
    account_id = Column(Integer, ForeignKey('accounts.id'))
    asset_id = Column(Integer, ForeignKey('assets.id'))
    direction = Column(String(10))
    result = Column(String(20))
    session = Column(String(20))
    risk_percent = Column(DECIMAL(5,2))
    rr_ratio = Column(DECIMAL(5,2))
    open_date = Column(DateTime)
    description = Column(Text)
    created_at = Column(DateTime)
    account = relationship('Account', back_populates='trades')
    asset = relationship('Asset', back_populates='trades')
    screenshots = relationship('Screenshot', back_populates='trade')
    reasons = relationship('Reason', back_populates='trade')

class Screenshot(Base):
    __tablename__ = 'screenshots'
    id = Column(Integer, primary_key=True)
    trade_id = Column(Integer, ForeignKey('trades.id'))
    timeframe = Column(String(10))
    file_path = Column(String(255))
    trade = relationship('Trade', back_populates='screenshots')

class Document(Base):
    __tablename__ = 'documents'
    id = Column(Integer, primary_key=True)
    account_id = Column(Integer, ForeignKey('accounts.id'))
    title = Column(String(100))
    content = Column(Text)
    created_at = Column(DateTime)
    account = relationship('Account', back_populates='documents')
    screenshots = relationship('DocumentScreenshot', back_populates='document')

class DocumentScreenshot(Base):
    __tablename__ = 'document_screenshots'
    id = Column(Integer, primary_key=True)
    document_id = Column(Integer, ForeignKey('documents.id'))
    file_path = Column(String(255))
    document = relationship('Document', back_populates='screenshots')

class Asset(Base):
    __tablename__ = 'assets'
    id = Column(Integer, primary_key=True)
    account_id = Column(Integer, ForeignKey('accounts.id'))
    name = Column(String(100))
    ticker = Column(String(20))
    account = relationship('Account', back_populates='assets')
    trades = relationship('Trade', back_populates='asset')

class Strategy(Base):
    __tablename__ = 'strategies'
    id = Column(Integer, primary_key=True)
    name = Column(String(100))
    description = Column(Text)

class Reason(Base):
    __tablename__ = 'reasons'
    id = Column(Integer, primary_key=True)
    trade_id = Column(Integer, ForeignKey('trades.id'))
    text = Column(Text)
    trade = relationship('Trade', back_populates='reasons')

class Timeframe(Base):
    __tablename__ = 'timeframes'
    id = Column(Integer, primary_key=True)
    name = Column(String(20))
