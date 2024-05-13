open OUnit2
open Final_project_test
open Question

(** Testing document is found in "Testing Document.pdf". *)

let tests =
  "Test suite"
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
         ( "parse_courses - empty list" >:: fun _ ->
           let lst = "" in
           let clist = parse_courses lst in
           let clist_length = List.length clist in
           let length = 0 in
           assert_equal clist_length length );
         ( "parse_courses - single list" >:: fun _ ->
           let lst = "1. CS3110 \nDescription : Functional programming" in
           let clist = parse_courses lst in
           let clist_length = List.length clist in
           let length = 1 in
           assert_equal clist_length length );
         ( "parse_courses - double list" >:: fun _ ->
           let lst =
             "1. CS3110 \n\
              Description : Functional programming \n\
             \ 2. CS2800 \n\
              Description : Discrete math"
           in
           let clist = parse_courses lst in
           let clist_length = List.length clist in
           let length = 2 in
           assert_equal clist_length length );
         ( "parse_courses - triple list" >:: fun _ ->
           let lst =
             "1. CS3110 \n\
              Description : Functional programming \n\
             \ 2. CS2800 \n\
              Description : Discrete math\n\
              3. PMA3540 \n\
              Description: Film and Video Production"
           in
           let clist = parse_courses lst in
           let clist_length = List.length clist in
           let length = 3 in
           assert_equal clist_length length );
         ( "parse_courses - quad list" >:: fun _ ->
           let lst =
             "1. CS3110 \n\
              Description : Functional programming \n\
             \ 2. CS2800 \n\
              Description : Discrete math\n\
              3. PMA3540 \n\
              Description: Film and Video Production\n\
              4. ENGRG1400\n\
              Description: Project Team"
           in
           let clist = parse_courses lst in
           let clist_length = List.length clist in
           let length = 4 in
           assert_equal clist_length length );
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
         ( "remove_newlines_and_spaces - no newlines or spaces" >:: fun _ ->
           let str = "string" in
           let str2 = remove_newlines_and_spaces str in
           assert_equal str str2 );
         ( "remove_newlines_and_spaces - w/ new lines" >:: fun _ ->
           let str = "string\nhi" in
           let str2 = remove_newlines_and_spaces str in
           let str3 = "stringhi" in
           assert_equal str2 str3 );
         ( "remove_newlines_and_spaces - double new lines" >:: fun _ ->
           let str = "string\n\n\n\n" in
           let str2 = remove_newlines_and_spaces str in
           let str3 = "string" in
           assert_equal str2 str3 );
         ( "subarr - empty arr" >:: fun _ ->
           let arr = Array.make 0 "" in
           let p1 = 0 in
           let p2 = 0 in
           let other_arr = sub_array arr p1 p2 in
           assert_equal arr other_arr );
         ( "subarr - single point arr" >:: fun _ ->
           let arr = add_to_array (Array.make 0 "") "Hi" in
           let p1 = 0 in
           let p2 = 0 in
           let other_arr = sub_array arr p1 p2 in
           assert_equal arr other_arr );
         ( "subarr - single point arr" >:: fun _ ->
           let arr = add_to_array (Array.make 0 "") "Hi" in
           let arr2 = Array.make 0 "" in
           let p1 = -1 in
           let p2 = -1 in
           let other_arr = sub_array arr p1 p2 in
           assert_equal arr2 other_arr );
         ( "subarr - double point arr" >:: fun _ ->
           let arr =
             add_to_array (add_to_array (Array.make 0 "") "Hi") "hello"
           in
           let arr2 = add_to_array (Array.make 0 "") "Hi" in
           let p1 = 0 in
           let p2 = 0 in
           let other_arr = sub_array arr p1 p2 in
           assert_equal arr2 other_arr );
         ( "subarr - double point arr" >:: fun _ ->
           let arr =
             add_to_array (add_to_array (Array.make 0 "") "Hi") "hello"
           in
           let arr2 = Array.make 0 "" in
           let p1 = 0 in
           let p2 = -1 in
           let other_arr = sub_array arr p1 p2 in
           assert_equal arr2 other_arr );
         ( "subarr - double point arr" >:: fun _ ->
           let arr =
             add_to_array (add_to_array (Array.make 0 "") "Hi") "hello"
           in
           let p1 = 0 in
           let p2 = 1 in
           let other_arr = sub_array arr p1 p2 in
           assert_equal arr other_arr );
         ( "calculate_total_y_offset - empty arr" >:: fun _ ->
           let arr = Array.make 0 "" in
           let p = 0 in
           let vali = 0 in
           let x = calculate_total_y_offset arr p in
           assert_equal vali x );
         ( "calculate_total_y_offset - 1 arr" >:: fun _ ->
           let arr = add_to_array (Array.make 0 "") "Hi" in
           let p = 0 in
           let vali = 2 in
           let x = calculate_total_y_offset arr p in
           assert_equal vali x );
         ( "calculate_total_y_offset - 2 arr" >:: fun _ ->
           let arr =
             add_to_array (add_to_array (Array.make 0 "") "Hi") "hello"
           in
           let p = 0 in
           let vali = 4 in
           let x = calculate_total_y_offset arr p in
           assert_equal vali x );
         ( "calculate_total_y_offset - 2 arr" >:: fun _ ->
           let arr =
             add_to_array (add_to_array (Array.make 0 "") "Hi") "hello"
           in
           let p = 1 in
           let vali = 6 in
           let x = calculate_total_y_offset arr p in
           assert_equal vali x );
         ( "calculate_total_y_offset - 3 arr" >:: fun _ ->
           let arr =
             add_to_array
               (add_to_array (add_to_array (Array.make 0 "") "Hi") "hello")
               "hi"
           in
           let p = 0 in
           let vali = 6 in
           let x = calculate_total_y_offset arr p in
           assert_equal vali x );
         ( "calculate_total_y_offset - 3 arr" >:: fun _ ->
           let arr =
             add_to_array
               (add_to_array (add_to_array (Array.make 0 "") "Hi") "hello")
               "hi"
           in
           let p = 1 in
           let vali = 9 in
           let x = calculate_total_y_offset arr p in
           assert_equal vali x );
         ( "find_starting_index - empty arr" >:: fun _ ->
           let arr = add_to_array (Array.make 0 "") "Hi" in
           let p = 0 in
           let t = 1 in
           let vali = 1 in
           let x = find_starting_index arr p t in
           assert_equal vali x );
         ( "find_starting_index - 1 arr" >:: fun _ ->
           let arr = Array.make 0 "" in
           let p = 0 in
           let t = 1 in
           let vali = 0 in
           let x = find_starting_index arr p t in
           assert_equal vali x );
         ( "find_starting_index - 3 arr" >:: fun _ ->
           let arr =
             add_to_array
               (add_to_array (add_to_array (Array.make 0 "") "Hi") "hello")
               "hi"
           in
           let p = 0 in
           let t = 3 in
           let vali = 3 in
           let x = find_starting_index arr p t in
           assert_equal vali x );
         ( "find_starting_index - 2 arr" >:: fun _ ->
           let arr =
             add_to_array (add_to_array (Array.make 0 "") "Hi") "hello"
           in
           let p = 0 in
           let t = 3 in
           let vali = 2 in
           let x = find_starting_index arr p t in
           assert_equal vali x );
         ( "find_starting_index - 2 arr" >:: fun _ ->
           let arr =
             add_to_array (add_to_array (Array.make 0 "") "Hi") "hello"
           in
           let p = 0 in
           let t = 1 in
           let vali = 2 in
           let x = find_starting_index arr p t in
           assert_equal vali x );
         ( "find_starting_index - 3 arr" >:: fun _ ->
           let arr =
             add_to_array
               (add_to_array (add_to_array (Array.make 0 "") "Hi") "hello")
               "hi"
           in
           let p = 2 in
           let t = 3 in
           let vali = 3 in
           let x = find_starting_index arr p t in
           assert_equal vali x );
         ( "find_starting_index - 3 arr" >:: fun _ ->
           let arr =
             add_to_array
               (add_to_array (add_to_array (Array.make 0 "") "Hi") "hello")
               "hi"
           in
           let p = 1 in
           let t = 1 in
           let vali = 3 in
           let x = find_starting_index arr p t in
           assert_equal vali x );
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
         ( "Default button" >:: fun _ ->
           assert_equal "0, 70, 800, 100"
             (Button.button_to_string Button.default_button) );
         ( "New button" >:: fun _ ->
           assert_equal "5, 5, 5, 5"
             (Button.button_to_string (Button.new_button 5 5 5 5)) );
         ( "Button x" >:: fun _ ->
           assert_equal 0 (Button.button_x Button.default_button) );
         ( "Button y" >:: fun _ ->
           assert_equal 70 (Button.button_y Button.default_button) );
         ( "Button width" >:: fun _ ->
           assert_equal 800 (Button.button_width Button.default_button) );
         ( "Button height" >:: fun _ ->
           assert_equal 100 (Button.button_height Button.default_button) );
         ( "Compare equal buttons" >:: fun _ ->
           assert_equal true
             (Button.compare_button Button.default_button Button.default_button)
         );
         ( "Compare different buttons" >:: fun _ ->
           assert_equal false
             (Button.compare_button Button.default_button
                (Button.new_button 5 5 5 5)) );
         ( "Empty schedule" >:: fun _ ->
           assert_equal "[]"
             (Schedule.schedule_to_string Schedule.empty_schedule) );
         ( "Add one course to schedule" >:: fun _ ->
           let course = Course.edit_course_name Course.empty_course "Course" in
           assert_equal "[Course]"
             (Schedule.schedule_to_string
                (Schedule.add_course Schedule.empty_schedule course)) );
         ( "Add multiple courses to schedule" >:: fun _ ->
           let course = Course.edit_course_name Course.empty_course "Course" in
           assert_equal "[Course, Course]"
             (Schedule.schedule_to_string
                (Schedule.add_course
                   (Schedule.add_course Schedule.empty_schedule course)
                   course)) );
         ( "Delete course from schedule" >:: fun _ ->
           let course = Course.edit_course_name Course.empty_course "Course" in
           let schedule = Schedule.add_course Schedule.empty_schedule course in
           assert_equal "[]"
             (Schedule.schedule_to_string
                (Schedule.remove_course schedule course)) );
         ( "Check course in schedule" >:: fun _ ->
           let course = Course.edit_course_name Course.empty_course "Course" in
           assert_equal true
             (Schedule.in_schedule
                (Schedule.add_course Schedule.empty_schedule course)
                course) );
         ( "Check course not in schedule" >:: fun _ ->
           let course = Course.edit_course_name Course.empty_course "Course" in
           assert_equal false
             (Schedule.in_schedule
                (Schedule.add_course Schedule.empty_schedule Course.empty_course)
                course) );
         ( "Compare same two schedules" >:: fun _ ->
           assert_equal true
             (Schedule.compare_schedule Schedule.empty_schedule
                Schedule.empty_schedule) );
         ( "Compare same two schedules with 1 course" >:: fun _ ->
           let course = Course.edit_course_name Course.empty_course "Course" in
           assert_equal true
             (Schedule.compare_schedule
                (Schedule.add_course Schedule.empty_schedule course)
                (Schedule.add_course Schedule.empty_schedule course)) );
         ( "Compare different two schedules w/ different # of courses"
         >:: fun _ ->
           assert_equal false
             (Schedule.compare_schedule
                (Schedule.add_course Schedule.empty_schedule Course.empty_course)
                Schedule.empty_schedule) );
         ( "Compare different two schedules w/ 1 course" >:: fun _ ->
           assert_equal false
             (Schedule.compare_schedule
                (Schedule.add_course Schedule.empty_schedule Course.empty_course)
                (Schedule.add_course Schedule.empty_schedule
                   (Course.edit_course_name Course.empty_course "Course"))) );
         ( "Compare same two schedules w/ 2 courses" >:: fun _ ->
           let course = Course.edit_course_name Course.empty_course "Course" in
           assert_equal true
             (Schedule.compare_schedule
                (Schedule.add_course
                   (Schedule.add_course Schedule.empty_schedule course)
                   course)
                (Schedule.add_course
                   (Schedule.add_course Schedule.empty_schedule
                      (Course.edit_course_name Course.empty_course "Course"))
                   course)) );
         ( "Compare different two schedules w/ 2 courses" >:: fun _ ->
           let course = Course.edit_course_name Course.empty_course "Course" in
           assert_equal false
             (Schedule.compare_schedule
                (Schedule.add_course
                   (Schedule.add_course Schedule.empty_schedule course)
                   (Course.edit_course_name Course.empty_course "CourseDiff"))
                (Schedule.add_course
                   (Schedule.add_course Schedule.empty_schedule
                      (Course.edit_course_name Course.empty_course "Course"))
                   course)) );
         ( "Test if an empty string is flagged as an output" >:: fun _ ->
           let s = "" in
           assert_equal false (Question.contains_numbering s 0) );
         ( "Test if a invalid output is flagged" >:: fun _ ->
           let s = "hi" in
           assert_equal false (Question.contains_numbering s 0) );
         ( "Test if a valid input(1.) is flagged" >:: fun _ ->
           let s = "1." in
           assert_equal true (Question.contains_numbering s 0) );
         ( "Test if a valid input(2.) is flagged" >:: fun _ ->
           let s = "2." in
           assert_equal true (Question.contains_numbering s 0) );
         ( "Test if a valid input(3.) is flagged" >:: fun _ ->
           let s = "3." in
           assert_equal true (Question.contains_numbering s 0) );
         ( "Test if a valid input(4.) is flagged" >:: fun _ ->
           let s = "4." in
           assert_equal true (Question.contains_numbering s 0) );
         ( "Test edge case only a number" >:: fun _ ->
           let s = "4" in
           assert_equal false (Question.contains_numbering s 0) );
         ( "Test edge case only a period" >:: fun _ ->
           let s = "." in
           assert_equal false (Question.contains_numbering s 0) );
         ( "Test edge case where number and period are seperated" >:: fun _ ->
           let s = "4ijfoadsipfjao." in
           assert_equal false (Question.contains_numbering s 0) );
         ( "Test parser" >:: fun _ ->
           let s = "1. CS 2800 - blah \n Description: meow" in
           let course = Question.parse_courses s in
           let real = [ { name = "CS 2800"; description = "meow" } ] in
           assert_equal true (compare_course_lists course real) );
         ( "Test parser" >:: fun _ ->
           let s =
             "1. CS 2800 - blah \n\
             \ Description: meow \n\
             \ \n\
             \              2. CS 3110 - blah \n\
             \ Description: hi"
           in
           let course = Question.parse_courses s in
           let real =
             [
               { name = "CS 2800"; description = "meow           " };
               { name = "CS 3110"; description = "hi" };
             ]
           in
           assert_equal false (compare_course_lists course real) );
       ]

let _ = run_test_tt_main tests
