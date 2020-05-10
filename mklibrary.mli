(** 
   Useful tools to build a library based on a directory of music.

   Introduces the ability to read music files from disk and interact with the
   library in OCAML.
*)
(** Raised when a nonexistent directory is passed. *)
exception NoDir of string 

(** [read_dir dir] returns the top-level contents of [dir] on disk.  
    Raises: [NoDir] if [dir] is not present. *)
val read_dir : string -> string list

(** [read_artists dir] gives all artist names stored in [dir].
    Raises: [NoDir] if [dir] is not present. *)
val read_artists : string -> string list 

(** [read_albums dir artist] gives all album names stored under [artist] 
    subdirectory of [dir].
    Raises: [NoDir] if [dir], subdirectory [artist] are not present. *)
val read_albums : string -> string -> string list

(** [read_tracks dir artist album] gives all track names stored under [album] 
    subdirectory of [artist] subdirectory of [dir].
    Raises: [NoDir] if [dir], subdirectories [artist], [album] are not present. *)
val read_tracks : string -> string -> string -> string list

(** [make_albums dir artist albums acc] builds an album list from [artist] 
    with albums [albums], storing progress in [acc].  
    Raises: [NoDir] if [dir], subdirectories [artist], [albums] are not present.*)
val make_albums : string -> string -> Library.album_title list -> 
  Library.album list -> Library.album list

(** [make_library dir] builds a library object based on music library 
    directory [dir].
    Raises: [NoDir] if [dir] is not present. *)
val make_library : string -> Library.t