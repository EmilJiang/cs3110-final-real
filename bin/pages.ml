open Raylib

type game_screen =
  | Home
  | Chat
  | Loading
  | List
  | Description

let rec update_and_render current_screen =
  match current_screen with
  | Home ->
      Homepage.start_homepage ();
      if is_key_pressed Key.Enter || is_gesture_detected Gesture.Tap then Chat
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
