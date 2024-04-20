let setup () =
  let open Raylib in
  set_target_fps 60

let draw_home_page frame_count =
  let open Raylib in
  let font = load_font_ex "sugarcreamfont.otf" 20 None in
  let text1 = "The" in
  let text2 = "BIG RED" in
  let text3 = "Planner" in
  let base_font_size = 40 in
  let text1_width = measure_text text1 base_font_size in
  let text3_width = measure_text text3 base_font_size in
  let x1 = (get_screen_width () - text1_width) / 2 in
  let x3 = (get_screen_width () - text3_width) / 2 in
  let y1 = get_screen_height () / 5 in
  let y3 = get_screen_height () / 2 in

  let cycle = frame_count / 30 mod 3 in
  let animated_size = base_font_size + (cycle * 5) in
  let colors = [| Color.red; Color.black; Color.maroon |] in
  let animated_color = colors.(cycle) in

  draw_text_ex font text1
    (Vector2.create (float_of_int x1) (float_of_int y1))
    Color.red;
  draw_text_ex font text2
    ((get_screen_width () - measure_text text2 animated_size) / 2)
    (((y1 + y3) / 2) + 20 - (animated_size / 2))
    animated_size animated_color;
  draw_text text3 x3 y3 base_font_size Color.red;

  let button_width = 100 in
  let button_height = 40 in
  let button_x = (get_screen_width () - button_width) / 2 in
  let button_y = y3 + base_font_size + 20 in
  draw_rectangle button_x button_y button_width button_height Color.darkgray;
  draw_text "Start" (button_x + 20) (button_y + 10) 20 Color.white

let main_loop () =
  let open Raylib in
  setup ();
  let frame_count = ref 0 in

  begin_drawing ();
  clear_background Color.raywhite;
  draw_home_page !frame_count;
  end_drawing ();

  incr frame_count

let start_homepage () = main_loop ()
