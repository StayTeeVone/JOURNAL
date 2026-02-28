from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum, DECIMAL, Text
from sqlalchemy.orm import relationship
from db import Base


class User(Base):
    __tablename__ = "user"

    id_user = Column(Integer, primary_key=True, index=True)
    username = Column(String(20), nullable=False)
    email = Column(String(85), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)


class Asset(Base):
    __tablename__ = "asset"

    id_asset = Column(Integer, primary_key=True, index=True)
    ticker = Column(String(20), unique=True, nullable=False)
    name = Column(String(100), nullable=False)


class Trade(Base):
    __tablename__ = "trade"

    id_trade = Column(Integer, primary_key=True, index=True)
    id_prop_account = Column(Integer, nullable=False)
    id_asset = Column(Integer, ForeignKey("asset.id_asset"))
    direction = Column(Enum("Long", "Short"))
    status = Column(Enum("Open", "Closed"))
    pnl_amount = Column(DECIMAL(15, 2))
    open_date = Column(DateTime)
    closed_date = Column(DateTime)
    description = Column(Text)

    asset = relationship("Asset")