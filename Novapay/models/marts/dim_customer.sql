{{ config(
    materialized='table',
    schema='DIMENSIONAL'
) }}

with customers as (
    select * from {{ ref('stg_crm__customers') }}
),

latest_credit_scores as (
    select * from {{ ref('stg_vendor__credit_scores') }}
    qualify row_number() over (partition by customer_id order by score_date desc) = 1
),

final as (
    select
        c.customer_sk,
        c.customer_id,
        c.customer_tier,
        c.first_name,
        c.last_name,
        c.email,
        c.address_city,
        c.address_country,
        c.is_active,
        s.credit_score,
        s.risk_category
    from customers c
    left join latest_credit_scores s 
        on c.customer_id = s.customer_id
)

select * from final