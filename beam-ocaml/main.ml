open Core

let () =
  let msg = Beam.Dispatch.READ_DIR "/tmp/abc.txt" in
  let msg_json = Beam.Dispatch.cmd_to_yojson msg in
  List.map ~f:Yojson.Safe.Util.to_string @@ Yojson.Safe.Util.to_list msg_json
  |> List.iter ~f:(fun x -> Lwt_io.printl x |> Lwt.ignore_result);
  Lwt_io.printl @@ Beam.Dispatch.show_cmd msg |> Lwt.ignore_result;
  let sock = Beam.Server_tcp.create_socket () in
  let serve = Beam.Server_tcp.create_server sock in
  Lwt_main.run @@ serve ()
;;
