type t = {
  x : int;
  y : int;
  width : int;
  height : int;
}

val default_button : t
val new_button : int -> int -> int -> int -> t
val button_x : t -> int
val button_y : t -> int
val button_width : t -> int
val button_height : t -> int
val compare_button : t -> t -> bool
val button_to_string : t -> string
