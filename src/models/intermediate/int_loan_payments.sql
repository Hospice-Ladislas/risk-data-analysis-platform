{{ config(tags = ["application", "payment"]) }}

WITH loan_payment AS
(
    SELECT
        payment.previousLoanId,
        payment.loanId,
        payment.numInstalmentNumber,
        current_application.disbursementDate + payment.daysInstalmentScheduled AS paymentDateScheduled,
        payment.daysInstalmentScheduled,
        current_application.disbursementDate + payment.daysInstalmentPaid AS paymentDatePaid,
        payment.daysInstalmentPaid,
        payment.amtInstalmentScheduled,
        payment.amtInstalmentPaid,
        current_application.disbursementDate,
        previous_application.amtCredit,
        -- One instalment can have several payment rows, so the tie-breakers
        -- keep the running total the same on every run.
        SUM(payment.amtInstalmentPaid) OVER (
            PARTITION BY payment.previousLoanId
            ORDER BY payment.numInstalmentNumber, payment.daysInstalmentPaid, payment.amtInstalmentPaid
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulativeAmtInstalmentPaid
    FROM {{ ref("stg_home_credit__installments_payments") }} AS payment
    LEFT JOIN {{ ref("stg_home_credit__application_train") }} AS current_application
        ON current_application.loanId = payment.loanId
    LEFT JOIN {{ ref("stg_home_credit__previous_application") }} AS previous_application
        ON previous_application.previousLoanId = payment.previousLoanId
)

SELECT
    previousLoanId,
    loanId,
    numInstalmentNumber,
    paymentDateScheduled,
    daysInstalmentScheduled,
    paymentDatePaid,
    daysInstalmentPaid,
    amtInstalmentScheduled,
    amtInstalmentPaid,
    disbursementDate,
    amtCredit,
    cumulativeAmtInstalmentPaid,
    amtCredit - cumulativeAmtInstalmentPaid AS remainingAmtCredit
FROM loan_payment
