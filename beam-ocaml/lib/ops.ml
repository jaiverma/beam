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
  (* `Lwt_unix.opendir` may fail if the directory doesn't exist. Use `Lwt.catch` to catch
   * the exception and return a `Result` instead *)
  Lwt.catch
    (fun () ->
      let hndl = Lwt_unix.opendir path in
      let rec read_dir_entry hndl acc =
        (* Lwt_unix.readdir raises an `End_of_file` exception if the directory handler
         * reaches EOF. Handle this by catching the exception and returning `None`.
         * In a successful call, we return `Some (dirname)` *)
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
      hndl
      >>= fun hndl ->
      read_dir_entry hndl [] >>= fun dirlist -> Lwt.return_ok @@ String.concat dirlist)
    (function
      | _ -> Lwt.return_error @@ Printf.sprintf "failed to read dir: %s" path)
;;
