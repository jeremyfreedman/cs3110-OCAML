open Library
open State

let load_library input =
  match input with 
  | h::filename::_ ->
    Yojson.Basic.from_file filename |> Library.load_library
  | _ -> failwith "Malformed input"

let load_dir input = 
  match input with 
  | h::dir::_ -> Mklibrary.make_library dir
  | _ -> failwith "Malformed input"

let lib_loaded state = if state.library.lib_name = "" then
    (ANSITerminal.(print_string [white;on_red] "No library loaded");
     print_newline ();)

let print_libinfo state = 
  let artists = 
    state.library |> list_artists |> List.length |> string_of_int in 
  let albums = state.library |> list_albums |> List.length |> string_of_int in 
  let tracks = state.library |> list_tracks |> List.length |> string_of_int in 
  if (artists = "0") then
    ANSITerminal.(print_string [white;on_red] "No library loaded") else
    ANSITerminal.(print_string [blue] (artists ^ " artists\n" ^ albums ^
                                       " albums\n" ^ tracks ^ " tracks" ));
  print_newline ()

let print_artists state = 
  lib_loaded state;
  ignore (state.library |> list_artists |> List.sort compare |>
          List.map (fun x -> x.name) |> 
          List.map (fun s -> ANSITerminal.(print_string [blue]
                                             ("- " ^ s ^ "\n"))))

let print_albums state = 
  lib_loaded state;
  ignore (state.library |> list_albums |> List.sort compare |> 
          List.map (fun x -> x.title) |>
          List.map (fun s -> ANSITerminal.(print_string [blue]
                                             ("- " ^ s ^ "\n"))))

let print_tracks state = 
  lib_loaded state;
  ignore (state.library |> list_tracks |> List.sort compare |> List.map
            (fun s -> ANSITerminal.(print_string [blue] ("- " ^ s ^ "\n"))))

let rec print_all state artists =
  lib_loaded state;
  match artists with 
  | [] -> ()
  | h::t -> 
    ANSITerminal.
      (print_string [blue;Bold] (h.name ^ "\n"));
    let tracks x = ignore
        (List.map(fun y -> ANSITerminal.(print_string [cyan]
                                           ("\t - " ^ y ^ "\n"))) x.tracks)
    in ignore 
      (List.map
         (fun x -> ANSITerminal.(print_string [blue] ("\t" ^ x.title ^ "\n");
                                 tracks x)) h.albums);
    print_newline ();print_all state t

let print_list state input = 
  lib_loaded state;
  match input with 
  | ["list"; "all"] -> print_all state (state.library |> list_artists)
  | ["list"; "artists"] -> print_artists state 
  | ["list"; "albums"] -> print_albums state 
  | ["list"; "tracks"] -> print_tracks state
  | _ -> ANSITerminal.(print_string [white;on_red]
                         "Usage: list <all|artists|albums|tracks>");
    print_newline ()

let print_view state input = 
  lib_loaded state;
  match input with 
  | [] -> ANSITerminal.(print_string [white;on_red] 
                          "Usage: view <artist> <name>");
    print_newline ()
  | h::"artist"::[] -> ANSITerminal.(print_string [white;on_red] 
                                       "Usage: view <artist> <name>");
    print_newline ()
  | h::"artist"::artist::_ ->
    let tracks x = ignore
        (List.map (fun y -> ANSITerminal.(print_string [cyan]
                                            ("\t - " ^ y ^ "\n"))) x.tracks) in
    ignore ((get_artist artist (state.library)).albums |> (List.map (fun x -> 
        ANSITerminal.(print_string [blue] ("\t" ^ x.title ^ "\n");tracks x))))
  | h::t -> ANSITerminal.(print_string [white;on_red] 
                            "Usage: view <artist> <name>");
    print_newline ()

let now_playing state = 
  lib_loaded state;
  match state.current_track with
  | "" ->
    ANSITerminal.(print_string [white;on_red] "No track currently playing");
    print_newline ()
  | title ->
    let t = [state.current_track;state.current_album ;state.current_artist] in
    ANSITerminal.(print_string [cyan] (String.concat " - " t));print_newline ()

let play state input = 
  lib_loaded state;
  match input with 
  | _::[] ->
    ANSITerminal.(print_string [white;on_red]
                    "Usage: play <artist> [album] [track]");print_newline ()
  | _::artist::album::track::t ->
    ANSITerminal.(print_string [white;on_blue]
                    ("Adding " ^ track ^ " to queue"));
    print_newline ();
    State.add_track_to_queue artist album track state; reload_liq state
  | _::artist::album::t -> ANSITerminal.(print_string [white;on_blue]
                                           ("Adding " ^ album ^ " to queue"));
    print_newline ();
    State.add_album_to_queue artist album state; reload_liq state
  | _::artist::t -> ANSITerminal.(print_string [white;on_blue]
                                    ("Adding " ^ artist ^ " to queue"));
    print_newline ();
    State.add_artist_to_queue (artist) state; reload_liq state
  | _ -> ANSITerminal.(print_string [white;on_red] 
                         "Usage: play <artist> [album] [track]");
    print_newline ()

let print_queue state = 
  lib_loaded state;
  match state.view_queue with 
  | [] -> ANSITerminal.(print_string [white;on_red] "Queue is empty");
    print_newline ()
  | _ -> ignore
           (state.view_queue |> List.map (fun s ->
                ANSITerminal.(print_string[blue] ("- " ^ s ^ "\n"))))

let clear state = State.clear_queue state; State.wipe_queue (); 
  State.reload_liq state

let stop state = 
  lib_loaded state;
  match state.view_queue with
  | [] -> ANSITerminal.(print_string [white;on_red] "Queue is empty");
    print_newline ();
  | _::_ -> stop_liq state

let skip state = 
  begin match state.view_queue with 
    | [] -> ();
      print_newline (); stop state
    | h::t -> skip_queue state; end;
  reload_liq state

let restart state = ANSITerminal.(print_string [white;on_red] "Restarting...");
  print_newline(); set_start true state;
  set_library (load_library ["load";"blank.json"]) state; clear_queue state

let print_help () = 
  ANSITerminal.(print_string [blue;Bold] "Available commands:";
                print_endline "\n\thelp\t\t\t\t\t
                Prints this page.";
                print_endline "\tload <filename>\t\t\t\t
                Loads a library from a OCAML-compatible JSON file.";
                print_endline "\tlibinfo\t\t\t\t\t
                Gives stats about the currently open library.";
                print_endline "\tlist <all|artists|albums|tracks>\t
                Lists the provided field.";
                print_endline "\tview <artist> <name>\t\t\t
                View details about the provided category and name.";
                print_endline "\tnowplaying\t\t\t\t
                Displays current track info.";
                print_endline "\tplay <artist> [album] [track]\t\t
                Plays desired media.";
                print_endline "\tqueue\t\t\t\t\t
                Displays track queue.";
                print_endline "\tclear\t\t\t\t\t
                Clears queue and current track.";
                print_endline "\tskip\t\t\t\t\t
                Skips current track.";
                print_endline "\tstop\t\t\t\t\t
                Stops playback.";
                print_endline "\trestart\t\t\t\t\t
                Restarts OCAML (unloads library).";
                print_endline "\tquit\t\t\t\t\tQuit OCAML.")
