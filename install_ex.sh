#!/bin/sh

cat ./vs_code_extensions.txt | while read line
do
  code --install-extension $line
done

