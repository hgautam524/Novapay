{{ config(
    materialized='view',
    schema='intermediate'
) }}

with payments as (
    select * from {{ ref('stg_txn__payments') }}
),

accounts as (
    select * from {{ ref('stg_txn__accounts') }}
)

select
    p.payment_sk,
    p.payment_id,
    p.customer_id,
    p.account_id,
    p.merchant_id,
    p.payment_date,
    a.account_type,
    a.account_status,
    p.payment_amount,
    p.fee_amount,
    cast((coalesce(p.payment_amount, 0) - coalesce(p.fee_amount, 0)) as number(18, 2)) as net_amount,
    
    case when p.payment_amount < 0 then true else false end as is_refund,
    
    p._loaded_at
from payments p
left join accounts a 
    on p.account_id = a.account_id