(**
   Overarching module for user interaction with OCAML.

   Sends instructions to [UI.ml] for processing.
*)
(** [chunks s] splits [s] at each space character into a list.
    Note: strips empty strings. *)
val chunks : string -> string list

(** [check_file file input] validates [input] includes a valid file or 
    directory name. The [file] argument (whether the input is a file or
    directory) is passed simply to improve printouts and user experience. *)
val check_file : bool -> string list -> bool

(** [init_state] is the initial [State] of OCAML. All fields are essentially
    empty. *)
val init_state : State.t

(** [main state] handles user input and control for all interaction with 
    OCAML. Maintains [state] to track instance data. *)
val run : State.t -> unit
