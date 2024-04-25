let setup () =
  let open Raylib in
  set_target_fps 5

let draw_loading_text count =
  let open Raylib in
  let base_text = "Loading" in
  let dots = String.make (count mod 4) '.' in
  let full_text = base_text ^ dots in
  let font = load_font_ex "bin/fluffy.ttf" 30 None in
  let font_size = 50 in
  let text_width = measure_text full_text font_size in
  let x = (get_screen_width () - text_width) / 2 in
  let y = (get_screen_height () - font_size) / 2 in
  let position = Vector2.create (float_of_int x) (float_of_int y) in
  let size = 50. in
  let spacing = 1. in
  let color = Color.gray in
  draw_text_ex font full_text position size spacing color

let main_loop () =
  let open Raylib in
  setup ();

  let counter = ref 0 in

  while counter <= ref 10 do
    begin_drawing ();

    clear_background Color.raywhite;

    draw_loading_text !counter;

    end_drawing ();

    incr counter
  done

let start_loading_page () = main_loop ()
