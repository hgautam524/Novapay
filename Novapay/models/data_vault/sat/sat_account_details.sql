{{ config(materialized='incremental', schema='DATA_VAULT') }}

{%- set source_model = "stg_vlt_accounts" -%}
{%- set src_pk = "ACCOUNT_HK" -%}
{%- set src_hashdiff = "HASHDIFF" -%}
{%- set src_payload = ["ACCOUNT_TYPE", "ACCOUNT_STATUS", "CURRENCY_CODE", "CREDIT_LIMIT", "CURRENT_BALANCE"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk,
                   src_hashdiff=src_hashdiff,
                   src_payload=src_payload,
                   src_ldts=src_ldts,
                   src_source=src_source,
                   source_model=source_model) }}