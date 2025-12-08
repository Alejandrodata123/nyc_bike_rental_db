import re


# Sample data for testing
sample_data = [
    {"tripduration": 3000, "start_station_name": "Station A", "end_station_name": "Station B"},
    {"tripduration": 1800, "start_station_name": "Station A", "end_station_name": "Station C"},
    {"tripduration": 2400, "start_station_name": "Station B", "end_station_name": "Station C"},
    {"tripduration": 3600, "start_station_name": "Station A", "end_station_name": "Station D"},
]

# Function to format duration as MM:SS
def format_duration_seconds(seconds):
    minutes = int(seconds // 60)
    remaining_seconds = int(seconds % 60)
    return f"{minutes:02}:{remaining_seconds:02}"

# Process sample data
results = {}
for trip in sample_data:
    route = f"{trip['start_station_name']} TO {trip['end_station_name']}"
    if route not in results:
        results[route] = {"num_trips": 0, "total_duration": 0, "routes": []}
    results[route]["num_trips"] += 1
    results[route]["total_duration"] += trip["tripduration"]
    results[route]["routes"].append(route)

# Calculate averages and format results
formatted_results = []
for route, data in results.items():
    avg_duration = data["total_duration"] / data["num_trips"]
    formatted_results.append({
        "route": route,
        "num_trips": data["num_trips"],
        "duration_minutes": round(avg_duration / 60, 2),
        "duration": format_duration_seconds(avg_duration)
    })

# Print results
print("Route Analysis Results:")
print("Route\t\t\tNum Trips\tDuration (min)\tDuration (MM:SS)")
print("-" * 60)
for result in formatted_results:
    print(f"{result['route']}\t{result['num_trips']}\t\t{result['duration_minutes']}\t\t{result['duration']}")
