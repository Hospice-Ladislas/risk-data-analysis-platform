{{ config(tags = ["application", "application_train"]) }}

-- The source has no calendar dates, only day offsets. We derive a fake
-- disbursement date between 2020-01-01 and 2026-10-01 by hashing the loan id,
-- so the same loan always gets the same date on every run.
SELECT
    SK_ID_CURR AS loanId,
    DATE_ADD(
        DATE '2020-01-01',
        INTERVAL MOD(
            ABS(FARM_FINGERPRINT(CAST(SK_ID_CURR AS STRING))),
            DATE_DIFF(DATE '2026-10-01', DATE '2020-01-01', DAY) + 1
        ) DAY
    ) AS disbursementDate
FROM {{ source("home_credit", "application_train") }}
