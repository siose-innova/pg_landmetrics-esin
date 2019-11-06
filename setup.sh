#!/bin/bash

set -e

# Perform all actions as user 'postgres'
export PGUSER="postgres"

echo "Load pg_landmetrics extension into target database"
echo "Target database name is $ECO_DB"
psql --dbname="$ECO_DB" <<-'EOSQL'
CREATE EXTENSION IF NOT EXISTS pg_landmetrics;
EOSQL
