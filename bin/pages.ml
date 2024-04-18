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
      begin_drawing ();
      clear_background Color.raywhite;
      draw_text "Home screen" 20 20 40 Color.black;
      end_drawing ();
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
      begin_drawing ();
      clear_background Color.raywhite;
      draw_text "Loading screen" 20 20 40 Color.black;
      end_drawing ();
      if is_key_pressed Key.Enter || is_gesture_detected Gesture.Tap then List
      else Loading
  | List ->
      Listpage.start_list_page ();
      if is_key_pressed Key.Enter || is_gesture_detected Gesture.Tap then
        Description
      else List
  | Description ->
      begin_drawing ();
      clear_background Color.raywhite;
      draw_text "Description screen" 20 20 40 Color.black;
      end_drawing ();
      if is_key_pressed Key.Enter || is_gesture_detected Gesture.Tap then List
      else Description

let rec loop current_screen =
  if not (window_should_close ()) then update_and_render current_screen |> loop
  else ()

let setup () =
  init_window 800 450 "Application";
  set_target_fps 60;
  Home

let () =
  setup () |> loop;
  close_window ()
