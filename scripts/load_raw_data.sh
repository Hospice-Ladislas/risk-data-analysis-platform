#!/usr/bin/env bash
# Loads the Home Credit CSVs from data/raw/ into the BigQuery `raw` dataset.
# Usage: ./scripts/load_raw_data.sh
# Override defaults with GCP_PROJECT, BQ_DATASET, BQ_LOCATION or DATA_DIR.
set -euo pipefail

PROJECT="${GCP_PROJECT:-data-platform-dev-2026}"
DATASET="${BQ_DATASET:-raw}"
LOCATION="${BQ_LOCATION:-EU}"
DATA_DIR="${DATA_DIR:-$(dirname "$0")/../data/raw}"

for table in application_train previous_application installments_payments; do
  echo "Loading ${table}..."
  bq load \
    --project_id="${PROJECT}" \
    --location="${LOCATION}" \
    --source_format=CSV \
    --skip_leading_rows=1 \
    --autodetect \
    --replace \
    "${DATASET}.${table}" \
    "${DATA_DIR}/${table}.csv"
done

echo "Done."
