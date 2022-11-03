# pasmotd
Program to output an ANSI-Formatted MOTD in console

## Usage
`pasmotd [--help] <color> <styles, seperated with whitespace>`

If no parameters are given, it will just output with hardcoded default settings (white, no style).
A color is requried inorder to specify any amount of styles.

**Example:**
`pasmotd cyan rapidblink bold`

### Configuring Messages
Find out the Store-Path of your messages with the `--help` parameter. Within the specified
file you will be able to add your messages seperated by line.

If you have no lines within the file, "Freeman you fool!" will always be output as a fallback.

## Colors and Styles
```text
Colors: black, red, green, yellow, blue, magenta
        , cyan, white, brightblack, brightred, 
        brightgreen, brightyellow, brightblue, 
        brightmagenta, brightcyan, brightwhite

Styles: bold, dim, italic, underline, slowblink
        , rapidblink, reverse, normal
```
