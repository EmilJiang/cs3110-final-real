let setup () =
  let open Raylib in
  init_window 800 600 "The Big Red Planner";
  set_target_fps 60

let draw_home_page frame_count =
  let open Raylib in
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

  let cycle = frame_count / 60 mod 3 in
  let animated_size = base_font_size + (cycle * 5) in
  let colors = [| Color.red; Color.black; Color.maroon |] in
  let animated_color = colors.(cycle) in

  draw_text text1 x1 y1 base_font_size Color.red;
  draw_text text2
    ((get_screen_width () - measure_text text2 animated_size) / 2)
    (((y1 + y3) / 2) + 20 - (animated_size / 2))
    animated_size animated_color;
  draw_text text3 x3 y3 base_font_size Color.red

let main_loop () =
  let open Raylib in
  setup ();

  let frame_count = ref 0 in

  while not (window_should_close ()) do
    begin_drawing ();
    clear_background Color.raywhite;
    draw_home_page !frame_count;
    end_drawing ();

    incr frame_count
  done;

  close_window ()

let () = main_loop ()
