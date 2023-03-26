{$mode fpc}
program pasmotd;

{        pasmotd - pascal message of the day          }
{                                                     }
{ author: FelixEcker                                  } 
{ git-repo: https://github.com/FelixEcker/pasmotd.git }
{ Licensed under the ISC License, see below           }

(* Copyright (c) 2022, Felix Eckert                                         *)
(*                                                                          *)
(* Permission to use, copy, modify, and/or distribute this software for any *)
(* purpose with or without fee is hereby granted, provided that the above   *)
(* copyright notice and this permission notice appear in all copies.        *)
(*                                                                          *)
(* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES *)
(* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF         *)
(* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR  *)
(* ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES   *)
(* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN    *)
(* ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF  *)
(* OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.           *)

uses Dos, SysUtils, StrUtils, Types;

{ Information Code }

var
 MESSAGESFILE: String;

procedure PrintHelp;
begin
  writeln('pasmotd - pascal message of the day');
  writeln('Prints out a random string from ', MESSAGESFILE);
  writeln('Usage: pasmotd <--help or color> <style1> <style2> ...');
  writeln;
  writeln('Colors: black, red, green, yellow, blue, magenta');
  writeln('        , cyan, white, brightblack, brightred, ');
  writeln('        brightgreen, brightyellow, brightblue, ');
  writeln('        brightmagenta, brightcyan, brightwhite');
  writeln;
  writeln('Styles: bold, dim, italic, underline, slowblink');
  writeln('        , rapidblink, reverse, normal');
  writeln;
  writeln('If the program only seems to output "Freeman you fool!",');
  writeln('make sure your lines file isn''t empty!');
  halt;
end;

{ Program Code }

function GetColor(const AColor: String): Word;
begin
  case AColor of
    'black':         GetColor := 30;
    'red':           GetColor := 31;
    'green':         GetColor := 32;
    'yellow':        GetColor := 33;
    'blue':          GetColor := 34;
    'magenta':       GetColor := 35;
    'cyan':          GetColor := 36;
    'white':         GetColor := 37;
    'brightblack':   GetColor := 90;
    'brightred':     GetColor := 91;
    'brightgreen':   GetColor := 92;
    'brightyellow':  GetColor := 93;
    'brightblue':    GetColor := 94;
    'brightmagenta': GetColor := 95;
    'brightcyan':    GetColor := 96;
    'brightwhite':   GetColor := 97;
  else
    GetColor := 37;
  end;
end;

function GetStyling(const AStyle: String): Word;
begin
  case AStyle of
    'normal':     GetStyling := 0;
    'bold':       GetStyling := 1;
    'dim':        GetStyling := 2;
    'italic':     GetStyling := 3;
    'underline':  GetStyling := 4;
    'slowblink':  GetStyling := 5;
    'rapidblink': GetStyling := 6;
    'reverse':    GetStyling := 7;
  else
    GetStyling := 0;
  end;
end;

type
  TWordArray = array of Word;

var
  motdfile: TextFile;
  lines: TStringDynArray;
  color, style, i: Word;
  styles: TWordArray;
  message: String;
begin
  // Intialise MESSAGESFILE path
  if (GetEnv('XDG_CONFIG_HOME') = '') then
    MESSAGESFILE := GetEnv('HOME')+'/.config/'
  else
    MESSAGESFILE := GetEnv('XDG_CONFIG_HOME')+'/';

  MESSAGESFILE := MESSAGESFILE+'pasmotd/lines.txt';

  color := GetColor('default');
  styles := [GetStyling('reset')];

  // Parse Parameters
  if ParamCount() > 0 then
  begin
    if (ParamStr(1) = '--help') then
      PrintHelp;

    color := GetColor(ParamStr(1));
    if (ParamCount() > 1) then // ANSI Styles
    begin
      SetLength(styles, 0);

      for i := 2 to ParamCount() do
      begin
        SetLength(styles, Length(styles)+1);
        styles[Length(styles)-1] := GetStyling(ParamStr(i));
      end;
    end;
  end;

  // Read Lines
  if not FileExists(MESSAGESFILE) then
  begin
    writeln('File "', MESSAGESFILE, '" does not exist.');
    writeln('Please create and add messages to it!');
    halt;
  end;

  Assign(motdfile, MESSAGESFILE);
  Reset(motdfile);
  while not eof(motdfile) do
  begin
    SetLength(lines, Length(lines)+1);
    readln(motdfile, lines[Length(lines)-1]);
  end;
  Close(motdfile);

  // Output
  randomize;
  if (Length(lines) = 0) then
    message := 'Freeman you fool!'
  else
    message := lines[random(Length(lines)-1)];

  for style in styles do
    write(Format(#27'[%dm', [style]));
  writeln(Format(#27'[%dm%s'#27'[0m', [color, message]));
end.
