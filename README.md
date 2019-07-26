# purs-src-json

[![Build Status](https://travis-ci.com/justinwoo/purs-src-json.svg?branch=master)](https://travis-ci.com/justinwoo/purs-src-json)

```
$ purs-src-json
purs-src-json:
  get PureScript sources concrete syntax tokens as JSONL
  and convert the CST JSONL into PureScript source.

usage:
  to [filepath.purs]
  convert the file given at filepath.purs to JSONL.

  from [filepath.jsonl]
    convert the JSONL given at filepath.jsonl

what is JSONL:
  JSONL is JSON Lines, where no newlines are allowed in the contents,
  but each line is a valid JSON object.

see purs-src-json/src/PSJ/Types.hs
```

## Complaints

PRs welcome
