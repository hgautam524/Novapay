select
    {{ dbt_utils.generate_surrogate_key(['MERCHANT_ID']) }} as merchant_sk,
    MERCHANT_ID as merchant_id,
    MERCHANT_NAME as merchant_name,
    MERCHANT_CATEGORY as merchant_category,
    MERCHANT_CITY as merchant_city,
    MCC_CODE as country_code,
    CASE 
        WHEN LOWER(IS_ACTIVE) = 'true' THEN TRUE 
        ELSE FALSE 
    END as is_active_flag,
    CAST(ONBOARDING_DATE AS DATE) as onboarding_date,
    _LOADED_AT as loaded_at
from {{ source('transaction_sources', 'merchants') }}