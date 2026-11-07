# Risk Data Analysis Platform (dbt)

Credit risk pipeline on BigQuery built from the
[Home Credit Default Risk](https://www.kaggle.com/c/home-credit-default-risk) dataset.
It tracks how much of each previous loan has been repaid over time.

## Lineage

```
raw.application_train      ─► stg_home_credit__application_train      ─┐
raw.previous_application   ─► stg_home_credit__previous_application   ─┼─► int_loan_payments
raw.installments_payments  ─► stg_home_credit__installments_payments  ─┘
```

| Layer | Dataset | Materialization | Purpose |
|---|---|---|---|
| sources | `raw` | tables | CSVs loaded as-is |
| staging | `staging` | views | rename and cast columns, one model per source table |
| intermediate | `intermediate` | tables | join and compute repayment metrics |

## Setup

1. Put the CSVs in `data/raw/` (ignored by git).
2. Load them into BigQuery: `./scripts/load_raw_data.sh`
3. Make sure `~/.dbt/profiles.yml` has a `risk_data_analysis_platform` profile.
4. From `src/`: `dbt build`. This runs the models and their tests.

## Conventions

- Models: `stg_<source>__<table>`, `int_<topic>`.
- Columns: camelCase.
- Materialization and schema are set per folder in `dbt_project.yml`.
- Each folder has a `_<folder>__models.yml` with descriptions and tests.
