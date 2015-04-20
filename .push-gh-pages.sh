#!/bin/bash

# copy _site/ from master branch over to gh-pages and push to github
git checkout master
COMMIT=`git rev-parse HEAD`
git checkout gh-pages
rm -rf *
git checkout master -- _site
mv _site/* .
rm -rf _site/
git add *
git commit -m "Site number: ${COMMIT}"
git push origin gh-pages
git checkout master
