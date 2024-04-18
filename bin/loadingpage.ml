let setup () =
  let open Raylib in
  init_window 800 600 "Loading Animation";
  set_target_fps 2

let draw_loading_text count =
  let open Raylib in
  let base_text = "Loading" in
  let dots = String.make (count mod 4) '.' in
  let full_text = base_text ^ dots in
  let font_size = 50 in
  let text_width = measure_text full_text font_size in
  let x = (get_screen_width () - text_width) / 2 in
  let y = (get_screen_height () - font_size) / 2 in
  draw_text full_text x y font_size Color.black

let main_loop () =
  let open Raylib in
  setup ();

  let counter = ref 10 in

  while not (window_should_close ()) do
    begin_drawing ();
    clear_background Color.raywhite;

    draw_loading_text !counter;

    end_drawing ();

    incr counter
  done;

  close_window ()

let () = main_loop ()
