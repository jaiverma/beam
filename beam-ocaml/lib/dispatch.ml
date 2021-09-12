(* responsible for reading messages and dispatching to the appropriate function *)

type cmd =
  | READ_DIR
  | READ_FILE
  | WRITE_FILE

let call fn args =
  match fn with
  | READ_DIR ->
    let dirname =
      match args with
      | [ d ] -> d
      | _ -> raise (Invalid_argument "READ_DIR")
    in
    Ops.read_dir dirname
  | READ_FILE ->
    let filename =
      match args with
      | [ f ] -> f
      | _ -> raise (Invalid_argument "READ_FILE")
    in
    Ops.read_file filename
  | WRITE_FILE ->
    let filename, contents =
      match args with
      | [ f; c ] -> f, c
      | _ -> raise (Invalid_argument "WRITE_FILE")
    in
    Ops.write_file filename contents
;;
