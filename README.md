# checkcheckcheck

A small Spelling Corrector written with Elixir to discover the language, and learn some new things!  
Things are not ideal, especially for huge text files, since I use a `Task.await_many` (with a huge timeout), which kinda goes against the idea of low-latency, distributed, and fault-tolerance. This is not how it should work in a real world application, but this is just a toy project/script.

The implementation is heavely inspired by Peter Norvig's article on [How to Write a Spelling Corrector](http://norvig.com/spell-correct.html).  

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

**Tests ran on:**  
MacBook Pro 2019  
2,4 GHz Quad-Core Intel Core i5  
16 GB 2133 MHz LPDDR3

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

## Further improvements

- [ ] Improve handling of big files
- [ ] Setup a Phoenix front-end
- [ ] Use a Rust NIF to improve speed? (See [#1](https://github.com/evasseure/checkcheckcheck/pull/1))
- [ ] Sort suggestions by probability
