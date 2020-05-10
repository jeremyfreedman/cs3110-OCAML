open OUnit2
open Library
open State

(** 
   Testing module for OCAML.

   Test cases were developed entirely by glass-box testing. For each tested 
   component, I aimed to build tests that represent:
   1. Typical input
   2. Edge cases (circumstances that could occur in practice but are uncommon)
   I do not test "garbage" input (ie. data that violates specifications).

   Because OCAML is made up of many components, some of which strictly depend
   on user interaction, the following components are tested in this file:

   Library
   - Loading from JSON or directory [x]
   - Retrieving information about the library (artists/albums/tracks, etc) [x]
   - Getting a specific artist/album object [x]
   - Getting artist/album/track paths [x]

   State
   - Updating various state fields (library, state, artist/album/track, etc) [x]
   - Modifying queues (view_queue, path_queue) [x]

   Mklibrary
   - Reading library fields (artists/albums/tracks) from a directory [ ]
   - Building a library object [ ]

   Main
   - Verify functionality of string chunking [ ]
   - Checking if file/dir exist on disk [ ]

   It would not be practical (or useful) to test any component of [UI], as 
   every function in that module either returns [unit] or simply calls another
   module. Its functionality is grounded in printing, which would not be
   practically testable. I also do not test any functions that interact with
   Liquidsoap ([State.init_liq, State.stop_liq, State.reload_liq]) or the 
   queue written to disk ([State.write_queue, State.wipe_queue]).
*)

(** [load_json filename] returns a JSON object loaded from [filename]. *)
let load_json filename = Yojson.Basic.from_file filename

let libraries = (
  load_json "testlib.json" |> Library.load_library,
  Mklibrary.make_library "test_library"
)

(** [make_state ?library ?start ?artist ?album ?track ?v_q ?p_q ?l_io unit]
    streamlines the process of building various states for testing purposes. *)
let make_state ?(library={lib_name = ""; artists = []}) ?(start=true) 
    ?(artist="") ?(album="") ?(track="") ?(v_q=[]) ?(p_q=[]) 
    ?(l_io=stdin,stdout) () =
  {library = library; start = start; current_artist = artist; 
   current_album = album; current_track = track; view_queue = v_q;
   path_queue = p_q; liq_io = l_io}

(** [text_exn name exn expected_exn] builds an OUnit test case named [name]
    to validate [fn] throws [expected_exn]. *)
let make_exn_test (name) (fn) (expected_exn) =
  name >:: fun _ -> assert_raises expected_exn (fn)

(** [make_load_artists_test name lib expected_output] builds an OUnit test
    case named [name] to compare [expected_output] to Library.list_artists 
    [lib]. *)
let make_load_artists_test (name) (lib) (expected_output) = 
  name >:: fun _ ->
    assert_equal (List.sort compare(list_artists lib |>
                                    List.map (fun x -> x.name)))
      (List.sort compare (expected_output))

(** [make_load_artists_test name lib expected_output] builds an OUnit test
    case named [name] to compare [expected_output] to Library.list_artists 
    [lib]. *)
let make_load_albums_test (name) (lib) (expected_output) =
  name >:: fun _ ->
    assert_equal (List.sort compare (list_albums lib |>
                                     List.map (fun x -> x.title)))
      (List.sort compare (expected_output))

(** [make_load_artists_test name lib expected_output] builds an OUnit test
    case named [name] to compare [expected_output] to Library.list_artists 
    [lib]. *)
let make_load_tracks_test (name) (lib) (expected_output) =
  name >:: fun _ ->
    assert_equal (List.sort compare (list_tracks lib))
      (List.sort compare (expected_output))

(** [make_get_artist_test name lib artist] builds an OUnit test
    case named [name] to compare [artist] to Library.get_artist [artist] 
    [lib]. *)
let make_get_artist_test (name) (lib) (artist) = 
  name >:: fun _ ->
    assert_bool name ((Library.get_artist artist lib).name
                      = artist)

(** [make_get_album_test name lib artist album] builds an OUnit test
    case named [name] to compare [artist] to Library.get_album [artist] [album] 
    [lib]. *)
let make_get_album_test (name) (lib) (artist) (album) =
  name >:: fun _ ->
    assert_bool name ((Library.get_album artist album lib).title = album)

(** [make_artist_path_test name lib artist expected_output] builds an OUnit test
    case named [name] to compare [expected_output] to Library.get_artist_path
    [artist] [lib]. *)
let make_artist_path_test (name) (lib) (artist) (expected_output) = 
  name >:: fun _ -> assert_equal (Library.get_artist_path artist lib)
      (expected_output)

(** [make_album_path_test name lib artist expected_output] builds an OUnit test
    case named [name] to compare [expected_output] to Library.get_album_path
    [artist] [album] [lib]. *)
let make_album_path_test (name) (lib) (artist) (album) (expected_output) = 
  name >:: fun _ -> assert_equal (Library.get_album_path artist album lib)
      (expected_output)

(** [make_track_path_test name lib artist track expected_output] builds an
    OUnit test case named [name] to compare [expected_output] to
    Library.get_track_path
    [artist] [album] [track] [lib]. *)
let make_track_path_test (name) (lib) (artist) (album) (track)
    (expected_output) = 
  name >:: fun _ -> assert_equal (Library.get_track_path artist album track lib)
      (expected_output)

(** [make_set_field_test name state field ?lib_value ?bool_value ?string_value
    new_state] builds an OUnit test case named [name] to verify [state].[field]
    has changed after modifying the given [field] with the relevant [__value]. *)
let make_set_field_test (name) (field) ?(lib_value=(fst libraries))
    ?(bool_value=false) ?(string_value="") (state) =
  match field with 
  | "library" -> State.set_library lib_value state;
    name >:: fun _ -> assert_equal state.library lib_value
  | "start" -> State.set_start bool_value state;
    name >:: fun _ -> assert_equal state.start bool_value
  | "artist" -> State.set_artist string_value state;
    name >:: fun _ -> assert_equal state.current_artist string_value
  | "album" -> State.set_album string_value state;
    name >:: fun _ -> assert_equal state.current_album string_value
  | "track" -> State.set_track string_value state;
    name >:: fun _ -> assert_equal state.current_track string_value
  | s -> failwith (s ^ " is not a valid state field.")

(** [make_queue_test name field artist ?album ?track state] builds an OUnit test
    case named [name] to verify [state.__queue] fields update when adding
    [artist], [?album], and/or [?track]. *)
let make_queue_test (name) (field) ?(artist="") ?(album="") ?(track="") (state)
    (view_queue) (path_queue) =
  begin match field with 
    | "artist" -> State.add_artist_to_queue artist state
    | "album" -> State.add_album_to_queue artist album state
    | "track" -> State.add_track_to_queue artist album track state
    | "clear" -> State.clear_queue state
    | "skip" -> State.skip_queue state
    | s -> failwith (s ^ " is not a valid queue instruction.") end;
  name >:: fun _ -> assert_equal state.view_queue view_queue;
    assert_equal state.path_queue path_queue

let library_tests = [ 
  make_load_artists_test "Two artists" (fst libraries)
    ["Pond";"Tekashi_6ix9ine"];
  make_load_albums_test "Three albums" (fst libraries)
    ["Man_It_Feels_Like_Space_Again";"The_Weather";"DUMMY_BOI"];
  make_load_tracks_test "Five tracks" (fst libraries)
    ["outside_is_the_right_side.mp3";"waiting_around_for_grace.mp3";
     "30000_megatons.mp3";"the_weather.mp3";"stoopid.mp3"];
  make_get_artist_test "Existing artist" (snd libraries) "C418";
  make_exn_test "Nonexisting artist"
    (fun () -> Library.get_artist "Pond" (snd libraries))
    (Library.UnknownArtist "Pond");
  make_get_artist_test "Existing artist json" (fst libraries) "Pond";
  make_exn_test "Nonexisting artist json"
    (fun () -> Library.get_artist "C418" (fst libraries))
    (Library.UnknownArtist "C418");
  make_get_album_test "Existing album" (snd libraries) "C418"
    "Seven_Years_of_Server_Data";
  make_exn_test "Existing album, mismatched artist" 
    (fun () -> Library.get_album "C418" "Cinematic" (snd libraries))
    (Library.UnknownAlbum "Cinematic");
  make_exn_test "Nonexisting artist, existing album"
    (fun () -> Library.get_album "Pond" "Piano" (snd libraries))
    (Library.UnknownArtist "Pond");
  make_artist_path_test "Artist path, json" (fst libraries) ("Pond")
    ("testlib/Pond");
  make_artist_path_test "Artist path, dir" (snd libraries) ("C418")
    ("test_library/C418");
  make_album_path_test "Album path, json" (fst libraries) "Pond"
    "Man_It_Feels_Like_Space_Again" "testlib/Pond/Man_It_Feels_Like_Space_Again";
  make_album_path_test "Album path, dir" (snd libraries) "Kevin_McLeod" "Piano"
    "test_library/Kevin_McLeod/Piano";
  make_track_path_test "Track path, json" (fst libraries) "Pond"
    "Man_It_Feels_Like_Space_Again" "waiting_around_for_grace.mp3"
    "testlib/Pond/Man_It_Feels_Like_Space_Again/waiting_around_for_grace.mp3";
  make_track_path_test "Track path, dir" (snd libraries) "Kevin_McLeod" "Piano"
    "sovereign.mp3" "test_library/Kevin_McLeod/Piano/sovereign.mp3"
]

let state_tests = [ 
  make_set_field_test "Set library" "library" ~lib_value:(snd libraries)
    (make_state ());
  make_set_field_test "Set start" "start" ~bool_value:(true) 
    (make_state ~start:(false) ());
  make_set_field_test "Set artist" "artist" ~string_value:("Pond") 
    (make_state ~artist:("Pond") ());
  make_set_field_test "Set album" "album" ~string_value:("Piano") 
    (make_state ~album:("Piano") ());
  make_set_field_test "Set track" "track" ~string_value:("sovereign.mp3") 
    (make_state ~track:("sovereign.mp3") ());
  make_exn_test "Add nonexisting artist"
    (fun () -> add_artist_to_queue "C418"
        (make_state ~library:(fst libraries) ()))
    (Library.UnknownArtist "C418");
  make_queue_test "Add artist" "artist" ~artist:("Pond")
    (make_state ~library:(fst libraries)())
    ["outside_is_the_right_side.mp3"; "waiting_around_for_grace.mp3";
     "30000_megatons.mp3";"the_weather.mp3"]
    ["testlib/Pond/Man_It_Feels_Like_Space_Again/outside_is_the_right_side.mp3";
     "testlib/Pond/Man_It_Feels_Like_Space_Again/waiting_around_for_grace.mp3";
     "testlib/Pond/The_Weather/30000_megatons.mp3";
     "testlib/Pond/The_Weather/the_weather.mp3"];
  make_queue_test "Add album" "album" ~artist:("Pond") ~album:("The_Weather")
    (make_state ~library:(fst libraries) ())
    ["30000_megatons.mp3"; "the_weather.mp3"]
    ["testlib/Pond/The_Weather/30000_megatons.mp3";
     "testlib/Pond/The_Weather/the_weather.mp3"];
  make_queue_test "Add track" "track" ~artist:("Pond") ~album:("The_Weather")
    ~track:("30000_megatons.mp3")
    (make_state ~library:(fst libraries) ())
    ["30000_megatons.mp3"] ["testlib/Pond/The_Weather/30000_megatons.mp3"];
  make_queue_test "Stack tracks" "track" ~artist:("Tekashi_6ix9ine")
    ~album:("DUMMY_BOI") ~track:("STOOPID.mp3")
    (make_state ~library:(fst libraries) 
       ~v_q:(["30000_megatons.mp3"])
       ~p_q:(["testlib/Pond/The_Weather/30000_megatons.mp3"]) ())
    ["STOOPID.mp3";"30000_megatons.mp3"] 
    ["testlib/Tekashi_6ix9ine/DUMMY_BOI/STOOPID.mp3";
     "testlib/Pond/The_Weather/30000_megatons.mp3"];
  make_queue_test "Clear queue; empty" "clear"
    (make_state ~library:(fst libraries) ()) [] [];
  make_queue_test "Clear queue; nonempty" "clear"
    (make_state ~library:(fst libraries) 
       ~v_q:(["30000_megatons.mp3"])
       ~p_q:(["testlib/Pond/The_Weather/30000_megatons.mp3"]) ()) [] [];
  make_queue_test "Skip track; empty" "skip" (make_state ()) [] [];
  make_queue_test "Skip track; nonempty" "skip" 
    (make_state ~library:(fst libraries)
       ~v_q:(["outside_is_the_right_side.mp3"; "waiting_around_for_grace.mp3";
              "30000_megatons.mp3";"the_weather.mp3"])
       ~p_q:(["testlib/Pond/Man_It_Feels_Like_Space_Again/outside_is_the_right_side.mp3";
              "testlib/Pond/Man_It_Feels_Like_Space_Again/waiting_around_for_grace.mp3";
              "testlib/Pond/The_Weather/30000_megatons.mp3";
              "testlib/Pond/The_Weather/the_weather.mp3"]) ())
    ["waiting_around_for_grace.mp3";"30000_megatons.mp3";"the_weather.mp3"; ]
    ["testlib/Pond/Man_It_Feels_Like_Space_Again/waiting_around_for_grace.mp3";
     "testlib/Pond/The_Weather/30000_megatons.mp3";
     "testlib/Pond/The_Weather/the_weather.mp3";]
]

let suite =
  "OCAML test suite"  >::: List.flatten [
    library_tests; state_tests
  ]

let _ = run_test_tt_main suite
