{{ config(
    materialized='table',
    schema='DIMENSIONAL'
) }}

WITH source AS (
    SELECT * FROM {{ ref('stg_txn__payments') }}

),

deduplicated AS (
    SELECT * FROM source
    QUALIFY ROW_NUMBER() OVER (PARTITION BY payment_id ORDER BY _LOADED_AT DESC) = 1
),

final AS (
    SELECT
         payment_sk,
        payment_id,
        customer_id,
        account_id,
        merchant_id,
        payment_date,
        payment_timestamp,
        payment_amount,
        fee_amount,
        payment_currency,
        payment_status,
        is_international,
        risk_score
    FROM deduplicated
)

SELECT * FROM final