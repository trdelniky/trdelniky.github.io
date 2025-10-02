# Pomocné skripty

## Import anotované bibliografie z Vimwiki

Anotovaná bibliografie se nachází v mojí osobní Vimwiki, takže je třeba jí naimportovat pomocí 

```bash
$ lua vimwiki_import.lua
```

## Export citací z České digitální knihovny

```bash
$ lua ndk_bib.lua <volby> url 
```

Volby: 

- `-f,--format`: bibtex (default), wiki
- `-h,--help`: nápověda
- `-o,--output`: jméno výstupního souboru

