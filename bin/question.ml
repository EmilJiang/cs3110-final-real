
Py.initialize ();
type state = {
  gpt_lst : Pytypes.pyobject;
  gpt_question : string;
  multi_text_box_text : string;
  mutable multi_text_box_edit_mode : bool;
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

let setup () =
  Raylib.init_window 800 800 "raylib [core] example - basic window";
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
  }

let rec loop s =
  if Raylib.window_should_close () then Raylib.close_window ()
  else
    let open Raylib in
    begin_drawing ();
    clear_background Color.black;
    if is_key_pressed Key.Enter then
      let p = output s.multi_text_box_text s.gpt_lst in
      end_drawing ();
      loop
        {
          gpt_lst = fst p;
          gpt_question = snd p;
          multi_text_box_text = "";
          multi_text_box_edit_mode = true;
        }
    else (
      draw_text s.gpt_question 100 100 10 Color.white;
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
      end_drawing ();
      loop
        {
          gpt_lst = s.gpt_lst;
          gpt_question = s.gpt_question;
          multi_text_box_text;
          multi_text_box_edit_mode = true;
        })

let () = setup () |> loop
