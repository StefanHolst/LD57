#!/bin/bash

#mv WebExport/LD57.html WebExport/index.html
git add WebExport
git commit -m"Exporting"
git subtree push --prefix WebExport origin gh-pages
