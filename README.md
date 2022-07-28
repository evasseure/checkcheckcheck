# checkcheckcheck

A small Spelling Corrector written with Elixir to discover the language, and learn some new things!

## Usage

To get errors and suggestions from an input file or a string:  
`mix correct FILE_PATH | STRING`

## Examples

```
$ mix correct "hello wrld waht is up?"
Errors in input:
Word: wrld, Suggestions: [world, wild, weld]
Word: waht, Suggestions: [what, wat, wah]
```

```
$ mix correct ./data/inputs/ashford-short.txt
Errors in input:
Word: peaple, Suggestions: [people, peale, pepple]
Word: salteena, Suggestions: []
Word: wiskers, Suggestions: [whiskers, weskers, wishers]
... lots more
```

## Running tests

Simply run: `mix test`

## Performance tests

`./data/inputs/ashford-short.txt`  
Total time: 1.17s  
Words: 490  
Words per second: 416.41 word/s

`./data/inputs/ashford.txt`  
Total time: 58.44s  
Words: 12,484  
Words per second: 213.6 word/s

`"hello wrld waht is up?"`  
Total time: 0.10s  
Words: 5  
Words per second: 47.88 word/s
