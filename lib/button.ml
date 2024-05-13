type t = {
  x : int;
  y : int;
  width : int;
  height : int;
}

let default_button = { x = 0; y = 70; width = 800; height = 100 }
let new_button x y width height = { x; y; width; height }
let button_x button = button.x
let button_y button = button.y
let button_width button = button.width
let button_height button = button.height

let button_to_string button =
  string_of_int button.x ^ ", " ^ string_of_int button.y ^ ", "
  ^ string_of_int button.width ^ ", "
  ^ string_of_int button.height

let compare_button button1 button2 =
  button1.x == button2.x && button1.y == button2.y
  && button1.width == button2.width
  && button1.height == button2.height
