#!/bin/sh

v=$(cat test)
if test $v -eq 0; then
    exit 1
else
    exit 0
fi
