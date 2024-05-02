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
         ( "output - short text" >:: fun _ ->
           let text = "Hi" in
           let output1 = output text in
           let py_empty_list = Py.List.of_list [] in
           let str = snd (output1 py_empty_list) in
           let length = String.length str in
           let boo = length > 0 in
           assert_equal boo true );
         ( "output - Long text" >:: fun _ ->
           let text =
             "The cozy seating arrangements, with their plush cushions and \
              warm lighting, beckon visitors to settle in and unwind. It's a \
              place where time seems to slow down, and worries melt away, as \
              patrons sip their coffee and lose themselves in conversation or \
              contemplation."
           in
           let output1 = output text in
           let py_empty_list = Py.List.of_list [] in
           let str = snd (output1 py_empty_list) in
           let length = String.length str in
           let boo = length > 0 in
           assert_equal boo true );
         ( "output - empty text" >:: fun _ ->
           let text = "0" in
           let output1 = output text in
           let py_empty_list = Py.List.of_list [] in
           let str = snd (output1 py_empty_list) in
           let length = String.length str in
           let boo = length > 0 in
           assert_equal boo true );
         ( "Empty course" >:: fun _ ->
           assert_equal ", " (Course.print_course Course.empty_course) );
         ( "Edit course name" >:: fun _ ->
           assert_equal "course_name, "
             (Course.print_course
                (Course.edit_course_name Course.empty_course "course_name")) );
         ( "Add empty course name" >:: fun _ ->
           assert_equal ", "
             (Course.print_course
                (Course.edit_course_name Course.empty_course "")) );
         ( "Edit course description" >:: fun _ ->
           assert_equal ", course_description"
             (Course.print_course
                (Course.edit_course_description Course.empty_course
                   "course_description")) );
         ( "Add empty course description" >:: fun _ ->
           assert_equal ", "
             (Course.print_course
                (Course.edit_course_description Course.empty_course "")) );
         ( "Compare empty courses" >:: fun _ ->
           assert_equal true
             (Course.compare_course Course.empty_course Course.empty_course) );
         ( "Compare non-empty same course names" >:: fun _ ->
           assert_equal true
             (Course.compare_course
                (Course.edit_course_name Course.empty_course "course_name")
                (Course.edit_course_name Course.empty_course "course_name")) );
         ( "Compare non-empty same course descriptions" >:: fun _ ->
           assert_equal true
             (Course.compare_course
                (Course.edit_course_description Course.empty_course
                   "course_name")
                (Course.edit_course_description Course.empty_course
                   "course_name")) );
         ( "Compare different courses" >:: fun _ ->
           assert_equal false
             (Course.compare_course
                (Course.edit_course_description Course.empty_course "course1")
                (Course.edit_course_description Course.empty_course "course2"))
         );
         ( "add to array - add one elem" >:: fun _ ->
           let arr = add_to_array (Array.make 0 "") "Hi" in
           let length = Array.length arr in
           let boo = length > 0 in
           assert_equal boo true );
         ( "add to array - add two elem" >:: fun _ ->
           let arr = add_to_array (Array.make 0 "") "Hi" in
           let arr2 = add_to_array arr "Hi" in
           let length = Array.length arr2 in
           let boo = length = 2 in
           assert_equal boo true );
         ( "round up division - 1/2" >:: fun _ ->
           let num = 3 in
           let denom = 6 in
           let sol = round_up_division num denom in
           let ans = 1 in
           assert_equal sol ans );
         ( "round up division - 0 num" >:: fun _ ->
           let num = 0 in
           let denom = 6 in
           let sol = round_up_division num denom in
           let ans = 0 in
           assert_equal sol ans );
         ( "round up division - rand num" >:: fun _ ->
           let num = 18 in
           let denom = 7 in
           let sol = round_up_division num denom in
           let ans = 3 in
           assert_equal sol ans );
         ( "is printable - random letter" >:: fun _ ->
           let char = 'c' in
           let boo = is_printable char in
           assert_equal boo true );
         ( "is printable - random character" >:: fun _ ->
           let char = ')' in
           let boo = is_printable char in
           assert_equal boo true );
       ]

let _ = run_test_tt_main tests
