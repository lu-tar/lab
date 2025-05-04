import os
import requests
from dotenv import load_dotenv

# Carica le variabili dal file .env
load_dotenv()

PROXMOX_HOST = os.getenv("PROXMOX_HOST")
API_TOKEN_ID = os.getenv("API_TOKEN_ID")
API_TOKEN_SECRET = os.getenv("API_TOKEN_SECRET")

# Testing gitleaks action
TESTING_ACTIONS_SECRET = "password123456"

# URL base delle API
BASE_URL = f"https://{PROXMOX_HOST}:8006/api2/json"

# Headers per l'autenticazione con API token
headers = {
    "Authorization": f"PVEAPIToken={API_TOKEN_ID}={API_TOKEN_SECRET}"
}

def get_vms():
    # Ottieni l'elenco dei nodi
    response = requests.get(f"{BASE_URL}/nodes", headers=headers, verify=False)
    response.raise_for_status()
    nodes = response.json()['data']

    vms = []

    for node in nodes:
        node_name = node['node']
        # Ottieni le VM per ogni nodo
        vm_response = requests.get(f"{BASE_URL}/nodes/{node_name}/qemu", headers=headers, verify=False)
        vm_response.raise_for_status()
        vms_data = vm_response.json()['data']
        vms.extend(vms_data)

    return vms