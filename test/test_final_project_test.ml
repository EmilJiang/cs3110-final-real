open OUnit2
open Final_project_test

let test1 ctxt =
  let text = "Short text" in
  let max_width = 200 in
  let wrapped_text = wrap_text text max_width in
  assert_equal ~ctxt wrapped_text "Short text"

let test2 ctxt = assert_equal ~ctxt
let tests = [ "test1" >:: test1; "test2" >:: test2 ]
let test_suite = "interval test suite" >::: tests
let _ = run_test_tt_main test_suite
