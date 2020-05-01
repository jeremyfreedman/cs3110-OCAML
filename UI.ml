open Library
open State

let load_library filename =
  Yojson.Basic.from_file filename |> Library.load_library

let load_dir dir =  Mklibrary.make_library dir

let print_libinfo state = 
  let artists = state.library |> list_artists |> List.length |> string_of_int in 
  let albums = state.library |> list_albums |> List.length |> string_of_int in 
  let tracks = state.library |> list_tracks |> List.length |> string_of_int in 
  if (artists = "0") then
    ANSITerminal.(print_string [white;on_red] "No library loaded") else
    ANSITerminal.(print_string [blue] (artists ^ " artists\n" ^ albums ^ " albums\n" ^ tracks ^ " tracks" ));print_newline ()

let print_artists state = 
  if (state.library.lib_name = "") then
    (ANSITerminal.(print_string [white;on_red] "No library loaded");print_newline ();) else
    List.hd (state.library |> list_artists |> List.sort compare |>
             List.map (fun x -> x.name) |> 
             List.map (fun s -> ANSITerminal.(print_string [blue]
                                                ("- " ^ s ^ "\n"))))

let print_albums state = 
  if (state.library.lib_name = "") then
    (ANSITerminal.(print_string [white;on_red] "No library loaded");print_newline ();) else
    List.hd (state.library |> list_albums |> List.sort compare |> 
             List.map (fun x -> x.title) |>
             List.map (fun s -> ANSITerminal.(print_string [blue]
                                                ("- " ^ s ^ "\n"))))

let print_tracks state = 
  if (state.library.lib_name = "") then
    (ANSITerminal.(print_string [white;on_red] "No library loaded");print_newline ();) else
    List.hd (state.library |> list_tracks |> List.sort compare |> List.map
               (fun s -> ANSITerminal.(print_string [blue] ("- " ^ s ^ "\n"))))

let rec print_all state artists =
  if (state.library.lib_name = "") then
    (ANSITerminal.(print_string [white;on_red] "No library loaded");print_newline ();) else
    match artists with 
    | [] -> ()
    | h::t -> ANSITerminal.
                (print_string [blue;Bold] (h.name ^ "\n");
                 match (List.map
                          (fun x -> ANSITerminal.(print_string [blue] ("\t" ^ x.title ^ "\n");
                                                  (List.map (fun y -> ANSITerminal.(print_string [cyan] ("\t - " ^ y ^ "\n"))) x.tracks))) h.albums) with 
                 | _ -> ();
                   print_newline ());print_all state t

let print_list state input = 
  if (List.length input = 1) then
    (ANSITerminal.(print_string [white;on_red] "Usage: list <all|artists|albums|tracks>");print_newline ();)
  else if (List.nth input 1 = "all") then print_all state (state.library |> list_artists)
  else if (List.nth input 1 = "artists") then print_artists state 
  else if (List.nth input 1 = "albums") then print_albums state 
  else if (List.nth input 1 = "tracks") then print_tracks state 
  else (ANSITerminal.(print_string [white;on_red] "Usage: list <all|artists|albums|tracks>");print_newline ();)

let print_view state input = 
  if (List.length input < 2) then
    (ANSITerminal.(print_string [white;on_red] "Usage: view <artist> <name>");print_newline ();)
  else if (List.nth input 1 <> "artist") then 
    (ANSITerminal.(print_string [white;on_red] "Usage: view <artist> <name>");print_newline ();)
  else if (List.nth input 1 = "artist") then 
    match ((get_artist (String.concat " " (List.tl (List.tl input))) (state.library)).albums |>
           (List.map (fun x -> ANSITerminal.(print_string [blue] ("\t" ^ x.title ^ "\n");
                                             (List.map (fun y -> ANSITerminal.(print_string [cyan] ("\t - " ^ y ^ "\n"))) x.tracks))))) with 
    | _ -> ()


let restart state = ANSITerminal.(print_string [white;on_red] "Restarting...");print_newline();set_library (load_library "blank.json") state

let print_help () = 
  ANSITerminal.(print_string [blue;Bold] "Available commands:";
                print_endline "\n\thelp\t\t\t\t\tPrints this page.";
                print_endline "\tload <filename>\t\t\t\tLoads a library from a OCAML-compatible JSON file.";
                print_endline "\tmklibrary <filename>\t\t\tCreates a new library with the given filename.";
                print_endline "\tlibinfo\t\t\t\t\tGives stats about the currently open library.";
                print_endline "\tlist <all|artists|albums|tracks>\tLists the provided field.";
                print_endline "\tview <artist> <name>\t\t\tView details about the provided category and name.";
                print_endline "\tplay <artist> [album] [track]\t\tPlays desired media.";
                print_endline "\trestart\t\t\t\t\tRestarts OCAML (unloads library).";
                print_endline "\tquit\t\t\t\t\tQuit OCAML.")
