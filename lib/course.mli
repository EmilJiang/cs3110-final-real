type t = {
  name : string;
  description : string;
}
(**[t] represents a course.*)

val create_new_course : string -> string -> t
(**[create_new_course] creates a new course with [name] and [description]. *)

val empty_course : t
(**[empty_course] is the empty course. *)

val edit_course_name : t -> string -> t
(**[edit_course_name] changes the name of [course] to [name]. *)

val edit_course_description : t -> string -> t
(**[edit_course_description] changes the description of [course] to
   [description]*)

val compare_course : t -> t -> bool
(**[compare_course] determines whether or not [course1] and [course2] are equal,
   based on the name and description of the course.*)

val print_course : t -> string
(**[print_course] changes [course] into a string. *)
