#!/bin/bash
# Dockerfile directory hash checker
# Used by: ecr-push.tf
# Manual Use:
# $ ./hash.sh .

set -e

source_path=${1:-.}

file_hashes="$(
    cd "$source_path" \
    && find . -type f -not -name '*.md' -not -path './.**' \
    | sort \
    | xargs md5sum
)"

hash="$(echo "$file_hashes" | md5sum | cut -d' ' -f1)"

echo '{ "hash": "'"$hash"'" }'

# Manual way to check a directory hash: 
# find . -type f -not -name '*.md' -not -path './.**' | sort | xargs md5sum | md5sum | cut -d' ' -f1