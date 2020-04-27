# OCAML: OCaml Comprehensive Audio & Music Library
(Note: A [recursive acronym!](https://en.wikipedia.org/wiki/Recursive_acronym))
## Current Features
- Simple REPL interface
- Load library JSON or directory
- View library stats
- View artists, albums, tracks, or all at once
- View details about individual artist or album
## Instructions
- ### Getting started
  - Run OCAML with `make`.
  - Run `help` to see available instructions.
  - Need further assistance? `make docs` will generate interface documentation in HTML format.
  - Note: file paths can be absolute (ie. `/home/user/music_library.json`) or relative to OCAML's root directory (ie `testlib.json`).
- ### `loaddir`
  - If you wish to use OCAML with a library of music files stored on disk, they must be arranged as follows:
  ```
  - lib_name/
    - Artist 1/
      - Album 1/
        - track_1.ext
        - track_2.ext
      - Album 2/
        - track_3.ext
        - track_4.ext
    - Artist 2/
      - Album 3/
        - track_5.ext
  (etc.)
  ```
  - Once this file structure is established, run `loaddir lib_name`
## Todo
- Audio playback
- Writing directory-read library to JSON file
- Sorting library by audio metadata/tags