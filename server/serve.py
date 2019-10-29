#!/usr/local/opt/python/bin/python3.7
import http.server
import socketserver
import os
from sys import argv

PORT = 3000
PATH = os.getcwd()
argCount = len(argv)

if argCount == 2:
  if argv[1].isdigit():
    PORT = int(argv[1])
  else:
    PATH = os.path.join(os.getcwd(), argv[1])
elif argCount == 3:
  PATH = os.path.join(os.getcwd(), argv[1])
  PORT = int(argv[2])

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=PATH, **kwargs)

# PATH != os.getcwd() and os.chdir(PATH)
# Handler = http.server.SimpleHTTPRequestHandler

httpd = socketserver.TCPServer(("", PORT), Handler)
print("serving at port {0} from '{1}' ...".format(PORT, PATH))
try:
  httpd.serve_forever()
except:
  httpd.shutdown
  print('\n Keyboard interrupt received, exiting.')
