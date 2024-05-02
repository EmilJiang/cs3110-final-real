type t = {
  name : string;
  description : string;
}

val empty_course : t

val edit_course_name : t -> string -> t

val edit_course_description : t -> string -> t

val compare_course : t -> t -> bool

val print_course : t -> string