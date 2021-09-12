open OUnit2
open OUnitLwt
open Lwt.Infix

let tests =
  "test suite for ops"
  >::: [ "write_file"
         >:: lwt_wrapper (fun _ ->
                 let filename = "/tmp/abc.txt" in
                 let contents = "hello world!" in
                 Beam.Ops.write_file filename contents
                 >>= fun ret ->
                 match ret with
                 | Ok _ ->
                   Beam.Ops.read_file filename
                   >>= fun ret ->
                   (match ret with
                   | Ok data -> Lwt.return @@ assert_equal data contents
                   | Error e -> assert_failure e)
                 | Error e -> assert_failure e)
       ]
;;

let _ = run_test_tt_main tests
