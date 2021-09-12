from comms import tcp
import dispatch

def cmd_handler(msg):
    task = msg['task']
    args = msg['args']
    return dispatch.run(task, args)

server = tcp.TcpServerComms(1234, cmd_handler)
server.start()
