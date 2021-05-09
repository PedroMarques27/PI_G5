import sys
from art import *
import requests
import base64
import xml.etree.ElementTree as ET
import warnings

def main():
    warnings.filterwarnings("ignore")
    menu()


def menu():
    Title=text2art("RCU Simulator")
    print(Title)
    print()

    choice = input("""
    N: Notify MUP-RR of bond change
    E: Exit
    
    Please enter your choice: """)

    if choice == "N" or choice =="n":
        notify()
    elif choice=="E" or choice=="e":
        sys.exit
    else:
        print("You must select a valid option")
        menu()

def notify():
    print()
    UU = input("Insert user's UU (Utilizador Universal)")
    Vinculo = input("Insert user's bond (Vinculo)")
    UO = input("Insert user's UO (Unidade Organica)")

    authInfo = "muprr-rcu-srvc@ua.pt:8p#Dw8*FS9e=$T@"
    authInfo = (base64.b64encode(authInfo.encode('ascii'))).decode('ascii')
    authInfo = "Basic "+authInfo

    url="https://ws-ext.ua.pt/UUExt/UUExt.asmx"
    headers = {'content-type': 'text/xml;charset=\"utf-8\"', 'Authorization': authInfo}
    body = """<?xml version="1.0" encoding="utf-8"?>
                <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
                <soap:Body>
                    <getIUPI xmlns="http://app.web.ua.pt/UU/">
                    <UU>"""+UU+"""</UU>
                    </getIUPI>
                </soap:Body>
                </soap:Envelope>"""

    response = requests.post(url,data=body,headers=headers)
    root = ET.fromstring(response.content)
    sid = root.findall(".//{http://app.web.ua.pt/UU/}getIUPIResult")
    
    iupi = sid[0].text

    payload = {
        "iupi": iupi,
        "pairs": [
            [Vinculo,UO]
            ]
        }

    r = requests.post('https://localhost:5001/api/v1/notify', json=payload, verify=False)
    #print(r.status_code)

main()