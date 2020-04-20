open OUnit2
open Library

let load_json filename = Yojson.Basic.from_file filename

let make_load_artists_test (name) (json) (expected_output) = 
  name >:: fun _ -> assert_equal (List.sort compare (load_library json |> list_artists |> List.map (fun x -> x.name))) (List.sort compare (expected_output))

let make_load_albums_test (name) (json) (expected_output) =
  name >:: fun _ -> assert_equal (List.sort compare (load_library json |> list_albums |> List.map (fun x -> x.title))) (List.sort compare (expected_output))

let make_load_tracks_test (name) (json) (expected_output) =
  name >:: fun _ -> assert_equal (List.sort compare (load_library json |> list_tracks)) (List.sort compare (expected_output))

let load_tests = [
  make_load_artists_test "Two artists" (load_json "testlib.json") ["Pond";"Tekashi 6ix9ine"];
  make_load_albums_test "Three albums" (load_json "testlib.json") ["Man It Feels Like Space Again";"The Weather";"DUMMY BOI"];
  make_load_tracks_test "Five tracks" (load_json "testlib.json") ["outside_is_the_right_side.mp3";"waiting_around_for_grace.mp3";"30000_megatons.mp3";"the_weather.mp3";"stoopid.mp3"]
]

let suite =
  "OCAML test suite"  >::: List.flatten [
    load_tests
  ]

let _ = run_test_tt_main suite
