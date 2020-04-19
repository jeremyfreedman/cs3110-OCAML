open Yojson.Basic.Util

type library_name = string
type track_title = string
type album_title = string
type artist_name = string

type album = {
  title : album_title;
  tracks : track_title list
}

type artist = {
  name : artist_name;
  albums : album list
}

type t = {
  name : library_name;
  artists : artist list;
}

exception UnknownTrack of track_title 
exception UnknownAlbum of album_title 
exception UnknownArtist of artist_name

(** [load_album json] create [album] objects based on the contents of [json]. *)
let load_album json = {
  title = json |> member "title" |> to_string;
  tracks = json |> member "tracks" |> to_list |> List.map to_string;
}

(** [load_artist json] create [artist] objects based on the contents of [json]. *)
let load_artist json = {
  name = json |> member "name" |> to_string; 
  albums = json |> member "albums" |> to_list |> List.map load_album;
}

(** [load_library json] create [Library.t] objects based on the contents of
    [json]. *)
let load_library json = {
  name = json |> member "name" |> to_string;
  artists = json |> member "artists" |> to_list |> List.map load_artist;
}

let list_artists t = t.artists

let list_albums t = List.flatten (List.map (fun x -> x.albums) (list_artists t))

let list_tracks t = List.flatten (List.map (fun x -> x.tracks) (list_albums t))