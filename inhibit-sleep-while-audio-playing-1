#!/bin/bash
# ehh idek
if [[ $(pw-top -bn 2 | awk '$1 ~ /R/ {print "true"}') == "true" ]]; then
  echo "test"
fi

# While audio is playing
while [[ $(pw-top -bn 2 | awk '$1 ~ /R/ {print "1"}') == "1" ]]
do
  # Wait 10 seconds and check again
  sleep 10
  echo $(pw-top -bn 2 | awk '$1 ~ /R/ {print "true"}')
done
