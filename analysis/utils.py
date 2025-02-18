from dotenv import load_dotenv
import psycopg2
from sqlalchemy import create_engine
import os
import logging

# Configure logging
logging.basicConfig(
    format="%(asctime)s [%(levelname)s] %(filename)s:%(funcName)s - %(message)s",
    datefmt="%H:%M:%S",
    level=logging.INFO,
)
logging.getLogger(__name__).debug("logger initialized")

load_dotenv()
connection_params = {
    "dbname": os.getenv("DB_NAME", "postgres"),
    "user": os.getenv("DB_USER", "postgres"),
    "password": os.getenv("DB_PASSWORD", "postgres"),
    "host": os.getenv("DB_HOST", "localhost"),
    "port": os.getenv("DB_PORT", "5432"),
}


def connect_db():
    return psycopg2.connect(**connection_params)


def db_url():
    return f"postgresql://{connection_params['user']}:{connection_params['password']}@{connection_params['host']}:{connection_params['port']}/{connection_params['dbname']}"


def sqlalchemy_engine():
    return create_engine(db_url())
