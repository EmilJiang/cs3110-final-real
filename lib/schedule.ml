type t = Course.t list

let empty_schedule = []
let add_course (schedule : t) (course : Course.t) : t = course :: schedule

let rec remove_course (schedule : t) (course : Course.t) : t =
  match schedule with
  | [] -> []
  | h :: t ->
      if h == course then remove_course t course
      else h :: remove_course t course

let rec in_schedule (schedule : t) (course : Course.t) =
  match schedule with
  | [] -> false
  | h :: t ->
      if h.name == course.name && h.description == course.description then true
      else in_schedule t course

let rec schedule_to_string_helper (schedule : t) =
  match schedule with
  | [] -> ""
  | [ h ] -> h.name
  | h :: t -> h.name ^ ", " ^ schedule_to_string_helper t

let schedule_to_string schedule = "[" ^ schedule_to_string_helper schedule ^ "]"
