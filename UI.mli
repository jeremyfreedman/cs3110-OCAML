(**  
   Handles user input and interface control.

   Dependent on control from [main.ml].
*)

val load_library : string -> Library.t

val load_dir : string -> Library.t

val print_libinfo : State.t -> unit

val print_artists : State.t -> unit

val print_albums : State.t -> unit

val print_tracks : State.t -> unit

val print_all : State.t -> Library.artist list -> unit

val print_list : State.t -> string list -> unit

val print_view : State.t -> string list -> unit

val restart : State.t -> unit

val print_help : unit -> unit