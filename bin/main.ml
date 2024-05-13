(* Final_project_test.Pages.start_pages () *)

type course = {
  name : string;
  description : string;
}

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

(* Function to print course details *)
let print_course c =
  Printf.printf "%s%s" c.name c.description

(* Test input string *)
let s =
  "1. CS 2800 - blah \n\
             \ Description: meow \n\
             \ \n\
             \              2. CS 3110 - blah \n\
             \ Description: hi"

(* Parsing the input into course list *)
let courses = parse_courses s

(* Print each course *)
let () = List.iter print_course courses
