(* Accept messages over TCP and forward them to the dispatcher *)

open Core
open Lwt.Infix

let listen_address = Unix.Inet_addr.localhost
let port = 10001
let generate_ok () = Lwt.return_ok "world"
let generate_err () = Lwt.return_error "hello"

(* calls a function which returns a `(string, string) Result Lwt.t`. based on the return
 * value (whether the function call was successful or not) return an appropriate response
 * as a string *)
let handle_message msg =
  match String.strip msg with
  | "hello" ->
    generate_err ()
    >>= (function
    | Ok ret -> "success:" ^ ret |> Lwt.return
    | Error ret -> "failure:" ^ ret |> Lwt.return)
  | "bye" ->
    generate_ok ()
    >>= (function
    | Ok ret -> "success:" ^ ret |> Lwt.return
    | Error ret -> "failure:" ^ ret |> Lwt.return)
  | _ -> "failure:" ^ "command not supported" |> Lwt.return
;;

let rec handle_connection ic oc () =
  Lwt_io.read_line_opt ic
  >>= fun msg ->
  match msg with
  | Some msg ->
    handle_message msg
    >>= fun reply -> Lwt_io.write_line oc reply >>= handle_connection ic oc
  | None -> Logs_lwt.info (fun m -> m "Connection closed") >>= Lwt.return
;;

let accept_connection conn =
  let fd, _ = conn in
  let ic = Lwt_io.(of_fd ~mode:Input fd) in
  let oc = Lwt_io.(of_fd ~mode:Output fd) in
  Lwt.on_failure (handle_connection ic oc ()) (fun e ->
      Logs.err (fun m -> m "%s" (Exn.to_string e)));
  Logs_lwt.info (fun m -> m "New connection") >>= Lwt.return
;;

let create_socket () =
  let sock = Lwt_unix.(socket PF_INET SOCK_STREAM 0) in
  Lwt_unix.bind sock @@ Lwt_unix.ADDR_INET (listen_address, port) |> Lwt.ignore_result;
  Lwt_unix.listen sock 10;
  sock
;;

let create_server sock =
  let rec serve () = Lwt_unix.accept sock >>= accept_connection >>= serve in
  serve
;;
