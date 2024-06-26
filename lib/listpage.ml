let width = 690

let draw_course (x, y, width, height) (course : Course.t) =
  let open Raylib in
  draw_rectangle x y width height Color.skyblue;

  let text = course.name in
  let text_size = measure_text text 20 in
  let text_x = x + ((width - text_size) / 2) in
  let text_y = y + ((height - 20) / 2) in

  draw_text text text_x text_y 20 Color.darkblue

let main_loop lst_of_courses =
  let open Raylib in
  begin_drawing ();
  clear_background Color.raywhite;

  let header_text = "Courses Recommended For You" in
  let text_size = Raylib.measure_text header_text 20 in
  let text_x = ((width - text_size) / 2) + 50 in
  let text_y = 20 in
  let save_courses_text_x =
    text_x + ((300 - measure_text "Save courses" 20) / 2)
  in
  let rectangle_x = 550 in
  let rectangle_y = 300 in
  let rectangle_z = 50 in
  draw_rectangle text_x rectangle_x rectangle_y rectangle_z Color.skyblue;
  Raylib.draw_text header_text text_x text_y 20 Raylib.Color.black;
  Raylib.draw_text "Save courses" save_courses_text_x 570 20 Raylib.Color.black;

  let course_height = 100 in
  let spacing = 20 in
  let header_space = 50 in

  List.iteri
    (fun i course ->
      let x = (get_screen_width () - 800) / 2 in
      let y = text_y + header_space + (i * (course_height + spacing)) in
      draw_course (x, y, 800, course_height) course)
    lst_of_courses;

  end_drawing ()

let start_list_page (lst_of_courses : Schedule.t) =
  main_loop lst_of_courses
