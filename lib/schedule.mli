type t = Course.t list
(**[t] is a schedule. *)

val empty_schedule : t
(**[empty_schedule] is the empty schedule *)

val add_course : t -> Course.t -> t
(**[add_course] adds [course] to [schedule]. *)

val remove_course : t -> Course.t -> t
(**[remove_course] removes [course] from [schedule]. *)

val in_schedule : t -> Course.t -> bool
(**[in_schedule] is whether or not [course] is in [schedule]. *)

val schedule_to_string : t -> string
(**[schedule_to_string] is the string representation of [schedule]. *)

val compare_schedule : t -> t -> bool
(**[compare_schedule] is whether or not [schedule1] and [schedule2] are the same
   based on the course names and descriptions contained within them. *)
