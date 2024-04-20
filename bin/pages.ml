open Raylib

type game_screen =
  | Home
  | Chat
  | Loading
  | List
  | Description

type button = {
  x : int;
  y : int;
  width : int;
  height : int;
}

let is_mouse_over_button button =
  let mouse_position = get_mouse_position () in
  let mouse_x = Raylib.Vector2.x mouse_position in
  let mouse_y = Raylib.Vector2.y mouse_position in
  mouse_x >= float button.x
  && mouse_x <= float (button.x + button.width)
  && mouse_y >= float button.y
  && mouse_y <= float (button.y + button.height)

let rec update_and_render current_screen =
  match current_screen with
  | Home ->
      let button_width = 100 in
      let button_height = 40 in
      let button_x = (get_screen_width () - button_width) / 2 in
      let button_y = (get_screen_height () / 2) + 40 + 20 in
      Homepage.start_homepage ();
      if
        is_key_pressed Key.Enter
        || is_mouse_over_button
             {
               x = button_x;
               y = button_y;
               width = button_width;
               height = button_height;
             }
           && is_gesture_detected Gesture.Tap
      then Chat
      else Home
  | Chat ->
      begin_drawing ();
      clear_background Color.raywhite;
      draw_text "Chat screen" 20 20 40 Color.black;
      end_drawing ();
      if is_key_pressed Key.Enter || is_gesture_detected Gesture.Tap then
        Loading
      else Chat
  | Loading ->
      let start_time = Raylib.get_time () in
      let rec game_loop start_time =
        if not (window_should_close ()) then begin
          let elapsed_time = Raylib.get_time () -. start_time in
          if elapsed_time >= 1.0 then List
          else begin
            Loadingpage.start_loading_page ();
            game_loop start_time
          end
        end
        else List
      in
      game_loop start_time
  | List ->
      Listpage.start_list_page ();
      if is_key_pressed Key.Enter || is_gesture_detected Gesture.Tap then
        Description
      else List
  | Description ->
      Descriptionpage.start_description_page ();
      if is_key_pressed Key.Enter || is_gesture_detected Gesture.Tap then List
      else Description

let rec loop current_screen =
  if not (window_should_close ()) then update_and_render current_screen |> loop
  else ()

let setup () =
  init_window 800 600 "The Big Red Planner";
  set_target_fps 60;
  Home

let () =
  setup () |> loop;
  close_window ()
