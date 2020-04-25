type t = {
  mutable library : Library.t;
  mutable start : bool;
  mutable current_artist : Library.artist_name;
  mutable current_album : Library.album_title;
  mutable current_track : Library.track_title;
  mutable queue : Library.track_title list
}

let set_library library state = state.library <- library
let set_start start state = state.start <- start 
let set_artist artist state = state.current_artist <- artist
let set_album album state = state.current_album <- album
let set_track track state = state.current_track <- track 
let add_to_queue track state = state.queue <- track::state.queue