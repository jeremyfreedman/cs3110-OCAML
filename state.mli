(** 
   Stores (typically dynamic) data about the current library and application 
   state. 

   This module keeps track of the current library, selected fields, playing
   track, queue, and more. 
*)

(** The type of a state. *)
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

(** [set_library library state] Sets the library field of [state] to 
    [library]. *)
val set_library : Library.t -> t -> unit

(** [set_start start state] Sets the start field of [state] to 
    [start]. *)
val set_start : bool -> t -> unit

(** [set_artist artist state] Sets the current_artist field of [state] to 
    [artist]. *)
val set_artist : Library.artist_name -> t -> unit

(** [set_album album state] Sets the current_album field of [state] to 
    [artist]. *)
val set_album : Library.album_title -> t -> unit

(** [set_artist track state] Sets the current_track field of [state] to 
    [track]. *)
val set_track : Library.track_title -> t -> unit

(** [add_album_to_queue artist album state] Adds the entirety of [album]
    to [view_queue] field, and track paths to [path_queue] in [state]. *)
val add_album_to_queue : Library.artist_name -> Library.album_title -> t -> unit

(** [add_artist_to_queue artist state] Adds the entirety of [artist]'s tracks
    to [view_queue] field, and track paths to [path_queue] in [state]. *)
val add_artist_to_queue : Library.artist_name -> t -> unit

(** [add_track_to_queue artist album track state] Adds [track] to [view_queue]
    field, and track path to [path_queue] in [state]. *)
val add_track_to_queue : Library.artist_name -> Library.album_title -> 
  Library.track_title -> t -> unit

(** [wipe_queue unit] removes all values [queue.pls] on disk. *)
val wipe_queue : unit

(** [write_queue state] writes the queue stored in [state] to [queue.pls] for
    Liquidsoap-supported playback. *)
val write_queue : t -> unit

(** [init_liq] runs the Liquidsoap script [play.liq] in a parallel process. *)
val init_liq : in_channel * out_channel

val stop_liq : t -> unit

val reload_liq : t -> unit