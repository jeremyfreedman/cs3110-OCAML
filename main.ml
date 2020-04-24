open Yojson.Basic.Util
open Library
let print_help () = 
  ANSITerminal.(print_string [blue;Bold] "Available commands:";
                print_endline "\n\thelp\t\t\tPrints this page.";
                print_endline "\tload <filename>\t\tLoads a library from a OCAML-compatible JSON file.";
                print_endline "\tmklibrary <filename>\tCreates a new library with the given filename.";
                print_endline "\tlibinfo\t\t\tGives stats about the currently open library.";
                print_endline "\ttracks\t\t\tLists tracks in library.";
                print_endline "\talbums\t\t\tLists albums in library.";
                print_endline "\tartists\t\t\tLists artists in library.";
                print_endline "\tplay \"<trackname>\"\tPlays track.";
                print_endline "\tquit\t\t\tQuit OCAML.")

let check_file input =
  if (List.length input < 2) then
    (ANSITerminal.(print_string [white;on_red] "No filename provided");print_newline (); false) else 
    (ANSITerminal.(print_string [white;on_blue] ("Loading library " ^ List.nth input 1));print_newline (); true)

let load_library filename = Yojson.Basic.from_file filename |> Library.load_library

let print_tracks filename = 
  if (filename = "") then
    (ANSITerminal.(print_string [white;on_red] "No library loaded");print_newline ();) else
    List.hd (load_library filename |> Library.list_tracks |> List.map (fun s -> ANSITerminal.(print_string [blue] ("- " ^ s ^ "\n"))))

let print_albums filename = 
  if (filename = "") then
    (ANSITerminal.(print_string [white;on_red] "No library loaded");print_newline ();) else
    List.hd (load_library filename |> Library.list_albums |> List.map (fun x -> x.title) |> List.map (fun s -> ANSITerminal.(print_string [blue] ("- " ^ s ^ "\n"))))

let print_artists filename = 
  if (filename = "") then
    (ANSITerminal.(print_string [white;on_red] "No library loaded");print_newline ();) else
    List.hd (load_library filename |> Library.list_artists |> List.map (fun x -> x.name) |> List.map (fun s -> ANSITerminal.(print_string [blue] ("- " ^ s ^ "\n"))))

let chunks s = String.split_on_char ' ' s

let rec main filename start () =
  if start then (ANSITerminal.(print_string [blue;on_white;Bold]
                                 "\n\n\t\t\tWelcome to OCAML: The Ocaml Comprehensive Audio & Music Library!\n";
                               print_newline ();
                               print_endline "Run 'help' to get started!\n";));
  if (filename <> "") then ANSITerminal.(print_string [red;on_white] (filename));
  ANSITerminal.(print_string [red;on_white;Bold] " > ";print_string [] " ");
  let input = chunks (read_line ()) in
  begin match (List.hd input) with
    | exception _ -> ANSITerminal.(print_string [white;on_red] "Something went wrong!")
    | "load" -> if (check_file input) then main (List.nth input 1) false ()
    | "tracks" -> print_tracks filename; main filename false ()
    | "albums" -> print_albums filename; main filename false ()
    | "artists" -> print_artists filename; main filename false ()
    | "help" -> print_help ()
    | "restart" -> ANSITerminal.(print_string [white;on_red] "Restarting...");main "" true ()
    | "quit" -> ANSITerminal.(print_string [white;on_red] "Goodbye!");print_newline ();(exit 0)
    | other -> ANSITerminal.(print_string [white;on_red] ("Unknown command " ^ other));print_newline ()
  end;
  main filename false ()

let () = main "" true ()