#!/bin/bash

ssh -i ~/.ssh/team_internal team@team-25-nn 'sudo -u hadoop -H bash -c "test -f ~/.ssh/id_ed25519 || ssh-keygen -t ed25519 -N \"\" -f ~/.ssh/id_ed25519"'

ssh -i ~/.ssh/team_internal team@team-25-nn "sudo -u hadoop -H bash -c 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'"

ssh -i ~/.ssh/team_internal team@team-25-nn "sudo cat /home/hadoop/.ssh/id_ed25519"     > id_ed25519.tmp
ssh -i ~/.ssh/team_internal team@team-25-nn "sudo cat /home/hadoop/.ssh/id_ed25519.pub" > id_ed25519.pub.tmp

for node in team-25-nn team-25-00 team-25-01; do
    scp -i ~/.ssh/team_internal id_ed25519.tmp id_ed25519.pub.tmp team@$node:/tmp/
    ssh -i ~/.ssh/team_internal team@$node "sudo mv /tmp/id_ed25519.tmp /home/hadoop/.ssh/id_ed25519 && sudo mv /tmp/id_ed25519.pub.tmp /home/hadoop/.ssh/id_ed25519.pub && sudo chown hadoop:hadoop /home/hadoop/.ssh/id_ed25519 /home/hadoop/.ssh/id_ed25519.pub && sudo chmod 600 /home/hadoop/.ssh/id_ed25519 && sudo chmod 644 /home/hadoop/.ssh/id_ed25519.pub"

    ssh -i ~/.ssh/team_internal team@$node "sudo -u hadoop -H bash -c 'cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys && sort -u ~/.ssh/authorized_keys -o ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'"
done
