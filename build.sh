#!/bin/sh

mkdir -p obj
rm -rf obj/*

if [[ $1 == debug ]]; then
  fpc pasmotd.pas -FE"obj/" -Fu"inc/" -g -dDEBUG
else
  fpc pasmotd.pas -FE"obj/" -Fu"inc/" -O4 -Xs -XX
fi
