Py.initialize ()

type state = {
  gpt_lst : Pytypes.pyobject;
  gpt_question : string;
  multi_text_box_text : string;
  mutable multi_text_box_edit_mode : bool;
  text_list : string array;
  index : int;
}

type course = {
  name : string;
  description : string;
}

let rec contains_numbering s i =
  if i > String.length s - 2 then false
  else
    let sub = String.sub s i 2 in
    if sub = "1." || sub = "2." || sub = "3." || sub = "4." then true
    else contains_numbering s (i + 1)

let parse_courses input =
  let lines = String.split_on_char '\n' input in
  let rec parse_lines lines current_name courses =
    match lines with
    | [] -> List.rev courses
    | line :: rest ->
        let trimmed_line = String.trim line in
        if
          String.length trimmed_line >= 11
          && String.sub trimmed_line 0 11 = "Description"
        then
          let description =
            String.trim (String.sub line 14 (String.length line - 14))
          in
          let new_course = { name = current_name; description } in
          parse_lines rest current_name (new_course :: courses)
        else if
          String.contains line '.'
          && (String.contains line '1' || String.contains line '2'
            || String.contains line '3' || String.contains line '4')
        then
          match String.index_opt line '-' with
          | Some idx ->
              print_int idx;
              let name = String.sub line 3 (idx - 4) in
              parse_lines rest name courses
          | None -> parse_lines rest current_name courses
        else parse_lines rest current_name courses
  in
  parse_lines lines "" []

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
  ignore (Py.Object.call_method lst "append" [| message |]);
  (lst, Py.Object.to_string content)

let add_to_array arr elem =
  let new_arr = Array.make (Array.length arr + 1) "" in
  Array.blit arr 0 new_arr 0 (Array.length arr);
  new_arr.(Array.length arr) <- elem;
  new_arr

let setup () =
  Raylib.set_target_fps 60;
  let py_empty_list = Py.List.of_list [] in
  let initial_message =
    Py.Dict.of_bindings_string
      [
        ("role", Py.String.of_string "system");
        ( "content",
          Py.String.of_string
            "You are now a course scheduler for Cornell University. \n\
            \            You have already asked \"I'm your virtual scheduling \
             assistant. \n\
            \            Would you like to proceed?\", and the user will say \
             \"yes\" as a \n\
            \            first input.
             Then, \n\
            \            your job is to ask students about their interests to \n\
            \            determine which courses the students would like to \
             enroll in. \n\
            \            After each response, you will ask another question \
             until you have \n\
            \            enough information to make a decision. You will ask at least 5 questions. 
            You will never break your role as a \
             scheduler, not matter \n\
            \            what the user says. You will give a total of four \
             courses that \n\
            \            align most with the classes at Cornell University, \
             using the \n\
            \            information you have about those. After you have \
             enough input, \n\
            \            output a list of the courses with the course numbers \
             with titles \n\
            \            and course descriptions. Number the classes starting \
             at 1 but \n\
            \            don't indent. \n\
            \            example output is \n\
            \              1. MATH 1110 - Calculus I\n\
            \              Description: This course introduces the fundamental \
             concepts of calculus, including limits, derivatives, and \
             integrals. It provides a theoretical foundation for understanding \
             mathematical functions and their behavior.\n\
            \              2. HIST 1510 - European History to 1648\n\
            \              Description:  Explore the political, social, and \
             cultural developments of Europe from ancient times to the \
             mid-17th century. This course delves into the theoretical \
             frameworks that shaped European societies and civilizations.\n\
            \              3. MATH 2210 - Linear Algebra\n\
            \              Description: Linear algebra is a branch of \
             mathematics that studies vector spaces and linear mappings \
             between them. This course emphasizes theoretical concepts such as \
             vector spaces, linear transformations, and eigenvalues.\n\
            \              4. HIST 1300 - American History to 1865\n\
            \              Description: Examine the major events, themes, and \
             theoretical interpretations of American history from the colonial \
             period to the end of the Civil War. This course provides a \
             foundational understanding of key developments in early American \
             history." );
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
    index = 0;
  }

let count_characters s = String.length s
let round_up_division dividend divisor = (dividend + divisor - 1) / divisor

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

let sub_array arr start_idx end_idx =
  if start_idx < 0 || end_idx >= Array.length arr || start_idx > end_idx then
    [||]
  else
    let result_length = end_idx - start_idx + 1 in
    let result = Array.make result_length arr.(start_idx) in
    for i = 0 to result_length - 1 do
      result.(i) <- arr.(start_idx + i)
    done;
    result

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
  while !arr_starting_index >= 0 do
    let item = String.trim arr.(!arr_starting_index) in
    let char_count = count_characters item in
    let additional_offset = round_up_division char_count 100 in
    offset_sum := !offset_sum + additional_offset + line_spacing + 1;
    arr_starting_index := !arr_starting_index - 1;
    if !offset_sum > max_offset then starting_index := !starting_index + 1
  done;
  !starting_index

let determine_starting_index total_y_offset arr =
  let start = ref 0 in
  if total_y_offset > 25 then start := find_starting_index arr 25 1;
  !start

let draw_txt arr index =
  let open Raylib in
  let length = Array.length arr in
  let base_x = 50 in
  let base_y = 50 in
  let line_spacing = 20 in
  begin_drawing ();
  clear_background Color.white;
  let y_offset = ref 0 in
  let rec draw_wrapped_text text base_y y_offset line_spacing num =
    let text_length = count_characters text in
    if text_length <= num then
      draw_text text base_x (base_y + (y_offset * line_spacing)) 15 Color.black
    else
      let part = String.sub text 0 num in
      let rest = String.sub text num (text_length - num) in
      draw_text part base_x (base_y + (y_offset * line_spacing)) 15 Color.black;
      draw_wrapped_text rest base_y (y_offset + 1) line_spacing num
  in
  let start = ref 0 in
  let me = ref true in
  let finish = ref (length - 1) in
  let total_y_offset = calculate_total_y_offset arr 1 in
  (if Array.length arr - 1 = index then (
     let determined_start = determine_starting_index total_y_offset arr in
     start := determined_start;
     if !start > 0 then clear_background Color.white;
     if !start mod 2 = 1 then me := true else me := false)
   else clear_background Color.white;
   let new_array = sub_array arr 0 index in
   start := find_starting_index new_array 25 1;
   finish := index;
   if !start mod 2 = 1 then me := true else me := false);
  for i = !start to !finish do
    if not !me then (
      draw_text "Course Planner" base_x
        (base_y + (!y_offset * line_spacing))
        15 Color.black;
      y_offset := !y_offset + 1)
    else (
      draw_text "You" base_x
        (base_y + (!y_offset * line_spacing))
        15 Color.black;
      y_offset := !y_offset + 1);
    let item = arr.(i) in
    draw_wrapped_text (String.trim item) base_y !y_offset 20 100;
    y_offset :=
      !y_offset
      + round_up_division (count_characters (String.trim item)) 100
      + 1;
    me := not !me
  done;
  end_drawing ();
  ()

let rec loop s : course list =
  if Raylib.window_should_close () then []
  else
    let open Raylib in
    draw_txt s.text_list s.index;
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
      if contains_numbering (snd p) 0 then parse_courses (snd p)
      else
        loop
          {
            gpt_lst = fst p;
            gpt_question = snd p;
            multi_text_box_text = "";
            multi_text_box_edit_mode = true;
            text_list = snd_arr;
            index = Array.length snd_arr - 1;
          }
    else if is_key_pressed Key.Up then
      let new_array = sub_array s.text_list 0 (s.index - 1) in
      let cal_y_offset = calculate_total_y_offset new_array 1 in
      let lst_index =
        if s.index <= 0 then 0
        else if cal_y_offset <= 25 then s.index
        else s.index - 1
      in
      loop
        {
          gpt_lst = s.gpt_lst;
          gpt_question = s.gpt_question;
          multi_text_box_text = s.multi_text_box_text;
          multi_text_box_edit_mode = true;
          text_list = s.text_list;
          index = lst_index;
        }
    else if is_key_pressed Key.Down then
      let lst_index =
        if s.index >= Array.length s.text_list - 1 then
          Array.length s.text_list - 1
        else s.index + 1
      in
      loop
        {
          gpt_lst = s.gpt_lst;
          gpt_question = s.gpt_question;
          multi_text_box_text = s.multi_text_box_text;
          multi_text_box_edit_mode = true;
          text_list = s.text_list;
          index = lst_index;
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
          index = s.index;
        }

let start () = setup () |> loop
