(**  
   Handles user input and interface control.

   Dependent on control from [main.ml].
*)

(** [load_library filename] loads the library file stored in [filename] and
    stores it as a [Library.t] object. *)
val load_library : string -> Library.t

(** [load_dir dir] loads the content in [dir] and stores it as a [Library.t]
    object. *)
val load_dir : string -> Library.t

(** [print_libinfo state] prints basic library statistics. *)
val print_libinfo : State.t -> unit

(** [print_artists state] prints artists in library. *)
val print_artists : State.t -> unit

(** [print_albums state] prints albums in library. *)
val print_albums : State.t -> unit

(** [print_tracks state] prints tracks in library. *)
val print_tracks : State.t -> unit

(** [print_artists state] prints all content in library. *)
val print_all : State.t -> Library.artist list -> unit

(** [print_list state input] prints information stored in the requested 
    field. *)
val print_list : State.t -> string list -> unit

(** [print_view state input] prints information about the named field and 
    content. *)
val print_view : State.t -> string list -> unit

(** [now_playing state] prints information about the current playing track. *)
val now_playing : State.t -> unit

(** [play state input] plays the content named in [input]. *)
val play : State.t -> string list -> unit

(** [print_queue state] prints all tracks in the queue. *)
val print_queue : State.t -> unit

(** [clear state] removes all tracks from the queue. *)
val clear : State.t -> unit

(** [skip state] skips the current track in the queue. *)
val skip : State.t -> unit

(** [stop state] halts Liquidsoap playback. *)
val stop : State.t -> unit

(** [restart state] removes all attributes of the current running application
    and effectively stops and restarts OCAML. *)
val restart : State.t -> unit

(** [print_help] prints useful help information. *)
val print_help : unit -> unit