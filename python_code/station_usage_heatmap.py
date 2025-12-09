import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import psycopg2
from sqlalchemy import create_engine

# Database connection parameters
db_params = {
    'dbname': 'nyc_bike_rental',
    'user': 'postgres',
    'password': 'postgres',
    'host': 'localhost',
    'port': '5432'
}

# Create database connection
engine = create_engine(f"postgresql+psycopg2://{db_params['user']}:{db_params['password']}@{db_params['host']}:{db_params['port']}/{db_params['dbname']}")

# Query to get monthly station usage ratio
query = """
WITH monthly_station_usage AS (
    SELECT
        start_station_name,
        EXTRACT(YEAR FROM starttime) AS year,
        EXTRACT(MONTH FROM starttime) AS month,
        COUNT(*) AS trip_count
    FROM
        trips_time_etc
    GROUP BY
        start_station_name, year, month
)
SELECT
    msu.start_station_name,
    msu.year,
    msu.month,
    msu.trip_count,
    s.capacity,
    msu.trip_count * 1.0 / s.capacity AS usage_ratio
FROM
    monthly_station_usage msu
JOIN
    station_data s ON msu.start_station_name = s.name
ORDER BY
    msu.year, msu.month, usage_ratio DESC;
"""

# Load data into DataFrame
df = pd.read_sql(query, engine)

# Pivot the data for heatmap
heatmap_data = df.pivot_table(index='start_station_name', columns=['year', 'month'], values='usage_ratio')

# Create the heatmap
plt.figure(figsize=(15, 20))
sns.heatmap(heatmap_data, cmap='YlOrRd', linewidths=.5, linecolor='gray')

# Set plot title and labels
plt.title('Monthly Station Usage Ratio Heatmap', fontsize=16)
plt.xlabel('Year and Month', fontsize=14)
plt.ylabel('Station Name', fontsize=14)

# Rotate x-axis labels for better readability
plt.xticks(rotation=45, ha='right', fontsize=12)
plt.yticks(fontsize=12)

# Add color bar
cbar = plt.colorbar()
cbar.set_label('Usage Ratio', fontsize=14)

# Adjust layout
plt.tight_layout()

# Save the plot
plt.savefig('station_usage_heatmap.png')
print("Heatmap visualization saved as station_usage_heatmap.png")
