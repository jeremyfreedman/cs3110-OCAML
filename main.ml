open Yojson.Basic.Util
let print_help () = 
  ANSITerminal.(print_string [blue;Bold] "Available commands:";
                print_endline "\n\thelp\t\t\tPrints this page.";
                print_endline "\tload <filename>\t\tLoads a library from a OCAML-compatible JSON file.";
                print_endline "\tmklibrary <filename>\tCreates a new library with the given filename.";
                print_endline "\tlibinfo\t\t\tGives stats about the currently open library.";
                print_endline "\ttracks\t\t\tLists tracks in library, sorted alphabetically.";
                print_endline "\tplay \"<trackname>\"\tPlays track.")

let rec main start () =
  if start then (ANSITerminal.(print_string [blue;on_white;Bold]
                                 "\n\n\t\t\tWelcome to OCAML: The Ocaml Comprehensive Audio & Music Library!\n";
                               print_newline ();
                               print_endline "Run 'help' to get started!\n";));
  ANSITerminal.(print_string [red;on_white;Bold] ">";print_string [] " ");
  begin match read_line () with
    | exception _ -> ANSITerminal.(print_string [white;on_red] "Something went wrong!")
    | "help" -> print_help ()
    | "restart" -> ANSITerminal.(print_string [white;on_red] "Restarting...");main true ()
    | "quit" -> ANSITerminal.(print_string [white;on_red] "Goodbye!");print_newline ();(exit 0);
    | other -> ANSITerminal.(print_string [white;on_red] ("Unknown command " ^ other));print_newline ();
  end;
  main false ()

let () = main true ()