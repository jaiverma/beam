'''
Implements operations which will be used by the editor.
    - read a file
    - write a file
    - read directory
'''

import os

'''
Tries to read a file and returns its content
- args:
    path: string (path of file to read)
- return:
    (status, data): (bool, string) (successful?, data)
'''
def read_file(path):
    buf = None
    if os.path.exists(path):
        with open(path) as f:
            buf = f.read()

    if buf is not None:
        return (True, buf)
    else:
        return (False, "")

'''
Tries to write `content` to file
- args:
    path: string (path of file to write to)
    contents: string (data to write into file)
- return:
    (status, _): (bool, _) (whether we were successful or not)
'''
def write_file(path, contents):
    status = False
    if os.path.exists(path):
        with open(path, 'w') as f:
            f.write(contents)
        status = True

    return (status, None)

'''
Tries to read contents of directory and returns as a list of realtive paths
- args:
    path: string (directory path to read)
- return:
    (status, paths): (bool, [string]) (successful?, list of paths)
'''
def read_dir(path):
    paths = []
    status = False
    if os.path.isdir(path):
        paths = os.listdir(path)
        status = True

    return (status, paths)
