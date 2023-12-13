#!/bin/bash

set -eo pipefail

mkdir -p "$par_output"

files=$(echo $par_input | tr ";" "\n")

for file in $files; do
  cp -r "$file" "$par_output"
done

