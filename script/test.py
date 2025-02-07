import requests
import time

url = "http://localhost:3000/api/v1/regions/1/departments"
headers = {"Content-Type": "application/json"}

for i in range(10000):  # Envoie 100 requêtes
    response = requests.get(url, headers=headers)
    print(f"Requête {i+1}: Statut {response.status_code}")
    time.sleep(0.01)  # Délai de 10 ms entre chaque requête
