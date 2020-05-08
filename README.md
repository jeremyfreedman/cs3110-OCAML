# OCAML: OCaml Comprehensive Audio & Music Library
(Note: A [recursive acronym!](https://en.wikipedia.org/wiki/Recursive_acronym))
## Current Features
- Simple REPL interface
- Load library JSON or directory
- View library stats
- View artists, albums, tracks, or all at once
- View details about individual artist or album
- Play an artist's tracks (skip, stop, resume playback)
- Queue up multiple artists
## Instructions
- ### Dependencies
  - Install the necessary dependencies using OPAM:
    1. `opam install depext`
    2. `opam depext Yojson ANSITerminal mad taglib liquidsoap`
    3. `opam install Yojson ANSITerminal mad taglib liquidsoap`
- ### Compatibility
  - Audio playback uses Liquidsoap's `output.prefered`, which means it *should* be able to locate your audio driver independently. I've tested playback on a Dell XPS 15 9570 running Ubuntu 20.04 with Pulseaudio. I have not had success getting audio playback on Windows (WSL), so your milage may vary.
  - I would presume OCAML does not work on macOS, but I have no way to test this. It depends on OCaml's `Unix` library which probably has compatibility issues with macOS.
- ### Getting started
  - Run OCAML with `make`.
  - With OCAML running, run `help` to see available instructions.
  - Need further assistance? `make docs` will generate interface documentation in HTML format.
  - Note: file paths can be absolute (ie. `/home/user/music_library.json`) or relative to OCAML's root directory (ie `testlib.json`).
- ### `load`
  - Using OCAML with a JSON file was solely implemented as a proof-of-concept and will not work with audio playback, queueing, or any useful features. Use `loaddir` on a directory of music instead (see below).
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
- Writing directory-read library to JSON file
- Sorting library by audio metadata/tags
## Acknowledgements
- Megan Rait, QA engineer
- Arjun Sweet, resident Griggologist
- Micah, dog