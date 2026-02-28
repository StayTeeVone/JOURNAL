from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from db import engine
import models
from routers import trade
from routers import auth, trade  # правильно

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Trading Journal API")

# Can Angular dev-server
origins = [
    "http://localhost:4200",
    "http://127.0.0.1:4200"    # на всякий случай
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,  # откуда разрешены запросы
    allow_credentials=True,
    allow_methods=["*"],    # GET, POST, PUT, DELETE и т.д.
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(trade.router)
