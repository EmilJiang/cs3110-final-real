Final_project_test.Pages.start_pages ()
(* 
type course = {
  name : string;
  description : string;
}

let print_string_list strings = List.iter print_endline strings

let parse_courses input =
  let lines = String.split_on_char '\n' input in
  let rec parse_lines lines current_name courses =
    match lines with
    | [] -> List.rev courses
    | line :: rest ->
        if String.sub (String.trim line) 0 11 = "Description" then
          let description =
            String.trim (String.sub line 12 (String.length line - 12))
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
              let name = String.sub line 3 (idx - 4) in
              parse_lines rest name courses
          | None -> parse_lines rest current_name courses
        else parse_lines rest current_name courses
  in
  parse_lines lines "" []

let () =
  let input =
    "1. MATH 1110 - Calculus I\n\
     Description: This course introduces the fundamental concepts of calculus, \
     including limits, derivatives, and integrals. It provides a theoretical \
     foundation for understanding mathematical functions and their behavior.\n\
     2. HIST 1510 - European History to 1648\n\
     Description:  Explore the political, social, and cultural developments of \
     Europe from ancient times to the mid-17th century. This course delves \
     into the theoretical frameworks that shaped European societies and \
     civilizations.\n\
     3. MATH 2210 - Linear Algebra\n\
     Description: Linear algebra is a branch of mathematics that studies \
     vector spaces and linear mappings between them. This course emphasizes \
     theoretical concepts such as vector spaces, linear transformations, and \
     eigenvalues.\n\
     4. HIST 1300 - American History to 1865\n\
     Description: Examine the major events, themes, and theoretical \
     interpretations of American history from the colonial period to the end \
     of the Civil War. This course provides a foundational understanding of \
     key developments in early American history."
  in
  let courses = parse_courses input in
  print_int (List.length courses);
  List.iter
    (fun c ->
      Printf.printf "Course Name: %s\nDescription: %s\n\n" c.name c.description)
    courses *)
