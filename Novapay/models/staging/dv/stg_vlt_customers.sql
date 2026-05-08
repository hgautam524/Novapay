{%- set yaml_metadata -%}
source_model: 
  crm_sources: "customers"
derived_columns:
  RECORD_SOURCE: "!CRM_CUSTOMERS"
  LOAD_DATETIME: "_LOADED_AT"
  CUSTOMER_ID: "RAW_DATA:customer_id::VARCHAR"
  ACCOUNT_ID: "RAW_DATA:account_id::VARCHAR"
  FIRST_NAME: "RAW_DATA:first_name::VARCHAR"
  LAST_NAME: "RAW_DATA:last_name::VARCHAR"
  EMAIL: "RAW_DATA:email::VARCHAR"
  PHONE_NUMBER: "RAW_DATA:phone::VARCHAR"
  CUSTOMER_TIER: "RAW_DATA:customer_tier::VARCHAR"
  DATE_OF_BIRTH: "RAW_DATA:date_of_birth::DATE"
  ADDRESS_CITY: "RAW_DATA:address:city::VARCHAR"
  ADDRESS_COUNTRY: "RAW_DATA:address:country::VARCHAR"
hashed_columns:
  CUSTOMER_HK: "CUSTOMER_ID"
  ACCOUNT_HK: "ACCOUNT_ID"
  CUSTOMER_ACCOUNT_HK:
    - "CUSTOMER_ID"
    - "ACCOUNT_ID"
  HASHDIFF:
    is_hashdiff: true
    columns:
      - "FIRST_NAME"
      - "LAST_NAME"
      - "EMAIL"
      - "PHONE_NUMBER"
      - "CUSTOMER_TIER"
      - "DATE_OF_BIRTH"
      - "ADDRESS_CITY"
      - "ADDRESS_COUNTRY"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}