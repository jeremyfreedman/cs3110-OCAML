#!/home/jerem/.opam/4.09.0/bin/liquidsoap
myplaylist = playlist(mode="normal", "queue.pls", reload_mode="watch");
output.prefered(
  mksafe(myplaylist)
  )
