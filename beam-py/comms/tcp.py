'''
Server for communicating over TCP sockets
'''

import socket
import json
import struct

class TcpServerComms():
    def __init__(self, port, cmd_handler):
        self._port = port
        self._socket = None
        self._cmd_handler = cmd_handler

    def start(self):
        self._socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self._socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self._socket.bind(('0.0.0.0', self._port))
        self._socket.listen(1)

        while True:
            conn, address = self._socket.accept()
            print(f'got connection from: {address}')
            data_sz = conn.recv(4)
            print(data_sz)
            data_sz = struct.unpack('<I', data_sz)[0]
            data = conn.recv(data_sz)
            print(data)
            assert(len(data) == data_sz)
            data = struct.unpack(f'<{data_sz}s', data)[0]
            data = json.loads(data)

            status, data = self._cmd_handler(data)

            resp = json.dumps({ 'status': status, 'data': data })
            resp_sz = struct.pack('<I', len(resp))
            resp = resp.encode('utf-8')

            conn.send(resp_sz + resp)
            conn.close()
