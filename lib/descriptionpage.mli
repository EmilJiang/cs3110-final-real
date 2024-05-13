val start_description_page : Course.t -> unit
(**[start_description_page] draws the description page with Raylib with the
   given [course_list]*)

val wrap_text : string -> int -> string
(**[wrap_text] changes [text] into a string with [max_width] characters. *)
