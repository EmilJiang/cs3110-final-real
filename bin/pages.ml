open Raylib

type game_screen =
  | Home
  | Chat
  | Loading
  | List
  | Description of int

type button = {
  x : int;
  y : int;
  width : int;
  height : int;
}

let (courses : Course.t list) =
  [
    {
      name = "CS 2800 - Discrete Mathematics";
      description =
        "Covers the mathematics that underlies most of computer science. \
         Topics include mathematical induction; logical proof; propositional \
         and predicate calculus; combinatorics and discrete mathematics; some \
         basic elements of basic probability theory; basic number theory; \
         sets, functions, and relations; graphs; and finite-state machines. \
         These topics are discussed in the context of applications to many \
         areas of computer science, such as the RSA cryptosystem and web \
         searching.";
    };
    {
      name = "CS 3110 - Functional Programming";
      description =
        "Advanced programming course that emphasizes functional programming \
         techniques and data structures. Programming topics include recursive \
         and higher-order procedures, models of programming language \
         evaluation and compilation, type systems, and polymorphism. Data \
         structures and algorithms covered include graph algorithms, balanced \
         trees, memory heaps, and garbage collection. Also covers techniques \
         for analyzing program performance and correctness.";
    };
    {
      name = "CS 4820 - Intro to Algo";
      description =
        "Develops techniques used in the design and analysis of algorithms, \
         with an emphasis on problems arising in computing applications. \
         Example applications are drawn from systems and networks, artificial \
         intelligence, computer vision, data mining, and computational \
         biology. This course covers four major algorithm design techniques \
         (greedy algorithms, divide-and-conquer, dynamic programming, and \
         network flow), undecidability and NP-completeness, and algorithmic \
         techniques for intractable problems (including identification of \
         structured special cases , approximation algorithms, local search \
         heuristics, and online algorithms).\n\n\
        \      ";
    };
    { name = "CS SOmething"; description = "something" };
  ]

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
      let button_one = { x = 0; y = 70; width = 800; height = 100 } in
      let button_two = { x = 0; y = 190; width = 800; height = 100 } in
      let button_three = { x = 0; y = 310; width = 800; height = 100 } in
      let button_four = { x = 0; y = 430; width = 800; height = 100 } in
      Listpage.start_list_page courses;
      if is_mouse_over_button button_one && is_gesture_detected Gesture.Tap then
        Description 0
      else if is_mouse_over_button button_two && is_gesture_detected Gesture.Tap
      then Description 1
      else if
        is_mouse_over_button button_three && is_gesture_detected Gesture.Tap
      then Description 2
      else if
        is_mouse_over_button button_four && is_gesture_detected Gesture.Tap
      then Description 3
      else List
  | Description i ->
      Descriptionpage.start_description_page (List.nth courses i);
      if is_key_pressed Key.Enter || is_gesture_detected Gesture.Tap then List
      else Description i

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
