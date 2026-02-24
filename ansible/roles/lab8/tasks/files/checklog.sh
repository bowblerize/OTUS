#!/bin/bash

KEY=$1
DATE=$(date +%Y-%m-%d-%H-%M-%S)
LOG=$2

if grep $KEY $LOG > /dev/null; then
  echo "$DATE: $KEY found in $LOG"
  exit 0
else
  echo "$KEY not found in $LOG"
  exit 1
fi
