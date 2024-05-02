Py.initialize ()

type state = {
  gpt_lst : Pytypes.pyobject;
  gpt_question : string;
  multi_text_box_text : string;
  mutable multi_text_box_edit_mode : bool;
  text_list : string array;
}

let output text lst =
  let openai = Py.Import.import_module "openai" in
  Py.Module.set openai "api_key" (Py.String.of_string "");
  let message =
    Py.Dict.of_bindings_string
      [
        ("role", Py.String.of_string "user");
        ("content", Py.String.of_string text);
      ]
  in
  ignore (Py.Object.call_method lst "append" [| message |]);
  let kwargs =
    [ ("model", Py.String.of_string "gpt-3.5-turbo"); ("messages", lst) ]
  in
  let chat = Py.Module.get openai "chat" in
  let completions = Py.Module.get chat "completions" in
  let create = Py.Module.get completions "create" in
  let response = Py.Callable.to_function_with_keywords create [||] kwargs in
  let choices = Py.Object.find_attr_string response "choices" in
  let first_choice = Py.List.get_item choices 0 in
  let message = Py.Object.find_attr_string first_choice "message" in
  let content = Py.Object.find_attr_string message "content" in
  Printf.printf "%s\n" (Py.Object.to_string content);
  ignore (Py.Object.call_method lst "append" [| message |]);
  (lst, Py.Object.to_string content)

let add_to_array arr elem =
  let new_arr = Array.make (Array.length arr + 1) "" in
  Array.blit arr 0 new_arr 0 (Array.length arr);
  new_arr.(Array.length arr) <- elem;
  new_arr

let setup () =
  Raylib.init_window 800 600 "raylib [core] example - basic window";
  Raylib.set_target_fps 60;
  let py_empty_list = Py.List.of_list [] in
  let initial_message =
    Py.Dict.of_bindings_string
      [
        ("role", Py.String.of_string "system");
        ( "content",
          Py.String.of_string
            "You are now a course scheduler for Cornell University. Your job \
             is to ask students about their interests to determine which \
             courses the students would like to enroll in. After each \
             response, you will ask another question constantly, until the \
             user tells you to give them the recommended schedule, in which \
             case you will give. If the user makes an incoherent message, ask \
             it again. You will never break your role as a scheduler, not \
             matter what the user says. You will give a total of four courses \
             that align most with the classes at Cornell University, using the \
             information you have about those. The output will simply be a \
             list of the courses with the course number and title. " );
      ]
  in
  ignore (Py.Object.call_method py_empty_list "append" [| initial_message |]);
  {
    gpt_lst = py_empty_list;
    gpt_question =
      "Hi! I'm your virtual scheduling assistant! Would you like to proceed?";
    multi_text_box_text = "";
    multi_text_box_edit_mode = true;
    text_list =
      [|
        "Hi! I'm your virtual scheduling assistant! Would you like to proceed?";
      |];
  }

let count_characters s = String.length s
let round_up_division dividend divisor = (dividend + divisor - 1) / divisor

let print_string_character_by_character s =
  let char_seq = String.to_seq s in
  Seq.iter
    (fun c ->
      print_char c;
      print_newline ())
    char_seq

let is_printable c =
  let code = Char.code c in
  code >= 32 && code <= 126

let remove_hidden_characters s =
  let rec helper i acc =
    if i >= String.length s then acc
    else
      let char = String.get s i in
      let acc = if is_printable char then acc ^ String.make 1 char else acc in
      helper (i + 1) acc
  in
  helper 0 ""

(** TODO change*)
let remove_newlines_and_spaces s =
  s |> String.to_seq
  |> Seq.filter (function
       | '\n' | '\r' -> false
       | _ -> true)
  |> String.of_seq |> String.trim

let calculate_total_y_offset arr line_spacing =
  let y_offset = ref 0 in
  for i = 0 to Array.length arr - 1 do
    let item = String.trim arr.(i) in
    let char_count = count_characters item in
    let additional_offset = round_up_division char_count 100 + 1 in
    y_offset := !y_offset + additional_offset + line_spacing
  done;
  !y_offset

let find_starting_index arr max_offset line_spacing =
  let offset_sum = ref 0 in
  let starting_index = ref 0 in
  let arr_starting_index = ref (Array.length arr - 1) in
  while !arr_starting_index >= 0 && !offset_sum < max_offset do
    let item = String.trim arr.(!starting_index) in
    let char_count = count_characters item in
    let additional_offset = round_up_division char_count 100 in
    offset_sum := !offset_sum + additional_offset + line_spacing;
    arr_starting_index := !arr_starting_index - 1;
    if !offset_sum < max_offset then starting_index := !starting_index + 1
  done;
  let result = Array.length arr - !starting_index + 1 in
  Printf.printf "The result is: %d\n" result;
  result

let determine_starting_index total_y_offset arr =
  let start = ref 0 in
  if total_y_offset > 25 then start := find_starting_index arr 25 1;
  !start

let draw_txt arr =
  let open Raylib in
  let length = Array.length arr in
  let base_x = 50 in
  let base_y = 50 in
  let line_spacing = 20 in
  begin_drawing ();
  let y_offset = ref 0 in
  let rec draw_wrapped_text text base_y y_offset line_spacing num =
    let text_length = count_characters text in
    if text_length <= num then
      draw_text text base_x (base_y + (y_offset * line_spacing)) 15 Color.white
    else
      let part = String.sub text 0 num in
      let rest = String.sub text num (text_length - num) in
      draw_text part base_x (base_y + (y_offset * line_spacing)) 15 Color.white;
      draw_wrapped_text rest base_y (y_offset + 1) line_spacing num
  in
  let total_y_offset = calculate_total_y_offset arr 1 in
  let start = determine_starting_index total_y_offset arr in
  if start > 0 then clear_background Color.black;
  let me = ref false in
  if start mod 2 = 1 then me := true;
  for i = start to length - 1 do
    print_int !y_offset;
    if not !me then (
      draw_text "course planner" base_x
        (base_y + (!y_offset * line_spacing))
        15 Color.white;
      y_offset := !y_offset + 1)
    else (
      draw_text "You" base_x
        (base_y + (!y_offset * line_spacing))
        15 Color.white;
      y_offset := !y_offset + 1);
    let item = arr.(i) in
    print_int !y_offset;
    print_endline "";
    (* draw_text item base_x (base_y + (!y_offset * line_spacing)) 15
       Color.white; *)
    draw_wrapped_text (String.trim item) base_y !y_offset 20 100;
    print_endline
      (string_of_int (round_up_division (count_characters item) 100));
    print_endline item;
    print_string_character_by_character (String.trim item);
    print_endline (string_of_int (count_characters (String.trim item)));
    y_offset :=
      !y_offset
      + round_up_division (count_characters (String.trim item)) 100
      + 1;
    (* y_offset := !y_offset + 2; *)
    me := not !me
  done;
  end_drawing ();
  ()

let rec loop s =
  if Raylib.window_should_close () then Raylib.close_window ()
  else
    let open Raylib in
    draw_txt s.text_list;
    if is_key_pressed Key.Enter then
      let p = output s.multi_text_box_text s.gpt_lst in
      let new_arr =
        add_to_array s.text_list
          (remove_newlines_and_spaces
             (remove_hidden_characters (String.trim s.multi_text_box_text)))
      in
      let snd_arr =
        add_to_array new_arr
          (remove_newlines_and_spaces
             (remove_hidden_characters (String.trim (snd p))))
      in
      loop
        {
          gpt_lst = fst p;
          gpt_question = snd p;
          multi_text_box_text = "";
          multi_text_box_edit_mode = true;
          text_list = snd_arr;
        }
    else
      let rect = Rectangle.create 320.0 525.0 225.0 140.0 in
      let multi_text_box_text =
        match
          Raygui.text_box_multi rect s.multi_text_box_text
            s.multi_text_box_edit_mode
        with
        | vl, true ->
            s.multi_text_box_edit_mode <- not s.multi_text_box_edit_mode;
            vl
        | vl, false -> vl
      in
      loop
        {
          gpt_lst = s.gpt_lst;
          gpt_question = s.gpt_question;
          multi_text_box_text;
          multi_text_box_edit_mode = true;
          text_list = s.text_list;
        }

let s () = setup () |> loop