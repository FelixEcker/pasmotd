#!/bin/sh

mkdir -p out
rm -rf out/*

if [[ $1 == debug ]]; then
  fpc pasmotd.pas -FE"out/" -Fu"inc/" -g -dDEBUG
else
  fpc pasmotd.pas -FE"out/" -Fu"inc/" -O4 -Xs -XX
fi
