let main () = Lwt_io.printf "hello world\n"
let () = Lwt_main.run @@ main ()
