{{ config(materialized='incremental', schema='DATA_VAULT') }}

{%- set source_model = "stg_vlt_customers" -%}
{%- set src_pk = "CUSTOMER_HK" -%}
{%- set src_hashdiff = "HASHDIFF" -%}
{%- set src_payload = ["FIRST_NAME", "LAST_NAME", "EMAIL", "PHONE_NUMBER", "CUSTOMER_TIER", "DATE_OF_BIRTH", "ADDRESS_CITY", "ADDRESS_COUNTRY"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk,
                   src_hashdiff=src_hashdiff,
                   src_payload=src_payload,
                   src_ldts=src_ldts,
                   src_source=src_source,
                   source_model=source_model) }}