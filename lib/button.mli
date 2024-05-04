(**Button type t represents a clickable button
    *)
type t = {
  x : int;
  y : int;
  width : int;
  height : int;
}

(**[default button] returns a default button*)
val default_button : t
(**[new_button] returns a new button based off size parameters*)
val new_button : int -> int -> int -> int -> t
(**[button_x] returns x value of button*)
val button_x : t -> int
(**[button_y] returns y value of button*)
val button_y : t -> int
(**[button_width] returns width value of button*)
val button_width : t -> int
(**[button_height] returns height value of button*)
val button_height : t -> int
(**[compare_button] compares two buttons and returns true if they are the same*)
val compare_button : t -> t -> bool

(**[button_to_string] converts a button to string*)
val button_to_string : t -> string
