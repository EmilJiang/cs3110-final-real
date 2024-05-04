type t = Course.t list

val empty_schedule : t
val add_course : t -> Course.t -> t
val remove_course : t -> Course.t -> t
val in_schedule : t -> Course.t -> bool
val schedule_to_string : t -> string
val compare_schedule : t -> t -> bool
