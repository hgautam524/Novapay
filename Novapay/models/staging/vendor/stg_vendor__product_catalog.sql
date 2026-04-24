select
    {{ dbt_utils.generate_surrogate_key(['PRODUCT_ID']) }} as product_sk,
    cast(PRODUCT_ID as varchar) as product_id,
    TRIM(PRODUCT_NAME) AS product_name,
    LOWER(TRIM(PRODUCT_CATEGORY)) AS product_category,
    CAST(MONTHLY_FEE AS NUMBER(10, 2)) AS monthly_fee,
    CAST(TRANSACTION_FEE AS NUMBER(10, 4)) AS transaction_fee,
    CASE
        WHEN LOWER(TRIM(IS_ACTIVE)) = 'true' THEN TRUE
        ELSE FALSE
    END AS is_active,
    CAST(LAUNCH_DATE AS DATE) AS launch_date,
    CAST(NULLIF(TRIM(RETIREMENT_DATE), '') AS DATE) AS retirement_date,
    _LOADED_AT AS _loaded_at,
from {{ source('vendor_sources', 'product_catalog') }}