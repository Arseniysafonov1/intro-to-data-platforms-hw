#!/bin/bash

for node in team-25-nn team-25-00 team-25-01; do
    ssh -i ~/.ssh/team_internal team@$node "sudo apt update -y && sudo apt upgrade -y"
  
    ssh -i ~/.ssh/team_internal team@$node "sudo adduser --disabled-password --gecos '' hadoop"
    ssh -i ~/.ssh/team_internal team@$node "echo 'hadoop:really-difficult-password' | sudo chpasswd"
done
