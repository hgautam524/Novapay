{{ config(materialized='incremental', unique_key='interaction_sk') }}

with source as (
    select * from {{ source('crm_sources', 'customer_interactions') }}
    {% if is_incremental() %}
      where _LOADED_AT >= (select dateadd(day, -3, max(loaded_at)) from {{ this }})
    {% endif %}
),
renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['raw_data:interaction_id']) }} as interaction_sk,
        raw_data:interaction_id::varchar as interaction_id,
        raw_data:customer_id::varchar as customer_id,
        raw_data:agent_id::varchar as agent_id,
        raw_data:interaction_type::varchar as interaction_type,
        raw_data:interaction_date::date as interaction_date,
        raw_data:status::varchar as status,
        raw_data:priority::varchar as priority,
        raw_data:subject::varchar as subject,
        raw_data:csat_score::number(4, 2) as csat_score,
        raw_data:resolution_time_hours::number(10, 2) as resolution_time_hours,
        _LOADED_AT as loaded_at,
    from source
)
select * from renamed