open Core
open Lwt.Infix

(* function to read a file and return its contents *)
let read_file filename =
  Lwt_io.(with_file ~mode:Input filename) (fun ic ->
      Lwt_io.read_lines ic
      |> Lwt_stream.to_list
      >>= fun l -> String.concat l |> Lwt.return)
;;

(* function to write `contents` to a file *)
let write_file filename contents =
  Lwt_io.(with_file ~mode:Output filename) (fun oc ->
      Lwt_io.write_chars oc @@ Lwt_stream.of_string contents)
;;

(* function to read contents of a directory *)
let read_dir path =
  let dir_fd = Lwt_unix.opendir path in
  let rec read_dir_entry hndl acc =
    let dirname =
      Lwt.catch
        (fun () -> Lwt_unix.readdir hndl >>= fun dirname -> Lwt.return_some dirname)
        (function
          | End_of_file -> Lwt.return_none
          | e -> raise e)
    in
    dirname
    >>= function
    | Some d -> read_dir_entry hndl (d :: acc)
    | None -> Lwt.return acc
  in
  dir_fd >>= fun hndl -> read_dir_entry hndl []
;;
