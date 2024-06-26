let draw_home_page frame_count =
  let open Raylib in
  let text1 = "The" in
  let text2 = "BIG RED" in
  let text3 = "Planner" in
  let base_font_size = 60 in
  let text1_width = measure_text text1 base_font_size in
  let text3_width = measure_text text3 base_font_size in
  let x1 = (get_screen_width () - text1_width) / 2 in
  let x3 = (get_screen_width () - text3_width) / 2 in
  let y1 = get_screen_height () / 5 in
  let y3 = get_screen_height () / 2 in

  let cycle = frame_count / 30 mod 3 in
  let colors = [| Color.red; Color.black; Color.maroon |] in
  let animated_color = colors.(cycle) in
  let size = 60 in
  let color = Color.red in
  draw_text text1 x1 y1 size color;
  let x2 = (get_screen_width () - measure_text text2 60) / 2 in
  let y2 = ((y1 + y3) / 2) + 20 in
  draw_text text2 x2 y2 size animated_color;
  draw_text text3 x3 y3 size color;

  let button_width = 100 in
  let button_height = 40 in
  let button_x = (get_screen_width () - button_width) / 2 in
  let button_y = y3 + base_font_size + 20 in
  draw_rectangle button_x button_y button_width button_height Color.darkgray;
  draw_text "Start" (button_x + 20) (button_y + 10) 20 Color.white;
  let window_width = get_screen_width () in
  let window_height = get_screen_height () in
  let frame_width = 5.0 in
  let frame_color = Color.red in
  draw_rectangle_lines_ex
    (Rectangle.create 0. 0. (float_of_int window_width) (float_of_int 5))
    frame_width frame_color;

  draw_rectangle_lines_ex
    (Rectangle.create 0.
       (float_of_int (window_height - 5))
       (float_of_int window_width)
       frame_width)
    frame_width frame_color;

  draw_rectangle_lines_ex
    (Rectangle.create 0. 0. frame_width (float_of_int window_height))
    frame_width frame_color;

  draw_rectangle_lines_ex
    (Rectangle.create
       (float_of_int (window_width - 5))
       0. frame_width
       (float_of_int window_height))
    frame_width frame_color

let main_loop () =
  let open Raylib in
  begin_drawing ();

  clear_background Color.raywhite;

  draw_home_page 4;

  end_drawing ()

let start_homepage () = main_loop ()
