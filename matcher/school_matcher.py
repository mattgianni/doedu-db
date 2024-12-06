from __future__ import annotations
from dataclasses import dataclass
from typing import Optional, Dict
from difflib import SequenceMatcher as SM
import hashlib
from dotenv import load_dotenv
import psycopg2
import os


@dataclass
class School:
    school_name: str
    zip: str
    school_code: str = "000000"

    @staticmethod
    def generate_school_hash(school_name: str, zip: str) -> str:
        hash_object = hashlib.sha256()
        hash_object.update(f"{zip}-{school_name}".encode("utf-8"))
        return hash_object.hexdigest()


@dataclass
class SchoolMatch:
    match: School
    ratio: float


class SchoolMatcher:
    def __init__(self, schools: list[School] = []):
        self.school_zip_map: Dict[str, list[School]] = {}
        for school in schools:
            self.add_school(school)

    def add_school(self, school: School):
        if school.zip not in self.school_zip_map:
            self.school_zip_map[school.zip] = []
        self.school_zip_map[school.zip].append(school)

    def best_match(self, school_name: str, zipcode: str) -> Optional[SchoolMatch]:

        if zipcode not in self.school_zip_map:
            return None

        best_ratio: float = -1.0
        best_match = None

        for school in self.school_zip_map[zipcode]:
            ratio = SM(None, school_name, school.school_name).ratio()
            if ratio > best_ratio:
                best_ratio = ratio
                best_match = school

        return {"match": best_match, "ratio": best_ratio}

    @staticmethod
    def from_db(
        query: str = "SELECT school_name, zip_code, school_code from entities where county_code = '38' and school_name is not null and zip_code is not null;",
    ) -> SchoolMatcher:
        load_dotenv()
        conn = psycopg2.connect(
            dbname=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
            host=os.getenv("DB_HOST", "localhost"),
            port=os.getenv("DB_PORT", "5432"),
        )
        cur = conn.cursor()
        cur.execute(query)
        schools = []
        for record in cur.fetchall():
            schools.append(School(*record))
        return SchoolMatcher(schools)
