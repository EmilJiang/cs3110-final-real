type t = {
  name : string;
  description : string;
}

let empty_course = { name = ""; description = "" }

let edit_course_name (course : t) (new_name : string) = 
  { name = new_name; description = course.description }

let edit_course_description (course : t) (new_description : string) = 
  { name = course.name; description = new_description }

let compare_course (course1 : t) (course2: t) = course1.name == course2.name 
&& course1.description == course2.description

let print_course course = course.name ^ ", " ^ course.description