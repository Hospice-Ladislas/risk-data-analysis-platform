{{ config(tags = ["application", "previous_application"]) }}

SELECT
    SK_ID_PREV AS previousLoanId,
    CAST(AMT_CREDIT AS FLOAT64) AS amtCredit
FROM {{ source("home_credit", "previous_application") }}
