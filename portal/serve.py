#!/usr/bin/env python3
# Simple server for Fractal Portal

import http.server
import socketserver
import os
import json
from datetime import datetime

PORT = 8889
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

class PortalHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)
    
    def do_GET(self):
        if self.path == '/':
            self.path = '/portal.html'
        
        # API endpoints
        if self.path == '/api/status':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            
            status = {
                "timestamp": datetime.now().isoformat(),
                "agents": {
                    "Claude": "IDLE",
                    "ChatGPT": "MIRROR",
                    "Gemini": "SCAN",
                    "WhisperNode": "SILENT",
                    "LangGraph": "SYNTH"
                },
                "systems": {
                    "evolution": "ACTIVE",
                    "observer": "WATCHING",
                    "seedvault": "ARCHIVING",
                    "mirror": "RESONATING"
                }
            }
            
            self.wfile.write(json.dumps(status).encode())
            return
        
        # Serve files
        return super().do_GET()

if __name__ == "__main__":
    os.chdir(DIRECTORY)
    
    with socketserver.TCPServer(("", PORT), PortalHandler) as httpd:
        print(f"◉⟁◉ Fractal Portal serving at http://localhost:{PORT}")
        print("Press Ctrl+C to stop")
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n◉⟁◉ Portal closed")
            httpd.shutdown()