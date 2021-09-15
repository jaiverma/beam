let () =
  let sock = Beam.Server_tcp.create_socket () in
  let serve = Beam.Server_tcp.create_server sock in
  Lwt_main.run @@ serve ()
;;
