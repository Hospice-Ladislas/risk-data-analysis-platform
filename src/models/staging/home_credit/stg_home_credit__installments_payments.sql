{{ config(tags = ["application", "payment"]) }}

SELECT
    SK_ID_CURR AS loanId,
    SK_ID_PREV AS previousLoanId,
    CAST(NUM_INSTALMENT_NUMBER AS INT64) AS numInstalmentNumber,
    CAST(CAST(DAYS_INSTALMENT AS FLOAT64) AS INT64) AS daysInstalmentScheduled,
    CAST(CAST(DAYS_ENTRY_PAYMENT AS FLOAT64) AS INT64) AS daysInstalmentPaid,
    CAST(AMT_INSTALMENT AS FLOAT64) AS amtInstalmentScheduled,
    CAST(AMT_PAYMENT AS FLOAT64) AS amtInstalmentPaid
FROM {{ source("home_credit", "installments_payments") }}
