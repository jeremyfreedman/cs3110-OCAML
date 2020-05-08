#!/usr/bin/env bash
liq=$(which liquidsoap)
exec liquidsoap "
output.prefered(
  mksafe(playlist(mode='normal', 'queue.pls', reload_mode='watch'))
  )"
