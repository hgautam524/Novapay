select
    {{ dbt_utils.generate_surrogate_key(['CUSTOMER_ID', 'SCORE_DATE']) }} as credit_score_sk,
    CUSTOMER_ID as customer_id,
    cast(SCORE_DATE as date) as score_date,
    cast(CREDIT_SCORE as number(3,0)) as credit_score,
    SCORE_PROVIDER AS score_provider,
    RISK_CATEGORY AS risk_category,
    CASE
        WHEN LOWER(TRIM(DELINQUENCY_FLAG)) = 'true' THEN TRUE
        ELSE FALSE
    END AS is_delinquent,
    CASE
        WHEN LOWER(TRIM(BANKRUPTCY_FLAG)) = 'true' THEN TRUE
        ELSE FALSE
    END AS is_bankrupt,
    CAST(INQUIRY_COUNT AS NUMBER(10, 0)) AS inquiry_count,
    CAST(TOTAL_ACCOUNTS AS NUMBER(10, 0)) AS total_accounts,
    _LOADED_AT AS _loaded_at,
from {{ source('vendor_sources', 'credit_scores') }}