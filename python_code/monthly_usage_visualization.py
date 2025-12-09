import pandas as pd
import matplotlib.pyplot as plt

# Read the CSV file
df = pd.read_csv('../database_loader/timeoftripsandsoon.csv', parse_dates=['starttime'])

# Extract month from starttime
df['month'] = df['starttime'].dt.month

# Group by month and count trips
monthly_usage = df.groupby('month').size()

# Create the plot
plt.figure(figsize=(10, 6))
monthly_usage.plot(kind='bar', color='skyblue')
plt.title('Monthly Bike Service Usage')
plt.xlabel('Month')
plt.ylabel('Number of Trips')
plt.xticks(rotation=0)
plt.grid(axis='y')
plt.tight_layout()

# Save the plot
plt.savefig('monthly_usage.png')
print("Visualization saved as monthly_usage.png")
