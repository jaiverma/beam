(* responsible for reading messages and dispatching to the appropriate function *)

type cmd =
  | READ_DIR of string
  | READ_FILE of string
  | WRITE_FILE of string * string
[@@deriving yojson, show]

let call = function
  | READ_DIR dirname -> Ops.read_dir dirname
  | READ_FILE filename -> Ops.read_file filename
  | WRITE_FILE (filename, contents) -> Ops.write_file filename contents
;;
