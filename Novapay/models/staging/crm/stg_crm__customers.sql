select
    {{ dbt_utils.generate_surrogate_key(["RAW_DATA:customer_id::VARCHAR"]) }} as customer_sk,
    RAW_DATA:customer_id::VARCHAR as customer_id,
    RAW_DATA:first_name::VARCHAR as first_name,
    RAW_DATA:last_name::VARCHAR as last_name,
    RAW_DATA:email::VARCHAR as email,
    RAW_DATA:phone::VARCHAR as phone_number,
    RAW_DATA:date_of_birth::DATE as date_of_birth,
    RAW_DATA:customer_since::DATE as customer_since,
    RAW_DATA:address:city::VARCHAR as address_city,
    RAW_DATA:address:country::VARCHAR as address_country,
    RAW_DATA:is_active::BOOLEAN as is_active,
    _LOADED_AT as _loaded_at,
from {{ source('crm_sources', 'customers') }}