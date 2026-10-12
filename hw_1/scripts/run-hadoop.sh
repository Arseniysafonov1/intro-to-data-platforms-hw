#!/bin/bash

ssh -i ~/.ssh/team_internal team@team-25-nn "sudo -u hadoop -H bash -lc 'hdfs namenode -format -force'"

ssh -i ~/.ssh/team_internal team@team-25-nn "sudo -u hadoop -H bash -lc 'start-dfs.sh'"
