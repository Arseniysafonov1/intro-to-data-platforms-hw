#!/bin/bash
ssh -i .ssh/team_internal team@team-25-01 'bash -s' <<'EOF'
sudo apt install -y postgresql
sudo sed -i "s/^#\?listen_addresses.*/listen_addresses = 'team-25-01'/" /etc/postgresql/*/main/postgresql.conf
sudo tee -a /etc/postgresql/*/main/pg_hba.conf <<'PGA'
host metastore hive 10.0.0.10/32 password
host metastore hive 10.0.0.11/32 password
host metastore hive 10.0.0.12/32 password
host metastore hive 10.0.0.13/32 password
PGA
sudo systemctl restart postgresql
sudo -u postgres psql -c "CREATE DATABASE metastore;"
sudo -u postgres psql -c "CREATE USER hive WITH PASSWORD 'hive';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE metastore TO hive;"
sudo -u postgres psql -c "ALTER DATABASE metastore OWNER TO hive;"
EOF
