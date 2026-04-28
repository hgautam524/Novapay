{% snapshot snapshot_customers %}

{{
    config(
        target_database='NOVAPAY_DWH',
        target_schema='SNAPSHOTS',
        unique_key='CUSTOMER_ID',
        strategy='check',
        check_cols=['CUSTOMER_TIER', 'ADDRESS_CITY', 'ADDRESS_COUNTRY', 'IS_ACTIVE'],
    )
}}

select * from {{ ref('stg_crm__customers') }}

{% endsnapshot %}