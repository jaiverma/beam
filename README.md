# Beam

Tool to read/write files on a remote system. The final goal is to implement it in OCaml,
but we'll prototype it with Python first since I'm pretty comfortable with it.

There will be 2 components:
- beam
This will be the binary which implements the client server protocol. We will use VSOCK
for communication (`AF_HYPERV` for Windows and `AF_VSOCK` for Linux). The main usecase is
to edit files present on a Hyper-V Linux VM from a Windows host. Also, we will want
features like creating a new file on the guest, using an LSP like Merlin and an
autoformatter like OCamlFormat from the remote system. Also, support for building on the
remote system.

- beam-nvim
An nvim plugin for facilitating this interaction.
