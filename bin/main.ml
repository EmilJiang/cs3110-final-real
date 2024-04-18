(* Py.initialize () *)

(* let output text = let openai = Py.Import.import_module "openai" in
   Py.Module.set openai "api_key" (Py.String.of_string ""); let py_empty_list =
   Py.List.of_list [] in let s = text in let message =
   Py.Dict.of_bindings_string [ ("role", Py.String.of_string "user");
   ("content", Py.String.of_string s); ] in ignore (Py.Object.call_method
   py_empty_list "append" [| message |]); let kwargs = [ ("model",
   Py.String.of_string "gpt-3.5-turbo"); ("messages", py_empty_list); ] in let
   chat = Py.Module.get openai "chat" in let completions = Py.Module.get chat
   "completions" in let create = Py.Module.get completions "create" in let
   response = Py.Callable.to_function_with_keywords create [||] kwargs in let
   choices = Py.Object.find_attr_string response "choices" in let first_choice =
   Py.List.get_item choices 0 in let message = Py.Object.find_attr_string
   first_choice "message" in let content = Py.Object.find_attr_string message
   "content" in ignore (Py.Object.call_method py_empty_list "append" [| message
   |]); Py.Object.to_string content in () *)

(* let output1 text = Py.initialize (); let openai = Py.Import.import_module
   "openai" in Py.Module.set openai "api_key" (Py.String.of_string ""); let
   py_empty_list = Py.List.of_list [] in let s = text in let message =
   Py.Dict.of_bindings_string [ ("role", Py.String.of_string "user");
   ("content", Py.String.of_string s); ] in ignore (Py.Object.call_method
   py_empty_list "append" [| message |]); let kwargs = [ ("model",
   Py.String.of_string "gpt-3.5-turbo"); ("messages", py_empty_list); ] in let
   chat = Py.Module.get openai "chat" in let completions = Py.Module.get chat
   "completions" in let create = Py.Module.get completions "create" in let
   response = Py.Callable.to_function_with_keywords create [||] kwargs in let
   choices = Py.Object.find_attr_string response "choices" in let first_choice =
   Py.List.get_item choices 0 in let message = Py.Object.find_attr_string
   first_choice "message" in let content = Py.Object.find_attr_string message
   "content" in ignore (Py.Object.call_method py_empty_list "append" [| message
   |]); Py.Object.to_string content *)

(* This function takes in an input and returns an output to the answer through
   openai api. Requires the input to not have any new lines. This boundary only
   affects the terminal demo. Mutliline will be accessible with the integration
   of UI **)

let () =
  Py.initialize ();
  let openai = Py.Import.import_module "openai" in
  Py.Module.set openai "api_key" (Py.String.of_string "");
  let py_empty_list = Py.List.of_list [] in
  let initial_message =
    Py.Dict.of_bindings_string
      [
        ("role", Py.String.of_string "user");
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
  while true do
    print_endline "type in something for\n   chatgpt to answer: ";
    let s = read_line () in
    let message =
      Py.Dict.of_bindings_string
        [
          ("role", Py.String.of_string "user");
          ("content", Py.String.of_string s);
        ]
    in
    ignore (Py.Object.call_method py_empty_list "append" [| message |]);
    let kwargs =
      [
        ("model", Py.String.of_string "gpt-3.5-turbo");
        ("messages", py_empty_list);
      ]
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
    ignore (Py.Object.call_method py_empty_list "append" [| message |])
  done
