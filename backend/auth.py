from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    # обрезаем пароль до 72 байт, если длиннее
    encoded = password.encode("utf-8")[:72]
    return pwd_context.hash(encoded)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    encoded = plain_password.encode("utf-8")[:72]
    return pwd_context.verify(encoded, hashed_password)