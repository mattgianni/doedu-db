from __future__ import annotations
from dataclasses import dataclass
from typing import Optional, Dict, List
from difflib import SequenceMatcher as SM
import hashlib
from dotenv import load_dotenv
import psycopg2
import os


@dataclass
class School:
    school_name: str
    zip_code: str
    school_code: str = "000000"

    @staticmethod
    def generate_school_hash(school_name: str, zip_code: str) -> str:
        hash_object = hashlib.sha256()
        hash_object.update(f"{zip_code}-{school_name}".encode("utf-8"))
        return hash_object.hexdigest()


@dataclass
class SchoolMatch:
    """
    Data class representing a school match with a similarity ratio.

    Attributes:
        match (School): The matched school.
        ratio (float): The similarity ratio between the input and the matched school.
    """

    match: School
    ratio: float


class SchoolMatcher:
    """
    A class to match schools based on their names and zip codes.

    Attributes:
        school_zip_map (Dict[str, List[School]]): A dictionary mapping zip codes to lists of schools.

    Methods:
        add_school(school: School):
            Adds a school to the matcher.

        best_match(school_name: str, zip_code: str) -> Optional[SchoolMatch]:
            Finds the best matching school for a given name and zip code.
    """

    def __init__(self, schools: List[School]):
        """
        Initializes the SchoolMatcher with an optional list of schools.

        Args:
            schools (List[School], optional): A list of School objects to initialize the matcher with.
        """
        self.school_zip_map: Dict[str, List[School]] = {}
        if schools:
            for school in schools:
                self.add_school(school)

    def add_school(self, school: School):
        """
        Adds a school to the matcher.

        Args:
            school (School): The school to add.
        """
        if school.zip_code not in self.school_zip_map:
            self.school_zip_map[school.zip_code] = []
        self.school_zip_map[school.zip_code].append(school)

    def best_match(self, school_name: str, zip_code: str) -> Optional[SchoolMatch]:
        """
        Finds the best matching school for a given name and zip code.

        Args:
            school_name (str): The name of the school to match.
            zip_code (str): The zip code of the school to match.

        Returns:
            Optional[SchoolMatch]: The best matching school and its similarity ratio, or None if no match is found.
        """
        if zip_code not in self.school_zip_map:
            return None

        best_ratio: float = -1.0
        best_match = None

        for school in self.school_zip_map[zip_code]:
            ratio = SM(None, school_name, school.school_name).ratio()
            if ratio > best_ratio:
                best_ratio = ratio
                best_match = school

        if best_match:
            return SchoolMatch(match=best_match, ratio=best_ratio)
        return None

    @staticmethod
    def from_db(
        query: str = "SELECT school_name, zip_code, school_code from entities where county_code = '38' and school_name is not null and zip_code is not null;",
    ) -> SchoolMatcher:
        """
        Creates a SchoolMatcher instance by fetching school data from the database.

        Args:
            query (str): SQL query to fetch school data. Defaults to a query that selects
                        school_name, zip_code, and school_code from entities where
                        county_code is '38' and both school_name and zip_code are not null.

        Returns:
            SchoolMatcher: An instance of SchoolMatcher initialized with the fetched school data.

        Raises:
            psycopg2.DatabaseError: If there is an error connecting to the database or executing the query.
        """
        load_dotenv()
        try:
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
            cur.close()
            conn.close()
            return SchoolMatcher(schools)
        except psycopg2.DatabaseError as e:
            print(f"Database error: {e}")
            raise e
