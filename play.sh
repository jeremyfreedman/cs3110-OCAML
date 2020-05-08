#!/usr/bin/env bash
liq=$(which liquidsoap)
exec $liq "output.prefered(
  mksafe(
    playlist(mode='normal', 'queue.pls')
    )
  )"
