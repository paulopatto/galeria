#!/usr/bin/env sh
# vim: set ft=sh :

zip ../$(echo "0.0.0-$(git branch | grep \* | cut -d ' ' -f2)-$(git describe --always)").zip -r * .[^.]*
