import psycopg2
import pandas as pd
import matplotlib.pyplot as plt

# Database connection parameters
db_params = {
    'host': 'localhost',
    'port': 5432,
    'user': 'postgres',
    'password': 'Takataka21',
    'dbname': 'nyc_citybike'
}

def connect_to_db():
    """Establish connection to PostgreSQL database"""
    try:
        conn = psycopg2.connect(**db_params)
        print("Successfully connected to the database")
        return conn
    except Exception as e: 
        print(f"Error connecting to database: {e}")
        return None

def get_popular_stations(conn):
    """Get the top 10 stations by number of trips starting from them"""
    query = """
    SELECT
        start_station_name,
        COUNT(*) AS start_trip_count
    FROM
        bike_trips_data
    GROUP BY
        start_station_name
    ORDER BY
        start_trip_count DESC
    LIMIT 10;
    """
    return pd.read_sql(query, conn)

def get_popular_routes(conn):
    """Get the most frequently used routes between stations"""
    query = """
    SELECT
        start_station_name,
        end_station_name,
        COUNT(*) AS route_count
    FROM
        bike_trips_data
    GROUP BY
        start_station_name, end_station_name
    ORDER BY
        route_count DESC
    LIMIT 10;
    """
    return pd.read_sql(query, conn)

def get_trip_duration_stats(conn):
    """Get statistics about trip durations"""
    query = """
    SELECT
        MIN(tripduration) AS min_duration,
        MAX(tripduration) AS max_duration,
        AVG(tripduration) AS avg_duration,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY tripduration) AS median_duration
    FROM
        bike_trips_data;
    """
    return pd.read_sql(query, conn)

def get_station_capacity_usage(conn):
    """Get station capacity usage statistics"""
    query = """
    SELECT
        s.station_id,
        s.name,
        s.capacity,
        COUNT(*) AS trips_started,
        COUNT(*) * 100.0 / NULLIF(s.capacity, 0) AS utilization_percentage
    FROM
        bike_trips_data bt
    JOIN
        station_data s ON bt.start_station_name = s.name
    GROUP BY
        s.station_id, s.name, s.capacity
    ORDER BY
        utilization_percentage DESC
    LIMIT 10;
    """
    return pd.read_sql(query, conn)

def plot_popular_stations(df):
    """Plot popular stations data"""
    plt.figure(figsize=(12, 6))
    plt.barh(df['start_station_name'], df['start_trip_count'], color='lightgreen')
    plt.xlabel('Number of Trips')
    plt.title('Top 10 Popular Stations')
    plt.grid(axis='x')
    plt.savefig('popular_stations.png')
    plt.close()

def plot_popular_routes(df):
    """Plot popular routes data"""
    plt.figure(figsize=(12, 8))
    y_pos = range(len(df))
    plt.barh(y_pos, df['route_count'], color='skyblue')
    plt.yticks(y_pos, [f"{row['start_station_name']} → {row['end_station_name']}" for i, row in df.iterrows()])
    plt.xlabel('Number of Trips')
    plt.title('Top 10 Popular Routes')
    plt.grid(axis='x')
    plt.savefig('popular_routes.png')
    plt.close()

def plot_trip_duration_stats(df):
    """Plot trip duration statistics"""
    stats = df.iloc[0]
    labels = ['Min Duration', 'Max Duration', 'Average Duration', 'Median Duration']
    values = [stats['min_duration'], stats['max_duration'],
              stats['avg_duration'], stats['median_duration']]

    plt.figure(figsize=(10, 5))
    plt.bar(labels, values, color='salmon')
    plt.ylabel('Duration (seconds)')
    plt.title('Trip Duration Statistics')
    plt.grid(axis='y')
    plt.savefig('trip_duration_stats.png')
    plt.close()

def plot_station_capacity_usage(df):
    """Plot station capacity usage"""
    plt.figure(figsize=(12, 6))
    plt.bar(df['name'], df['utilization_percentage'], color='lightcoral')
    plt.xlabel('Station Name')
    plt.ylabel('Utilization (%)')
    plt.title('Station Capacity Utilization')
    plt.xticks(rotation=45, ha='right')
    plt.grid(axis='y')
    plt.savefig('station_capacity_usage.png')
    plt.close()

def main():
    # Connect to database
    conn = connect_to_db()
    if conn is None:
        return

    try:
        # Get data
        popular_stations = get_popular_stations(conn)
        popular_routes = get_popular_routes(conn)
        trip_duration_stats = get_trip_duration_stats(conn)
        station_capacity_usage = get_station_capacity_usage(conn)

        # Print some insights
        print("\nTop 5 Popular Stations:")
        print(popular_stations.head())

        print("\nTop 5 Popular Routes:")
        print(popular_routes.head())

        print("\nTrip Duration Statistics:")
        print(trip_duration_stats)

        print("\nTop 5 Station Capacity Usage:")
        print(station_capacity_usage.head())

        # Generate plots
        plot_popular_stations(popular_stations)
        plot_popular_routes(popular_routes)
        plot_trip_duration_stats(trip_duration_stats)
        plot_station_capacity_usage(station_capacity_usage)

        print("\nAnalysis complete. Check the current directory for generated plots.")

    finally:
        # Close database connection
        conn.close()
        print("Database connection closed")

if __name__ == "__main__":
    main()
