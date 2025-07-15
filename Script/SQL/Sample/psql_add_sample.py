#! env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "faker",
#     "psycopg2-binary",
# ]
# ///

# docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 --rm -d postgres
# psql -h localhost -p 5432 -U postgres
# ./psql_add_sample.py

import psycopg2
from psycopg2 import Error
from faker import Faker
import random

# PostgreSQL connection parameters
DB_HOST = "localhost"
DB_PORT = "5432"
DB_USER = "postgres"
DB_PASSWORD = "mysecretpassword" # Replace with the password you set for your Docker container
DB_NAME = "postgres" # Initial connection to the default 'postgres' database

NEW_DB_NAME = "samedb"
TABLE_NAME = "users"

# Initialize Faker for generating fake data
fake = Faker('en_US') # Using US English Faker data

def connect_db(database_name):
    """Connects to the PostgreSQL database."""
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            dbname=database_name
        )
        conn.autocommit = True # Auto-commit transactions
        return conn
    except Error as e:
        print(f"Error connecting to database '{database_name}': {e}")
        return None

def create_database(cursor, db_name):
    """Creates a new database."""
    try:
        # Check if the database already exists
        cursor.execute(f"SELECT 1 FROM pg_database WHERE datname = '{db_name}'")
        exists = cursor.fetchone()
        if not exists:
            cursor.execute(f"CREATE DATABASE {db_name}")
            print(f"Database '{db_name}' created successfully.")
        else:
            print(f"Database '{db_name}' already exists.")
    except Error as e:
        print(f"Error creating database '{db_name}': {e}")

def create_table(cursor):
    """Creates the 'users' table."""
    try:
        # Note: The connection here is to NEW_DB_NAME
        create_table_query = f"""
        CREATE TABLE IF NOT EXISTS {TABLE_NAME} (
            id SERIAL PRIMARY KEY,
            username VARCHAR(50) UNIQUE NOT NULL,
            password VARCHAR(255) NOT NULL
        );
        """
        cursor.execute(create_table_query)
        print(f"Table '{TABLE_NAME}' created or already exists.")
    except Error as e:
        print(f"Error creating table '{TABLE_NAME}': {e}")

def insert_random_data(cursor, num_records=10):
    """Inserts random data into the 'users' table."""
    try:
        insert_query = f"""
        INSERT INTO {TABLE_NAME} (username, password)
        VALUES (%s, %s);
        """
        for _ in range(num_records):
            username = fake.user_name() + str(random.randint(100, 999)) # Ensure unique usernames
            password = fake.password(length=12)
            cursor.execute(insert_query, (username, password))
        print(f"Inserted {num_records} random records into '{TABLE_NAME}'.")
    except Error as e:
        print(f"Error inserting data into '{TABLE_NAME}': {e}")

def main():
    # Step 1: Connect to the default 'postgres' database to create the new database
    conn_default = connect_db(DB_NAME)
    if conn_default is None:
        return

    try:
        with conn_default.cursor() as cursor:
            create_database(cursor, NEW_DB_NAME)
    finally:
        conn_default.close()

    # Step 2: Connect to the newly created database
    conn_new_db = connect_db(NEW_DB_NAME)
    if conn_new_db is None:
        return

    try:
        with conn_new_db.cursor() as cursor:
            create_table(cursor)
            insert_random_data(cursor, num_records=100) # Insert 20 random records

            # Verify if data was inserted successfully
            cursor.execute(f"SELECT * FROM {TABLE_NAME} LIMIT 5;")
            print("\nFirst 5 records in 'users' table:")
            for row in cursor.fetchall():
                print(row)

    finally:
        if conn_new_db:
            conn_new_db.close()
            print(f"Connection to '{NEW_DB_NAME}' closed.")

if __name__ == "__main__":
    main()

