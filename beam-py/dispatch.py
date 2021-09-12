import ops

dispatch_table = {
    'read_file': ops.read_file,
    'write_file': ops.write_file,
    'read_dir': ops.read_dir,
}

def run(cmd, args):
    if cmd in dispatch_table:
        return dispatch_table[cmd](*args)
    else:
        return (False, f'Command not found: {cmd}')
