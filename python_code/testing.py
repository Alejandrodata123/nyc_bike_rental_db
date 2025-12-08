print("Python is working correctly!")
print("Version:", end=" ")
import sys
print(sys.version)

# Test database connection
try:
    import psycopg2
    print("psycopg2 is available")
    conn = psycopg2.connect(
        dbname='nyc_citybike',
        user='postgres',
        password='your_password'  # Replace with your actual password
    )
    print("Database connection successful")
    conn.close()
except Exception as e:
    print(f"Error: {e}")

# Test SQL query execution
try:
    import psycopg2
    conn = psycopg2.connect(
        dbname='nyc_citybike',
        user='postgres',
        password='your_password'  # Replace with your actual password
    )
    cursor = conn.cursor()
    cursor.execute("SELECT version();")
    db_version = cursor.fetchone()
    print(f"Database version: {db_version[0]}")
    cursor.close()
    conn.close()
except Exception as e:
    print(f"Error executing query: {e}")
