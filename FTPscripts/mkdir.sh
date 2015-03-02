#!/bin/bash


NAMES="$(< names.txt)"
for NAME in $NAMES; do
	mkdir "$NAME"
done
