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
  lib_name : library_name;
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

(** [get_artist artist t] returns the artist object associated with name
    [artist] in library [t].  
    Raises: [UnknownArtist] if artist is not present in library. *)
val get_artist : artist_name -> t -> artist 

(** [get_album artist album t] returns the album object associated with name 
    [album] by [artist] in library [t].  
    Raises: [UnknownArtist] if artist is not present in library; 
    [UnknownAlbum] if album is not present in library.*)
val get_album : artist_name -> album_title -> t -> album 

(** [add_artist t artist] creates new library object that is identical to [t] but
    includes new artist with name [artist]. *)
val add_artist : artist_name -> t -> t

(** [add_album t artist album] creates new library object that is identical to
    [t] but includes new album with title [album] released by [artist_name].  
    Raises: [UnknownArtist] if artist is not present in library. *)
val add_album : artist_name -> album_title -> t -> t

(** [add_track t artist album track] creates new library object that is
    identical to [t] but includes new track with title [track] in [album]
    released by [artist_name].  
    Raises: [UnknownArtist] if artist is not present in library; 
    [UnknownAlbum] if album is not present in library. *)
val add_track : artist_name -> album_title -> track_title -> t -> t
