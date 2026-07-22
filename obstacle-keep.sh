#!/bin/bash

set -uo pipefail


while true; do

if ! ./ob.rb; then

echo "$(date): ob.rb failed to generate the course; skipping server launch and retrying" | tee -a obs.log >&2
sleep 4
continue

fi



sleep 4

if ! bzfs -world obs.bzw >> obs.log 2>&1; then

echo "$(date): bzfs exited with an error (see obs.log)" | tee -a obs.log >&2

fi

sleep 3

done
