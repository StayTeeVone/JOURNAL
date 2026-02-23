from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base

# Настройте строку подключения к MySQL
# Пример: 'mysql+pymysql://user:password@localhost/dbname'
DATABASE_URL = 'mysql+pymysql://root:@localhost/journal'

engine = create_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(bind=engine)

def init_db():
    Base.metadata.create_all(bind=engine)
