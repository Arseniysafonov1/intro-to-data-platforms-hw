#!/bin/bash

sudo -u hadoop -H bash -c 'test -f ~/.ssh/id_ed25519 || ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519'

sudo -u hadoop -H bash -c 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys && sort -u ~/.ssh/authorized_keys -o ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'

sudo cp /home/hadoop/.ssh/id_ed25519     /tmp/id_ed25519
sudo cp /home/hadoop/.ssh/id_ed25519.pub /tmp/id_ed25519.pub
sudo chown team:team /tmp/id_ed25519 /tmp/id_ed25519.pub
mv /tmp/id_ed25519 /tmp/id_ed25519.pub .

for node in team-25-nn team-25-00 team-25-01; do
    scp -i ~/.ssh/team_internal id_ed25519 id_ed25519.pub team@$node:/tmp/

    ssh -i ~/.ssh/team_internal team@$node "sudo mv /tmp/id_ed25519 /home/hadoop/.ssh/id_ed25519 && \
        sudo mv /tmp/id_ed25519.pub /home/hadoop/.ssh/id_ed25519.pub && \
        sudo chown hadoop:hadoop /home/hadoop/.ssh/id_ed25519 /home/hadoop/.ssh/id_ed25519.pub && \
        sudo chmod 600 /home/hadoop/.ssh/id_ed25519 && \
        sudo chmod 644 /home/hadoop/.ssh/id_ed25519.pub"

    ssh -i ~/.ssh/team_internal team@$node "sudo -u hadoop -H bash -c 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys && sort -u ~/.ssh/authorized_keys -o ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'"
done
