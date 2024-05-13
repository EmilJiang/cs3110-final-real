type course = {
  name : string;
  description : string;
}
(**[course] is a course. *)

val output : string -> Pytypes.pyobject -> Pytypes.pyobject * string
(**[output] is the scheduling response using the OpenAI API, taking in [text]
   and [lst] *)

val count_characters : string -> int
(**[count_characters] is the number of characters in string [s] *)

val add_to_array : string array -> string -> string array
(**[add_to_array] adds [elem] to [arr]. *)

val round_up_division : int -> int -> int
(**[round_up_division] rounds up the decimal with [dividend] and [divisor] *)

val is_printable : char -> bool
(**[is_printable] is whether or not [c] is printable. *)

val remove_newlines_and_spaces : string -> string
(**[remove_newlines_and_spaces] is a string without new lines and spaces in [s] *)

val sub_array : 'a array -> int -> int -> 'a array
(**[sub_array] is a subarray of [arr] that begins at [start_idx] and ends at
   [end_idx]. *)

val calculate_total_y_offset : string array -> int -> int
(**[calculate_total_y_offset] is the y-offset that [arr] requires with
   [line_spacing]. *)

val find_starting_index : string array -> int -> int -> int
(**[find_starting_index] finds the starting index of [arr] with [max_offset] and
   [line_spacing]. *)

val start : unit -> course list
(**[start] begins the chat page and returns a course list.*)

val contains_numbering : string -> int -> bool
(**[contains_numbering] is whether or not [s] has 1, 2, 3, and 4. *)

val parse_courses : string -> course list
(**[parse_courses] generates a course list out of the [input] string. *)

val read_file_as_string : string -> string
(**[read_file_as_string] takes in a file name and returns the string of that
   file read*)
