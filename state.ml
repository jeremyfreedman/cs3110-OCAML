open Library

type t = {
  mutable library : Library.t;
  mutable start : bool;
  mutable current_artist : Library.artist_name;
  mutable current_album : Library.album_title;
  mutable current_track : Library.track_title;
  mutable view_queue : Library.track_title list;
  mutable path_queue : string list;
  mutable liq_io : (in_channel * out_channel)
}

let set_start start state = state.start <- start 
let set_artist artist state = state.current_artist <- artist
let set_album album state = state.current_album <- album
let set_track track state = state.current_track <- track 

let add_album_to_queue artist album state = 
  let new_tracks = (Library.get_album artist album state.library).tracks in
  state.view_queue <- state.view_queue@new_tracks;
  let new_paths = List.fold_left
      (fun acc t -> (Library.get_track_path artist album t state.library)::acc)
      [] new_tracks in
  state.path_queue <- state.path_queue@(List.rev new_paths)

let add_track_to_queue artist album track state =
  state.view_queue <- track::state.view_queue; state.path_queue
  <- Library.get_track_path artist album track state.library::state.path_queue

let add_artist_to_queue artist state = 
  List.iter (fun album -> add_album_to_queue artist album state)
    ((Library.get_artist artist state.library).albums |>
     List.map (fun x -> x.title))

let skip_queue state = 
  match state.view_queue with 
  | [] -> ()
  | h::t -> state.view_queue <- t; 
    (match state.path_queue with 
     | [] -> ()
     | h::t -> state.path_queue <- t)

let clear_queue state = 
  state.view_queue <- []; state.path_queue <- []

let wipe_queue () =
  let oc = open_out_gen [Open_trunc] 0o777 "queue.pls" in close_out oc

let write_queue state = 
  wipe_queue ();
  let oc = open_out_gen [Open_wronly] 0o777 "queue.pls" in 
  ignore (List.map (fun x -> output_string oc (x ^ "\n")) 
            state.path_queue);
  close_out oc

let set_library library state = state.library <- library;
  set_artist "" state; set_album "" state; set_track "" state

let init_liq () = Unix.open_process_args "./play.sh" [||]

let stop_liq state = Unix.kill (Unix.process_pid state.liq_io) 9

let reload_liq state = 
  stop_liq state; state.liq_io <- init_liq ();
  match state.path_queue with
  | [] -> set_track "" state; set_album "" state; set_artist "" state 
  | h::t ->
    match (String.split_on_char '/' h) with 
    | _::artist::album::track::_ -> set_artist artist state;
      set_album album state; set_track track state
    | _ -> failwith "Malformed path queue"
