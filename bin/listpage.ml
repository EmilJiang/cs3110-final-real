let (courses : Course.t list) =
  [
    {
      name = "CS 2800 - Discrete Mathematics";
      description =
        "Covers the mathematics that underlies most of computer science. \
         Topics include mathematical induction; logical proof; propositional \
         and predicate calculus; combinatorics and discrete mathematics; some \
         basic elements of basic probability theory; basic number theory; \
         sets, functions, and relations; graphs; and finite-state machines. \
         These topics are discussed in the context of applications to many \
         areas of computer science, such as the RSA cryptosystem and web \
         searching.";
    };
    {
      name = "CS 3110 - Functional Programming";
      description =
        "Advanced programming course that emphasizes functional programming \
         techniques and data structures. Programming topics include recursive \
         and higher-order procedures, models of programming language \
         evaluation and compilation, type systems, and polymorphism. Data \
         structures and algorithms covered include graph algorithms, balanced \
         trees, memory heaps, and garbage collection. Also covers techniques \
         for analyzing program performance and correctness.";
    };
    {
      name = "CS 4820 - Intro to Algo";
      description =
        "Develops techniques used in the design and analysis of algorithms, \
         with an emphasis on problems arising in computing applications. \
         Example applications are drawn from systems and networks, artificial \
         intelligence, computer vision, data mining, and computational \
         biology. This course covers four major algorithm design techniques \
         (greedy algorithms, divide-and-conquer, dynamic programming, and \
         network flow), undecidability and NP-completeness, and algorithmic \
         techniques for intractable problems (including identification of \
         structured special cases , approximation algorithms, local search \
         heuristics, and online algorithms).\n\n\
        \      ";
    };
    { name = "CS SOmething"; description = "something" };
  ]

(**let height = 560*)
let width = 690

let draw_course (x, y, width, height) (course : Course.t) =
  let open Raylib in
  draw_rectangle x y width height Color.skyblue;

  let text = course.name in
  let text_size = measure_text text 20 in
  let text_x = x + ((width - text_size) / 2) in
  let text_y = y + ((height - 20) / 2) in

  draw_text text text_x text_y 20 Color.darkblue

let main_loop lst_of_courses =
  let open Raylib in
  begin_drawing ();
  clear_background Color.raywhite;

  let header_text = "Courses Recommended For You" in
  let text_size = Raylib.measure_text header_text 20 in
  let text_x = ((width - text_size) / 2) + 50 in
  let text_y = 20 in

  Raylib.draw_text header_text text_x text_y 20 Raylib.Color.black;

  let course_height = 100 in
  let spacing = 20 in
  let header_space = 50 in

  List.iteri
    (fun i course ->
      let x = (get_screen_width () - 800) / 2 in
      let y = text_y + header_space + (i * (course_height + spacing)) in
      draw_course (x, y, 800, course_height) course)
    lst_of_courses;

  end_drawing ()

let start_list_page lst_of_courses = main_loop lst_of_courses
