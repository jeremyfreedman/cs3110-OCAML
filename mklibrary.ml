open Library
open Unix

exception NoDir of string 

let rec read_dir_helper dh acc =
  match Unix.readdir dh with 
  | exception _ -> acc 
  | "." -> read_dir_helper dh acc 
  | ".." -> read_dir_helper dh acc 
  | s -> read_dir_helper dh (s::acc)

let read_dir dir =
  let dh = try
      Unix.opendir dir
    with Unix.Unix_error _  -> raise (NoDir dir) in 
  List.rev (read_dir_helper dh [])

let read_artists dir = read_dir dir 

let read_albums dir artist = read_dir (dir ^ "/" ^ artist)

let read_tracks dir artist album = read_dir (dir ^ "/" ^ artist ^ "/" ^ album)

let rec make_albums dir artist albums acc = 
  match albums with 
  | [] -> acc
  |  h::t -> make_albums dir artist t
               ({title = h; tracks = (read_tracks dir artist h)}::acc)


let make_library dir = 
  {
    lib_name = dir;
    artists = List.fold_left (fun acc x ->
        {name = x;albums = (make_albums dir x (read_albums dir x) [])}::acc)
        [] (read_artists dir)
  }