#!/usr/bin/env bash
set -e

INFILE=".env.local"
OUTFILE=".env"

if [ ! -f "$INFILE" ]; then
  echo "$INFILE not found!"
  exit 1
fi

# Generate a random 24-char alphanumeric password
gen_pass() {
  tr -dc 'A-Za-z0-9' </dev/urandom | head -c 24
}

> "$OUTFILE"
while IFS= read -r line || [ -n "$line" ]; do
  if [[ "$line" =~ (_PASSWORD=|_SECRET=) ]]; then
    key="${line%%=*}"
    echo "$key=$(gen_pass)" >> "$OUTFILE"
  else
    echo "$line" >> "$OUTFILE"
  fi
done < "$INFILE"

echo "Generated $OUTFILE with random secrets."
