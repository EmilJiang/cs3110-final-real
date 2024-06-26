open Raylib
open Txttransfer

type game_screen =
  | Home
  | Chat
  | Loading of Schedule.t
  | List of Schedule.t
  | Description of (int * Schedule.t)

let is_mouse_over_button (button : Button.t) =
  let mouse_position = get_mouse_position () in
  let mouse_x = Raylib.Vector2.x mouse_position in
  let mouse_y = Raylib.Vector2.y mouse_position in
  mouse_x >= float (Button.button_x button)
  && mouse_x <= float (Button.button_x button + Button.button_width button)
  && mouse_y >= float (Button.button_y button)
  && mouse_y <= float (Button.button_y button + Button.button_height button)

let update_and_render current_screen =
  match current_screen with
  | Home ->
      let button_width = 100 in
      let button_height = 40 in
      let button_x = (get_screen_width () - button_width) / 2 in
      let button_y = (get_screen_height () / 2) + 60 + 20 in
      Homepage.start_homepage ();
      if
        is_key_pressed Key.Enter
        || is_gesture_detected Gesture.Tap
           && is_mouse_over_button
                (Button.new_button button_x button_y button_width button_height)
      then (
        Raylib.clear_background Raylib.Color.white;
        Chat)
      else Home
  | Chat ->
      let (lst : Schedule.t) = Question.start () in
      Loading lst
  | Loading lst ->
      let start_time = Raylib.get_time () in
      let rec game_loop start_time =
        if not (window_should_close ()) then begin
          let elapsed_time = Raylib.get_time () -. start_time in
          if elapsed_time >= 1.0 then List lst
          else begin
            Loadingpage.start_loading_page ();
            game_loop start_time
          end
        end
        else List lst
      in
      game_loop start_time
  | List lst ->
      assert (Schedule.in_schedule lst (List.nth lst 1));
      if List.length lst = 5 then
        Loading (Schedule.remove_course lst (List.nth lst 4))
      else
        let save_file_button =
          Button.new_button
            (((690 - Raylib.measure_text "Courses Recommended For You" 20) / 2)
            + 50)
            550 300 50
        in
        let button_one = Button.default_button in
        let button_two = Button.new_button 0 190 800 100 in
        let button_three = Button.new_button 0 310 800 100 in
        let button_four = Button.new_button 0 430 800 100 in
        assert (Button.compare_button button_one button_two = false);
        Listpage.start_list_page lst;
        if is_gesture_detected Gesture.Tap && is_mouse_over_button button_one
        then Description (0, lst)
        else if
          is_gesture_detected Gesture.Tap && is_mouse_over_button button_two
        then Description (1, lst)
        else if
          is_gesture_detected Gesture.Tap && is_mouse_over_button button_three
        then Description (2, lst)
        else if
          is_gesture_detected Gesture.Tap && is_mouse_over_button button_four
        then Description (3, lst)
        else if
          is_gesture_detected Gesture.Tap
          && is_mouse_over_button save_file_button
        then
          let _ = save_courses lst in
          List lst
        else List lst
  | Description (i, lst) ->
      let button = Button.new_button 275 520 250 40 in
      Descriptionpage.start_description_page (List.nth lst i);
      if
        is_key_pressed Key.Enter
        || (is_gesture_detected Gesture.Tap && is_mouse_over_button button)
      then List lst
      else Description (i, lst)

let rec loop current_screen =
  if not (window_should_close ()) then update_and_render current_screen |> loop
  else ()

let setup () =
  init_window 800 600 "The Big Red Planner";
  set_target_fps 60;
  Home

let start_pages () =
  setup () |> loop;
  close_window ()
