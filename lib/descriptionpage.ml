open Raylib
let width = 800
let height = 600

let wrap_text text max_width =
  let rec split_lines words line cur_width lines =
    match words with
    | [] -> List.rev (List.rev line :: lines)
    | word :: rest ->
        let word_width = measure_text word 23 in
        if cur_width + word_width <= max_width then
          split_lines rest (word :: line) (cur_width + word_width) lines
        else split_lines (word :: rest) [] 0 (List.rev line :: lines)
  in
  let words = String.split_on_char ' ' text in
  let lines = split_lines words [] 0 [] in
  String.concat "\n" (List.map (String.concat " ") lines)

let draw_course (x, y, width, height) (course : Question.course) =
  draw_rectangle x y width height Color.skyblue;

  let name_text = course.name in
  let name_text_size = measure_text name_text 36 in
  let name_text_x = x + ((width - name_text_size) / 2) in
  let name_text_y = y + 10 in
  draw_text name_text name_text_x name_text_y 36 Color.darkblue;

  let description_text = course.description in
  let max_text_width = width - 20 in
  let wrapped_text = wrap_text description_text max_text_width in
  print_endline "HIHIHIHI";
  print_endline wrapped_text;
  draw_text wrapped_text (x + 10) (name_text_y + 50) 20 Color.black

let main_loop course =
  begin_drawing ();
  clear_background Color.raywhite;

  let course_height = 400 in

  let x = (width - 800) / 2 in
  let y = 50 in
  draw_course (x, y, 800, course_height) course;

  let button_width = 250 in
  let button_height = 40 in
  let button_x = (width - button_width) / 2 in
  let button_y = height - 80 in
  draw_rectangle button_x button_y button_width button_height Color.darkgray;
  let button_text = " < Go back to course list" in
  let text_size = measure_text button_text 20 in
  let text_x = button_x + ((button_width - text_size) / 2) - 2 in
  let text_y = button_y + ((button_height - 20) / 2) in
  draw_text button_text text_x text_y 20 Color.white;

  end_drawing ()

let start_description_page (course_list:Question.course) = main_loop course_list
