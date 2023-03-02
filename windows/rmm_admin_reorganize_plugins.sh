#!/bin/sh
dest=/usr/local/corp/admin/plugins/all-latest-plugins
rm $dest/*
for D in /usr/local/corp/admin/plugins/corp*; do
    echo "$D"
    cd $D
    cp "$(ls -t $D | head -1)" $dest
done
