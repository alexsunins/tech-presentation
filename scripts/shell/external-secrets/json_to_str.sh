#! /bin/sh

# takes $1 as base64 encoded JSON and returns escaped double-quotes and escaped '\n' with '\\n' (for PEM)

echo "$1" | base64 -d | sed 's/\\n/\\\\n/g' > /tmp/json.string
awk '{printf "%s\\n", $0}' <<<$(cat /tmp/json.string) | sed 's/"/\\"/g'