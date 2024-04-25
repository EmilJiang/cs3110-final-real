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
  Py.Module.set openai "api_key"
    (Py.String.of_string "");
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

let draw_txt arr =
  let open Raylib in
  let length = Array.length arr in
  let base_x = 50 in
  let base_y = 50 in
  let line_spacing = 20 in
  begin_drawing ();
  let y_offset = ref 0 in
  let me = ref false in
  (* let rec draw_wrapped_text text base_y = let text_length = count_characters
     text in if text_length <= 100 then draw_text text base_x base_y 20
     Color.black else let part = String.sub text 0 100 in let rest = String.sub
     text 100 (text_length - 100) in draw_text part base_x base_y 20
     Color.black; draw_wrapped_text rest (base_y + line_spacing) in *)
  for i = 0 to length - 1 do
    print_int !y_offset;
    if not !me then (
      draw_text "course planner" base_x
        (base_y + (!y_offset * line_spacing))
        15 Color.white;
      y_offset := !y_offset+1)
    else (
      draw_text "You" base_x
        (base_y + (!y_offset * line_spacing))
        15 Color.white;
        y_offset := !y_offset+1);
    let item = arr.(i) in
    print_int !y_offset;
    print_endline"";
    draw_text item base_x (base_y + (!y_offset * line_spacing)) 15 Color.white;
    (* y_offset := !y_offset + (count_characters item / 100) + 2 *)
    y_offset := !y_offset+2;
    me := not !me
  done;
  end_drawing ();
  ()

let rec loop s =
  if Raylib.window_should_close () then Raylib.close_window ()
  else
    let open Raylib in
    draw_txt s.text_list;
    if is_key_pressed Key.Enter then (
      let p = output s.multi_text_box_text s.gpt_lst in
      let new_arr = add_to_array s.text_list s.multi_text_box_text in
      let snd_arr = add_to_array new_arr (snd p) in
      loop
        {
          gpt_lst = fst p;
          gpt_question = snd p;
          multi_text_box_text = "";
          multi_text_box_edit_mode = true;
          text_list = snd_arr;
        })
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

let () = setup () |> loop
