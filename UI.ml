open Library
open State

let load_library filename =
  Yojson.Basic.from_file filename |> Library.load_library

let print_artists state = 
  if (state.library.lib_name = "") then
    (ANSITerminal.(print_string [white;on_red] "No library loaded");print_newline ();) else
    List.hd (state.library |> list_artists |> List.map (fun x -> x.name) |> 
             List.map (fun s -> ANSITerminal.(print_string [blue]
                                                ("- " ^ s ^ "\n"))))

let print_albums state = 
  if (state.library.lib_name = "") then
    (ANSITerminal.(print_string [white;on_red] "No library loaded");print_newline ();) else
    List.hd (state.library |> list_albums |> List.map (fun x -> x.title) |>
             List.map (fun s -> ANSITerminal.(print_string [blue]
                                                ("- " ^ s ^ "\n"))))

let print_tracks state = 
  if (state.library.lib_name = "") then
    (ANSITerminal.(print_string [white;on_red] "No library loaded");print_newline ();) else
    List.hd (state.library |>list_tracks |> List.map
               (fun s -> ANSITerminal.(print_string [blue] ("- " ^ s ^ "\n"))))

let list state input = 
  if (List.length input = 1) then
    (ANSITerminal.(print_string [white;on_red] "Usage: list <artists|albums|tracks|>");print_newline ();)
  else if (List.nth input 1 = "artists") then print_artists state 
  else if (List.nth input 1 = "albums") then print_albums state 
  else if (List.nth input 1 = "tracks") then print_tracks state 
  else (ANSITerminal.(print_string [white;on_red] "Usage: list <artists|albums|tracks|>");print_newline ();)

let restart state = ANSITerminal.(print_string [white;on_red] "Restarting...");print_newline();set_library (load_library "blank.json") state

let print_help () = 
  ANSITerminal.(print_string [blue;Bold] "Available commands:";
                print_endline "\n\thelp\t\t\t\tPrints this page.";
                print_endline "\tload <filename>\t\t\tLoads a library from a OCAML-compatible JSON file.";
                print_endline "\tmklibrary <filename>\t\tCreates a new library with the given filename.";
                print_endline "\tlibinfo\t\t\t\tGives stats about the currently open library.";
                print_endline "\tlist <artists|albums|tracks>\tLists the provided field.";
                print_endline "\tplay \"<trackname>\"\t\tPlays track.";
                print_endline "\tquit\t\t\t\tQuit OCAML.")
