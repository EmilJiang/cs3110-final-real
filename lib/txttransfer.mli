val save_to_file : string -> string -> unit
(**[save_to_file filename content] saves a string, content, to the file,
   filename*)

val save_courses : Schedule.t -> unit
(**[save_courses lst] saves all the courses in lst to a file named courses.txt*)
