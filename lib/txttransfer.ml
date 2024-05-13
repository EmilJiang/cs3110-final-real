let save_to_file filename content =
  let oc =
    open_out_gen [ Open_wronly; Open_append; Open_creat ] 0o666 filename
  in
  output_string oc content;
  close_out oc

let rec save_courses (lst : Schedule.t) =
  match lst with
  | [] -> ()
  | h :: t ->
      save_to_file "courses.txt" h.name;
      save_to_file "courses.txt" "\n";
      save_to_file "courses.txt" h.description;
      save_to_file "courses.txt" "\n\n";
      save_courses t
