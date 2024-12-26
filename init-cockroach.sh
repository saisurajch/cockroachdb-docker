#!/bin/bash

# Directories for certs
CERTS_DIR=/cockroach/certs
CA_KEY=$CERTS_DIR/ca.key

# Create certificates if not already generated
if [ ! -f "$CA_KEY" ]; then
  echo "Generating certificates..."
  cockroach cert create-ca --certs-dir=$CERTS_DIR --ca-key=$CA_KEY
  cockroach cert create-node localhost 127.0.0.1 ::1 --certs-dir=$CERTS_DIR --ca-key=$CA_KEY
  cockroach cert create-client root --certs-dir=$CERTS_DIR --ca-key=$CA_KEY
  cockroach cert create-client app_user --certs-dir=$CERTS_DIR --ca-key=$CA_KEY
fi

# Start CockroachDB in the background to perform initialization
cockroach start-single-node --certs-dir=$CERTS_DIR --background

# Wait for the database to start
echo "Waiting for CockroachDB to initialize..."
sleep 5

# Create users and set passwords
echo "Creating users and setting passwords..."
cockroach sql --certs-dir=$CERTS_DIR <<EOF
ALTER USER root WITH PASSWORD 'suraj@1234';
CREATE USER app_user WITH PASSWORD 'suraj@1234';
GRANT ALL ON DATABASE defaultdb TO app_user;
EOF

# Stop the background process
cockroach quit --certs-dir=$CERTS_DIR --decommission

# Relaunch CockroachDB normally
exec "$@"
