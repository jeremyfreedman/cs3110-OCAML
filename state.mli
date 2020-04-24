(** 
   Stores (typically dynamic) data about the current library and application 
   state. 

   This module keeps track of the current library, selected fields, playing
   track, queue, and more. 
*)

(** The type of a state. *)
type t

(** [set_library library state] Sets the library field of [state] to 
    [library]. *)
val set_library : Library.t -> t -> unit

(** [set_start start state] Sets the start field of [state] to 
    [start]. *)
val set_library : bool -> t -> unit

(** [set_artist artist state] Sets the current_artist field of [state] to 
    [artist]. *)
val set_artist : Library.artist_name -> t -> unit

(** [set_album album state] Sets the current_album field of [state] to 
    [artist]. *)
val set_album : Library.album_title -> t -> unit

(** [set_artist track state] Sets the current_track field of [state] to 
    [track]. *)
val set_track : Library.track_title -> t -> unit

(** [add_to_queue track state] Adds [track] to the queue field (list) in 
    [state]. *)
val add_to_queue : Library.track_title -> t -> unit

