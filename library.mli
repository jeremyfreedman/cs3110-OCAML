(**
   Representation of a music library.

   This module represents an OCAML-produced, JSON-formatted music library. See
   [schema.json] for details. 
*)

(** The type of a library name.
    Requires: String should be filename-friendly. *)
type library_name = string

(** The type of a track name.
    Requires: String should be filename-friendly. *)
type track_title = string 

(** The type of an album name. *)
type album_title = string 

(** The type of an artist name. *)
type artist_name = string

(** The type of an album. *)
type album = {
  title : album_title;
  tracks : track_title list
}

(** The type of an artist. *)
type artist = {
  name : artist_name;
  albums : album list
}

(** The type of a library. *)
type t = {
  name : library_name;
  artists : artist list;
}

(** Raised when an unknown track is requested. *)
exception UnknownTrack of track_title
(** Raised when an unknown album is requested. *)
exception UnknownAlbum of album_title
(** Raised when an unknown artist is requested. *)
exception UnknownArtist of album_title

(** [load_library j] is the library that JSON file [j] represents.
    Requires: [j] is a valid JSON library representation. *)
val load_library : Yojson.Basic.t -> t 

(** [list_artists t] is a list of all artist objects in library [t]. *)
val list_artists : t -> artist list 

(** [list_albums t] is a list of all album objects in library [t]. *)
val list_albums : t -> album list 

(** [list_tracks t] is a list of all track titles in library [t]. *)
val list_tracks : t -> track_title list 