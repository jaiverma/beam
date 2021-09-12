open OUnit2
open OUnitLwt
open Lwt.Infix

let tests =
  "test suite for ops"
  >::: [ "write_file"
         >:: lwt_wrapper (fun _ ->
                 let filename = "/tmp/abc.txt" in
                 let contents = "hello world!" in
                 Ops.write_file filename contents
                 >>= fun () ->
                 Ops.read_file filename
                 >>= fun data -> Lwt.return @@ assert_equal data contents)
       ]
;;

let _ = run_test_tt_main tests
