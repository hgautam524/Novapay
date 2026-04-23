{{
    config(
        materialized='incremental',
        unique_key='payment_sk'
    )
}}

WITH source AS (
    SELECT * FROM {{ source('transaction_sources', 'payments') }}
    {% if is_incremental() %}
        WHERE _LOADED_AT >= (SELECT MAX(_LOADED_AT) FROM {{ this }}) - INTERVAL '3 days'
    {% endif %}
),

deduplicated AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['PAYMENT_ID']) }} AS payment_sk,
        PAYMENT_ID as payment_id,
        CUSTOMER_ID as customer_id,
        ACCOUNT_ID as account_id,
        MERCHANT_ID as merchant_id,
        CAST(PAYMENT_AMOUNT AS NUMBER(18, 2)) as payment_amount,
        PAYMENT_CURRENCY as payment_currency,
        PAYMENT_STATUS as payment_status,
        CAST(PAYMENT_DATE AS DATE) as payment_date,
        CAST(PAYMENT_TIMESTAMP AS TIMESTAMP_TZ) as payment_timestamp,
        CAST(FEE_AMOUNT AS NUMBER(18, 2)) as fee_amount,
        CASE
            WHEN LOWER(IS_INTERNATIONAL) = 'true' THEN TRUE
            ELSE FALSE
        END as is_international,
        CAST(RISK_SCORE AS NUMBER(10, 0)) as risk_score,
        _LOADED_AT as _loaded_at
    FROM source

    QUALIFY ROW_NUMBER() OVER (PARTITION BY PAYMENT_ID ORDER BY _LOADED_AT DESC) = 1
)

SELECT * FROM deduplicated