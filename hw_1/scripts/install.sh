#!/bin/bash

wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz

for node in team-25-nn team-25-00 team-25-01; do
    ssh -i ~/.ssh/team_internal team@$node "sudo apt install -y openjdk-11-jdk-headless"

    scp -i ~/.ssh/team_internal hadoop-3.4.0.tar.gz team@$node:/tmp/
    ssh -i ~/.ssh/team_internal team@$node "sudo mv /tmp/hadoop-3.4.0.tar.gz /home/hadoop/ && sudo chown hadoop:hadoop /home/hadoop/hadoop-3.4.0.tar.gz"

    ssh -i ~/.ssh/team_internal team@$node "sudo -u hadoop -H bash -c 'cd ~ && tar -xzf hadoop-3.4.0.tar.gz'"
done
