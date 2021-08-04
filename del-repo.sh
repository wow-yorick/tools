#!/bin/bash

GITHUB_TOKEN=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
repos=(
    "wow-yorick/eopl3"
    "wow-yorick/baiduyun"
)

for i in "${repos[@]}"
do :
    echo $i
   curl -v -k -XGET -H 'Authorization: token $GITHUB_TOKEN' "https://api.github.com/repos/$i ";
done
