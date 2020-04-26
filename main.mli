(**
   Overarching module for user interaction with OCAML.

   Sends instructions to [UI.ml] for processing.
*)
val chunks : string -> string list

val check_file : string list -> bool

val init_state : State.t

val main : State.t -> unit -> unit