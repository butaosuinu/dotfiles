#!/bin/bash

echo "Installing VSCode extensions..."
cat ./vscode/extensions.txt | while read line; do
  code --install-extension "$line"
done

echo "Installing Cursor extensions..."
cat ./cursor/extensions.txt | while read line; do
  cursor --install-extension "$line"
done

echo "Done!"
