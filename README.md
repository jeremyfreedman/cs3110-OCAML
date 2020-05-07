# OCAML: OCaml Comprehensive Audio & Music Library
(Note: A [recursive acronym!](https://en.wikipedia.org/wiki/Recursive_acronym))
## Current Features
- Simple REPL interface
- Load library JSON or directory
- View library stats
- View artists, albums, tracks, or all at once
- View details about individual artist or album
## Instructions
- ### Dependencies
  - Install the necessary dependencies using OPAM:
    - `opam install depext`
    - `opam depext Yojson ANSITerminal ao`
    - `opam install Yojson ANSITerminal ao`
- ### Compatibility
  - I've tested the `ao` audio library on a Dell XPS 15 9570 running Ubuntu 20.04. I have not had success getting audio playback on Windows (WSL).
- ### Getting started
  - Run OCAML with `make`.
  - With OCAML running, run `help` to see available instructions.
  - Need further assistance? `make docs` will generate interface documentation in HTML format.
  - Note: file paths can be absolute (ie. `/home/user/music_library.json`) or relative to OCAML's root directory (ie `testlib.json`).
- ### `loaddir`
  - If you wish to use OCAML with a library of music files stored on disk, they must be arranged as follows:
  ```
  - lib_name/
    - Artist_1/
      - Album_1/
        - track_1.ext
        - track_2.ext
      - Album_2/
        - track_3.ext
        - track_4.ext
    - Artist_2/
      - Album_3/
        - track_5.ext
  (etc.)
  ```
  - *Note*: File and folder names cannot contain spaces at this time.
  - Once this file structure is established, run `loaddir <lib_name>`
## Todo
- Audio playback
- Writing directory-read library to JSON file
- Sorting library by audio metadata/tags