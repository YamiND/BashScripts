#!/bin/bash

grep -v "nologin" /etc/passwd > ~/usersCheck.txt

echo "Users that have a shell other than nologin: "

cat ~/usersCheck.txt
