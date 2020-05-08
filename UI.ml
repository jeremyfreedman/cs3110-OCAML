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
    ignore (state.library |> list_artists |> List.sort compare |>
            List.map (fun x -> x.name) |> 
            List.map (fun s -> ANSITerminal.(print_string [blue]
                                               ("- " ^ s ^ "\n"))))

let print_albums state = 
  if (state.library.lib_name = "") then
    (ANSITerminal.(print_string [white;on_red] "No library loaded");print_newline ();) else
    ignore (state.library |> list_albums |> List.sort compare |> 
            List.map (fun x -> x.title) |>
            List.map (fun s -> ANSITerminal.(print_string [blue]
                                               ("- " ^ s ^ "\n"))))

let print_tracks state = 
  if (state.library.lib_name = "") then
    (ANSITerminal.(print_string [white;on_red] "No library loaded");print_newline ();) else
    ignore (state.library |> list_tracks |> List.sort compare |> List.map
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
  match input with 
  | ["list"; "all"] -> print_all state (state.library |> list_artists)
  | ["list"; "artists"] -> print_artists state 
  | ["list"; "albums"] -> print_albums state 
  | ["list"; "tracks"] -> print_tracks state
  | _ -> (ANSITerminal.(print_string [white;on_red] "Usage: list <all|artists|albums|tracks>");print_newline ();)

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

let now_playing state = 
  match state.current_track with
  | "" -> (ANSITerminal.(print_string [white;on_red] "No track currently playing");print_newline ();)
  | title -> let t = [state.current_track; state.current_album ; state.current_artist] in
    (ANSITerminal.(print_string [cyan] (String.concat " - " t));print_newline ();)

let play state input = 
  match List.length input with 
  | 1 -> (ANSITerminal.(print_string [white;on_red] "Usage: play <artist> [album] [track]");print_newline ();)
  | 2 -> (ANSITerminal.(print_string [white;on_blue]("Adding " ^ List.nth input 1 ^ " to queue"));print_newline (););
    State.add_artist_to_queue (List.nth input 1) state; reload_liq state

  | _ -> (ANSITerminal.(print_string [white;on_red] "Unimplemented");print_newline ();)

let print_queue state = 
  match state.view_queue with 
  | [] -> (ANSITerminal.(print_string [white;on_red] "Queue is empty");print_newline ();)
  | _ -> ignore (state.view_queue |> List.map
                   (fun s -> ANSITerminal.(print_string [blue] ("- " ^ s ^ "\n"))))

let clear state = State.clear_queue state; State.wipe_queue (); 
  State.reload_liq state

let stop state = 
  if (state.view_queue = []) then 
    (ANSITerminal.(print_string [white;on_red] "Queue is empty");print_newline ();) else
    stop_liq state

let skip state = 
  if (List.length state.view_queue < 2) then 
    (ANSITerminal.(print_string [white;on_red] "Queue is empty");print_newline ();
     stop state) else
    begin state.view_queue <- List.tl state.view_queue;
      state.path_queue <- List.tl state.path_queue;
      reload_liq state end

let restart state = ANSITerminal.(print_string [white;on_red] "Restarting...");
  print_newline();set_start true state;
  set_library (load_library "blank.json") state; clear_queue state

let print_help () = 
  ANSITerminal.(print_string [blue;Bold] "Available commands:";
                print_endline "\n\thelp\t\t\t\t\tPrints this page.";
                print_endline "\tload <filename>\t\t\t\tLoads a library from a OCAML-compatible JSON file.";
                print_endline "\tmklibrary <filename>\t\t\tCreates a new library with the given filename.";
                print_endline "\tlibinfo\t\t\t\t\tGives stats about the currently open library.";
                print_endline "\tlist <all|artists|albums|tracks>\tLists the provided field.";
                print_endline "\tview <artist> <name>\t\t\tView details about the provided category and name.";
                print_endline "\tnowplaying\t\t\t\tDisplays current track info.";
                print_endline "\tplay <artist> [album] [track]\t\tPlays desired media.";
                print_endline "\tqueue\t\t\t\t\tDisplays track queue.";
                print_endline "\tclear\t\t\t\t\tClears queue and current track.";
                print_endline "\tskip\t\t\t\t\tSkips current track.";
                print_endline "\tstop\t\t\t\t\tStops playback.";
                print_endline "\trestart\t\t\t\t\tRestarts OCAML (unloads library).";
                print_endline "\tquit\t\t\t\t\tQuit OCAML.")
