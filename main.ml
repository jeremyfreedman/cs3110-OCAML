open Yojson.Basic.Util
open Library
open State
open UI

let chunks s = String.split_on_char ' ' s

let check_file file input =
  if (List.length input < 2) then
    if (file) then
      (ANSITerminal.(print_string [white;on_red] "No filename provided");
       print_newline (); false) else 
      (ANSITerminal.(print_string [white;on_red] "No directory provided");
       print_newline (); false) else
    (ANSITerminal.(print_string [white;on_blue]
                     ("Loading library " ^ List.nth input 1));
     print_newline (); true)

let init_state = {library = {lib_name = ""; artists = []}; start = true; 
                  current_artist = ""; current_album = ""; current_track = "";
                  view_queue = []; path_queue = []}

let rec main state () =
  match state.start with 
  | true ->
    (ANSITerminal.(print_string [blue;on_white;Bold]
                     "\n\n\t\t\t
                     Welcome to OCAML: 
                     The Ocaml Comprehensive Audio & Music Library!\n";
                   print_newline ();
                   print_endline "Run 'help' to get started!\n";));
    State.wipe_queue (); State.set_start false state; main state ()
  | false ->
    ANSITerminal.(print_string [red;on_white] (state.library.lib_name));
    ANSITerminal.(print_string [red;on_white;Bold] " > ";print_string [] " ");
    ignore (State.write_queue state);
    let input = chunks (read_line ()) in
    begin match String.lowercase_ascii (List.hd input) with
      | exception _ ->
        ANSITerminal.(print_string [white;on_red] "Something went wrong!")
      | "help" -> UI.print_help ()
      | "load" -> if (check_file true input) then
          set_library (UI.load_library (List.nth input 1)) state
      | "loaddir" -> if (check_file false input) then
          set_library (UI.load_dir (List.nth input 1)) state
      | "mklibrary" -> 
        ANSITerminal.(print_string [white;on_red] "Unimplemented");
        print_newline ()
      | "libinfo" -> UI.print_libinfo state
      | "list" -> UI.print_list state input
      | "view" -> UI.print_view state input
      | "play" -> UI.play state input
      | "queue" -> UI.print_queue state
      | "skip" -> UI.skip state
      | "restart" -> UI.restart state
      | "quit" -> State.wipe_queue (); 
        ANSITerminal.(print_string [white;on_red] "Goodbye!");print_newline ();
        exit 0
      | other ->
        ANSITerminal.(print_string [white;on_red] ("Unknown command " ^ other));
        print_newline ()
    end;
    main state ()

let () = main init_state ()