select
    COUNTRY_CODE_2 as country_code,
    COUNTRY_NAME as country_name,
    REGION as region,
    SUB_REGION as sub_region,
    _LOADED_AT as loaded_at
from {{ source('reference_sources', 'country_codes') }}