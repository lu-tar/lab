from utils import *


if __name__ == "__main__":
    import urllib3
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)  # Disabilita warning SSL

    try:
        vms = get_vms()
        for vm in vms:
            print(f"VM ID: {vm['vmid']}, Name: {vm['name']}, Status: {vm['status']}")
    except Exception as e:
        print("Errore durante il recupero delle VM:", e)