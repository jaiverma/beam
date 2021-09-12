open Core
open Lwt.Infix

(* function to read a file and return its contents *)
let read_file filename =
  Lwt.catch
    (fun () ->
      Lwt_io.(with_file ~mode:Input filename) (fun ic ->
          Lwt_io.read_lines ic
          |> Lwt_stream.to_list
          >>= fun l -> String.concat l |> Lwt.return_ok))
    (function
      | _ -> Lwt.return_error @@ Printf.sprintf "failed to read file: %s" filename)
;;

(* function to write `contents` to a file *)
let write_file filename contents =
  Lwt.catch
    (fun () ->
      Lwt_io.(with_file ~mode:Output filename) (fun oc ->
          Lwt_io.write_chars oc @@ Lwt_stream.of_string contents
          >>= fun () -> Lwt.return_ok ""))
    (function
      | _ -> Lwt.return_error @@ Printf.sprintf "failed to write file: %s" filename)
;;

(* function to read contents of a directory *)
let read_dir path =
  Lwt_result.bind
    (Lwt_result.ok (Lwt_unix.opendir path))
    (fun hndl ->
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
      read_dir_entry hndl [] >>= fun dirlist -> Lwt.return_ok @@ String.concat dirlist)
;;
