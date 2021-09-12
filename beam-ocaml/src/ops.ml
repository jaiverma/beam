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

let main () =
  read_file "/mnt/d/tmp/abc.txt"
  >>= fun contents ->
  print_endline contents;
  Lwt.return_unit
  >>= fun () ->
  let contents = "hello world\n" in
  write_file "/mnt/d/tmp/def.txt" contents
  >>= fun () ->
  read_file "/mnt/d/tmp/def.txt"
  >>= fun contents ->
  print_endline contents;
  Lwt.return_unit
;;

let () = Lwt_main.run @@ main ()
