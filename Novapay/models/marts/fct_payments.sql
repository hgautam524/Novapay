{{ config(
    materialized='incremental',
    schema='DIMENSIONAL',
    unique_key='transaction_key',
    incremental_strategy='merge'
) }}

with enriched_payments as (
    select * from {{ ref('int_payments_fct') }}
    
    {% if is_incremental() %}
    
    where _loaded_at >= (select dateadd(day, -3, max(dbt_updated_at)) from {{ this }})
    {% endif %}
),

deduped_payments as (
    select *
    from (
        select *,
            row_number() over (partition by payment_sk order by _loaded_at desc) as rn
        from enriched_payments
    )
    where rn = 1
)

select
    
    payment_sk as transaction_key,
    customer_id,
    account_id,
    merchant_id,
    payment_date as date_key,
    payment_amount,
    fee_amount,
    net_amount,
    is_refund,
    
    _loaded_at as dbt_updated_at
from deduped_payments