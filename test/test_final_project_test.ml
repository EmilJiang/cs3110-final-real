open OUnit2
open Final_project_test
open Question

let tests =
  "Descriptionpage test suite"
  >::: [
         ( "count_characters - Count characters in short text" >:: fun _ ->
           let text = "Short text" in
           let wrapped_text = count_characters text in
           let equivalent_counters = 10 in
           assert_equal wrapped_text equivalent_counters );
         ( "count_characters - Empty text returns 0" >:: fun _ ->
           let text = "" in
           let counted_characters = count_characters text in
           let equivalent_counters = 0 in
           assert_equal counted_characters equivalent_counters );
         ( "output - Empty text returns 0" >:: fun _ ->
           let text = "Hi" in
           let output1 = output text in
           let py_empty_list = Py.List.of_list [] in
           let str = snd (output1 py_empty_list) in
           let length = String.length str in
           let boo = length > 0 in
           assert_equal boo true );
       ]

let _ = run_test_tt_main tests
