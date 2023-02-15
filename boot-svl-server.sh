#!/bin/bash

check_lab_svl_status() {
  NUMBER_OF_ALIVE_PROCESS=0

  while read -r process
  do
    # Check whether process is running or not
    if [[ $process == *"Up"* ]]; then
      (( NUMBER_OF_ALIVE_PROCESS ++ ))
    fi
  done < <(sudo docker compose ps | tail -n +2)

  return $NUMBER_OF_ALIVE_PROCESS
}

run_lab_svl() {
  sudo docker compose up -d
}

DATE=$(date +%F_%T)
echo "$DATE: Check lab server status"

# Go to lab server path
cd $LAB_SVL_DOCKER_PATH

# Check current server's status
check_lab_svl_status
ALIVE_PROCESSES=$?

echo "Currently $ALIVE_PROCESSES processes are alive"

# If server is not alive, boot up lab server
if [ $ALIVE_PROCESSES -lt 4 ]; then
  echo "Since server is not fully alive, boot up lab server"
  run_lab_svl
fi
