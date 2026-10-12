#!/bin/bash

HADOOP_HOME=/home/hadoop/hadoop-3.4.0
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

cat > profile.hadoop <<EOF
export HADOOP_HOME=$HADOOP_HOME
export JAVA_HOME=$JAVA_HOME
export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin
EOF

cat > hadoop-env.sh <<EOF
export JAVA_HOME=$JAVA_HOME
EOF

cat > core-site.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://team-25-nn:9000</value>
    </property>
</configuration>
EOF

cat > hdfs-site.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>3</value>
    </property>
    <property>
        <name>dfs.namenode.rpc-address</name>
        <value>team-25-nn:9000</value>
    </property>
    <property>
        <name>dfs.namenode.http-address</name>
        <value>0.0.0.0:9870</value>
    </property>
</configuration>
EOF

cat > workers <<'EOF'
# localhost
team-25-nn
team-25-00
team-25-01
EOF

for node in team-25-nn team-25-00 team-25-01; do
    scp -i ~/.ssh/team_internal profile.hadoop team@$node:/tmp/profile.hadoop
    ssh -i ~/.ssh/team_internal team@$node "sudo mv /tmp/profile.hadoop /home/hadoop/.profile && sudo chown hadoop:hadoop /home/hadoop/.profile"

    scp -i ~/.ssh/team_internal hadoop-env.sh core-site.xml hdfs-site.xml workers team@$node:/tmp/
    ssh -i ~/.ssh/team_internal team@$node "sudo mv /tmp/hadoop-env.sh /tmp/core-site.xml /tmp/hdfs-site.xml /tmp/workers $HADOOP_HOME/etc/hadoop/ && sudo chown hadoop:hadoop $HADOOP_HOME/etc/hadoop/hadoop-env.sh $HADOOP_HOME/etc/hadoop/core-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml $HADOOP_HOME/etc/hadoop/workers"
done
