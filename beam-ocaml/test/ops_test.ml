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
                 >>= function
                 | Ok _ ->
                   Beam.Ops.read_file filename
                   >>= (function
                   | Ok data -> Lwt.return @@ assert_equal data contents
                   | Error e -> assert_failure e)
                 | Error e -> assert_failure e)
       ; "read_file_fail"
         >:: lwt_wrapper (fun _ ->
                 let filename = "/abc" in
                 Beam.Ops.read_file filename
                 >>= function
                 | Ok _ -> assert_failure "this should've failed"
                 | Error e -> Lwt.return @@ assert_equal "failed to read file: /abc" e)
       ; "write_file_fail"
         >:: lwt_wrapper (fun _ ->
                 let filename = "/abc/def" in
                 let contents = "hello world!" in
                 Beam.Ops.write_file filename contents
                 >>= function
                 | Ok _ -> assert_failure "this should've failed"
                 | Error e ->
                   Lwt.return @@ assert_equal "failed to write file: /abc/def" e)
       ; "read_dir_fail"
         >:: lwt_wrapper (fun _ ->
                 let path = "/abc" in
                 Beam.Ops.read_dir path
                 >>= function
                 | Ok _ -> assert_failure "this should've failed"
                 | Error e -> Lwt.return @@ assert_equal "failed to read dir: /abc" e)
       ]
;;

let _ = run_test_tt_main tests
