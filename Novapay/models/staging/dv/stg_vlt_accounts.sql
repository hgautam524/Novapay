{%- set yaml_metadata -%}
source_model: 
  transaction_sources: "accounts"
derived_columns:
  RECORD_SOURCE: "!TXN_ACCOUNTS"
  LOAD_DATETIME: "CURRENT_TIMESTAMP()"
hashed_columns:
  ACCOUNT_HK: "ACCOUNT_ID"
  CUSTOMER_HK: "CUSTOMER_ID"
  CUSTOMER_ACCOUNT_HK:
    - "CUSTOMER_ID"
    - "ACCOUNT_ID"
  HASHDIFF:
    is_hashdiff: true
    columns:  
      - "ACCOUNT_TYPE"
      - "ACCOUNT_STATUS"
      - "CURRENCY_CODE"
      - "CREDIT_LIMIT"
      - "CURRENT_BALANCE"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}