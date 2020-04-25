open Yojson.Basic.Util
open Library
open State
open UI

let chunks s = String.split_on_char ' ' s

let check_file input =
  if (List.length input < 2) then
    (ANSITerminal.(print_string [white;on_red] "No filename provided");print_newline (); false) else 
    (ANSITerminal.(print_string [white;on_blue] ("Loading library " ^ List.nth input 1));print_newline (); true)

let init_state = {library = {lib_name = ""; artists = []}; start = true; 
                  current_artist = ""; current_album = ""; current_track = "";
                  queue = []}

let rec main state () =
  if (state.start) then (ANSITerminal.(print_string [blue;on_white;Bold]
                                         "\n\n\t\t\tWelcome to OCAML: The Ocaml Comprehensive Audio & Music Library!\n";
                                       print_newline ();
                                       print_endline "Run 'help' to get started!\n";));
  ANSITerminal.(print_string [red;on_white] (state.library.lib_name));
  ANSITerminal.(print_string [red;on_white;Bold] " > ";print_string [] " ");
  State.set_start false state;
  let input = chunks (read_line ()) in
  begin match (List.hd input) with
    | exception _ -> ANSITerminal.(print_string [white;on_red] "Something went wrong!")
    | "load" -> if (check_file input) then set_library (UI.load_library (List.nth input 1)) state; main state ()
    | "list" -> UI.list state input; main state ()
    | "help" -> UI.print_help ()
    | "restart" -> UI.restart state; main state ()
    | "quit" -> ANSITerminal.(print_string [white;on_red] "Goodbye!");print_newline ();exit 0
    | other -> ANSITerminal.(print_string [white;on_red] ("Unknown command " ^ other));print_newline ()
  end;
  main state ()

let () = main init_state ()