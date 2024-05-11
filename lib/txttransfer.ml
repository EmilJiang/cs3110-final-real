let save_to_file filename content =
  let oc = open_out filename in
  output_string oc content;
  close_out oc

(* (let a = "This is the content to be saved to the file." in let filename =
   "courses.txt" save_to_file filename a *)
