open Yojson.Basic.Util
open Library
open State
open UI

let chunks s = 
  List.filter (fun x -> x <> "") (String.split_on_char ' ' s)

let check_file file input =
  match input with
  | h::[] -> if (file) then
      (ANSITerminal.(print_string [white;on_red] "No filename provided");
       print_newline (); false) else 
      (ANSITerminal.(print_string [white;on_red] "No directory provided");
       print_newline (); false)
  | h::file::_ ->  (ANSITerminal.(print_string [white;on_blue]
                                    ("Loading library " ^ file));
                    print_newline (); true)
  | _ -> failwith "Malformed input"


let init_state = {library = {lib_name = ""; artists = []}; start = true; 
                  current_artist = ""; current_album = ""; current_track = "";
                  view_queue = []; path_queue = []; liq_io = State.init_liq ()}

let rec run state =
  match state.start with 
  | true ->
    (ANSITerminal.(print_string [blue;on_white;Bold]
                     "\n\n\t\t\t
                     Welcome to OCAML: 
                     The Ocaml Comprehensive Audio & Music Library!\n";
                   print_newline ();
                   print_endline "Run 'help' to get started!\n";));
    State.wipe_queue (); State.set_start false state;
    Unix.chmod "play.sh" 0o755; run state
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
          set_library (UI.load_library input) state
      | "loaddir" -> if (check_file false input) then
          set_library (UI.load_dir input) state
      | "libinfo" -> UI.print_libinfo state
      | "list" -> UI.print_list state input
      | "view" -> UI.print_view state input
      | "nowplaying" -> UI.now_playing state
      | "play" -> UI.play state input
      | "queue" -> UI.print_queue state
      | "clear" -> UI.clear state
      | "skip" -> UI.skip state
      | "resume" -> State.reload_liq state
      | "stop" -> UI.stop state
      | "restart" -> UI.restart state
      | "quit" -> State.wipe_queue (); State.stop_liq state;
        ANSITerminal.(print_string [white;on_red] "Goodbye!");print_newline ();
        exit 0
      | other ->
        ANSITerminal.(print_string [white;on_red] ("Unknown command " ^ other));
        print_newline ()
    end;
    run state