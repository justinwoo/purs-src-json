#!/usr/bin/env bash

# from does not introduce changes
>test/testOutput.json stack run -- to test/testFile.purs
git diff --exit-code

# to does introduce changes
>test/testFile.purs stack run -- from test/testOutput.json
git diff --exit-code
